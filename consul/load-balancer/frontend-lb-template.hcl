# /etc/consul-template.d/frontend.hcl

template {
  source      = "/etc/nginx/conf.d/frontend-lb-conf.ctmpl"
  destination = "/etc/nginx/conf.d/lb.conf"
  command     = "nginx -s reload"
}
