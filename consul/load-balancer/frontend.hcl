# /etc/consul-template.d/frontend.hcl

template {
  source      = "/etc/nginx/conf.d/frontend.ctmpl"
  destination = "/etc/nginx/conf.d/frontend.conf"
  command     = "nginx -s reload"
}
