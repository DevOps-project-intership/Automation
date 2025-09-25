import os
import datetime
import psycopg2
from psycopg2.extras import RealDictCursor
from flask import Flask, render_template, request,url_for, redirect, session, flash
from werkzeug.security import generate_password_hash, check_password_hash
from werkzeug.exceptions import abort
from werkzeug.utils import secure_filename
from functools import wraps
from dotenv import load_dotenv

load_dotenv(dotenv_path=".env")

app = Flask(__name__)
app.config['SECRET_KEY'] = os.getenv("SECRET_KEY")

ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg'}
UPLOAD_FOLDER = os.path.join('static', 'images')

app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

# todo: change to sqlAlchemy
def get_db_connection():
    conn = psycopg2.connect(
        host=os.getenv("DATABASE_HOST"),
        database=os.getenv("DATABASE_NAME"),
        user=os.getenv("DATABASE_USER"),
        password=os.getenv("DATABASE_PASSWORD"),
        port=os.getenv("DATABASE_PORT"),
        cursor_factory=RealDictCursor
    )
    return conn


def get_post(post_id):
    conn = get_db_connection()
    try:
        with conn.cursor() as cur:
            cur.execute(f"SELECT * FROM posts WHERE id = {post_id}")
            post = cur.fetchone()
    finally:
        conn.close()
    if post is None:
        abort(404)
    return post

def get_user_posts(user_id):
    conn = get_db_connection()
    try:
        with conn.cursor() as cur:
            cur.execute(f'SELECT * FROM posts WHERE user_id = %s', (user_id,))
            posts = cur.fetchall()
    finally:
        conn.close()
    return posts

def get_fetchall(sql, params=None):
    conn = get_db_connection()
    try:
        with conn.cursor() as cur:
            if params:
                cur.execute(sql, params)
            else:
                cur.execute(sql)
            data = cur.fetchall()
    finally:
        conn.close()
    return data

def get_fetchone(sql, params=None):
    conn = get_db_connection()
    try:
        with conn.cursor() as cur:
            if params:
                cur.execute(sql, params)
            else:
                cur.execute(sql)
            data = cur.fetchone()
    finally:
        conn.close()
    return data

def post_sql(sql, params=None):
    conn = get_db_connection()
    try:
        with conn.cursor() as cur:
            if params:
                cur.execute(sql, params)
            else:
                cur.execute(sql)
        conn.commit()
    finally:
        conn.close()

def login_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if "user_id" not in session:
            flash("You must be logged in to access this page.", "danger")
            return redirect(url_for("login"))
        return f(*args, **kwargs)
    return decorated_function


@app.route('/')
@login_required
def index():
    posts = get_fetchall('SELECT posts.*,users.username FROM posts JOIN users ON posts.user_id = users.id')
    return render_template('index.html', posts=posts)

@app.route("/home")
@login_required
def home():
    if "user_id" in session:
        return render_template("home.html",
                               username=session["username"], 
                               posts=get_user_posts(session["user_id"]))
    return render_template("home.html", username=None)


@app.route("/register", methods=["GET", "POST"])
def register():
    if request.method == "POST":
        username = request.form["username"]
        password = request.form["password"]

        hashed_pw = generate_password_hash(password)

        post_sql("INSERT INTO users (username, password) VALUES (%s, %s)", (username, hashed_pw))    
        flash("Account created! You can now log in.", "success")
        return redirect(url_for("login"))
    return render_template("register.html")


@app.route("/login", methods=["GET", "POST"])
def login():
    if request.method == "POST":
        username = request.form["username"]
        password = request.form["password"]

        user = get_fetchone("SELECT * FROM users WHERE username = %s", (username,))

        if user and check_password_hash(user["password"], password):
            session["user_id"] = user["id"]
            session["username"] = user["username"]
            flash("Login successful!", "success")
            return redirect(url_for("home"))
        else:
            flash("Invalid credentials", "danger")

    return render_template("login.html")


@app.route("/logout")
@login_required
def logout():
    session.clear()
    flash("Logged out.", "info")
    return redirect(url_for("home"))

@app.route('/edit/<int:id>', methods=('GET', 'POST'))
@login_required
def edit(id):
    post = get_post(id)

    if request.method == 'POST':
        location = request.form.get('location', '').strip()
        file = request.files.get('image')
        
        if not location:
            flash('location is required!')
            return render_template('edit.html', post=post)
        
        image_path = None
        if file and file.filename:
            if not allowed_file(file.filename):
                flash('Invalid file type!')
                return render_template('edit.html', post=post)
            
            timestamp = datetime.datetime.now().strftime('%Y%m%d_%H%M%S')
            filename = secure_filename(f"{timestamp}_{file.filename}")
            filepath = os.path.join(app.config['UPLOAD_FOLDER'], filename)
            
            try:
                os.makedirs(app.config['UPLOAD_FOLDER'], exist_ok=True)
                file.save(filepath)
                image_path = f"images/{filename}"
            except OSError as e:
                print(f'Error saving file: {e}')
                return render_template('edit.html', post=post)
        
        try:
            if image_path:
                post_sql('UPDATE posts SET location = %s, image_path = %s WHERE id = %s', 
                        (location, image_path, id))
            else:
                post_sql('UPDATE posts SET location = %s WHERE id = %s', (location, id))
            
            flash('Post updated successfully!')
            return redirect(url_for('index'))
            
        except Exception as e:
            print(f'Database error: {e}')
            return render_template('edit.html', post=post)

    return render_template('edit.html', post=post)

@app.route('/delete/<int:id>', methods=('POST',))
@login_required
def delete(id):
    post_sql(f'DELETE FROM posts WHERE id = {id}')
    flash("Post was successfully deleted!", "info")
    return redirect(url_for('index'))

@app.route('/create', methods=('GET', 'POST'))
@login_required
def create():
    if request.method == 'POST':
        location = request.form['location']
        file = request.files.get('image')

        if not location or not file:
            flash('Location and image are required!')
        elif not allowed_file(file.filename):
            flash('Invalid file type!')
        else:
            filename = secure_filename(f"{datetime.datetime.now()}_{file.filename}")
            filepath = os.path.join(app.config['UPLOAD_FOLDER'], filename)
            os.makedirs(app.config['UPLOAD_FOLDER'], exist_ok=True)
            file.save(filepath)

            post_sql(
                'INSERT INTO posts (user_id, location, image_path) VALUES (%s, %s, %s)', (session["user_id"], location, f"images/{filename}")
            )
            return redirect(url_for('index'))

    return render_template('create.html')