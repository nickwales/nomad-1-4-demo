job "mysql-server" {

  datacenters = ["dc1"]
  type        = "service"

  constraint {
    attribute = "${attr.cpu.arch}"
    value = "amd64"
  }

  group "mysql-server" {
    count = 1

    network {
      port "db" {
        static = 3306
        to     = 3306
      }
    }

    restart {
      attempts = 10
      interval = "5m"
      delay    = "25s"
      mode     = "delay"
    }

    task "mysql-server" {
      driver = "docker"

      config {
        image = "mysql"
        ports = ["db"]
      }

      resources {
        cpu    = 100
        memory = 512
      }

      service {
        name     = "mysql-server"
        port     = "db"
        provider = "nomad"        
        tags     = ["mysql", "wordpress", "demo"]

#### This is new!!!! ####         
        check {
          type     = "tcp"
          interval = "20s"
          timeout  = "5s"
        }
      }

      template {
          data = <<EOF
{{- with nomadVar "nomad/jobs/mysql-server" -}}
MYSQL_DATABASE = {{.MYSQL_DATABASE}}
MYSQL_USER = {{.MYSQL_USER}}
MYSQL_PASSWORD = {{.MYSQL_PASSWORD}}
MYSQL_RANDOM_ROOT_PASSWORD = {{.MYSQL_RANDOM_ROOT_PASSWORD}}
{{- end -}}
EOF        
       
          destination = "${NOMAD_TASK_DIR}/mysql.env"          
          env         = true
      }       
    }
  }
}