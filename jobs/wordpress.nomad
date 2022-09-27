job "wordpress-server" {
  datacenters = ["dc1"]
  type        = "service"

  group "wordpress-server" {
    count = 1

    network {
      port "wordpress" {
        static = 8080
        to = 80
      }
    }

    task "wordpress-server" {
      driver = "docker"

      template {
        destination = "local/wp-config.env"
        env         = true
        change_mode = "restart"
        data = <<EOH
{{- with nomadVar "nomad/jobs/wordpress" -}}        
WORDPRESS_DB_NAME = {{.WORDPRESS_DB_NAME}}
WORDPRESS_DB_USER = {{.WORDPRESS_DB_USER}}
WORDPRESS_DB_PASSWORD = {{.WORDPRESS_DB_PASSWORD}}
{{ end }}
{{- range nomadService "mysql-server" -}}
WORDPRESS_DB_HOST = {{ .Address }}:{{ .Port }}
{{ end }}
EOH
      }

      config {
        image = "wordpress"
        ports = ["wordpress"]
      }

      service {
        name     = "wordpress-server"
        provider = "nomad"
        tags     = [
          "traefik.enable=true",
          "traefik.http.routers.wordpress.rule=Host(`localhost`)"
        ]
        port = "wordpress"
      }
    }
  }
}