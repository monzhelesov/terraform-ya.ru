resource "yandex_iam_service_account" "sa-ig" {
  name = "sa-ig"
}

resource "yandex_resourcemanager_folder_iam_member" "sa-ig-editor" {
  folder_id = var.folder_id
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa-ig.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "sa-ig-compute-admin" {
  folder_id = var.folder_id
  role      = "compute.admin"
  member    = "serviceAccount:${yandex_iam_service_account.sa-ig.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "sa-ig-lb-admin" {
  folder_id = var.folder_id
  role      = "load-balancer.admin"
  member    = "serviceAccount:${yandex_iam_service_account.sa-ig.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "sa-ig-vpc-user" {
  folder_id = var.folder_id
  role      = "vpc.user"
  member    = "serviceAccount:${yandex_iam_service_account.sa-ig.id}"
}

resource "yandex_compute_instance_group" "lamp-group" {
  name               = "lamp-group"
  folder_id          = var.folder_id
  service_account_id = yandex_iam_service_account.sa-ig.id

  instance_template {
    platform_id = "standard-v1"

    resources {
      cores         = 2
      memory        = 2
      core_fraction = 20
    }

    boot_disk {
      initialize_params {
        image_id = "fd827b91d99psvq5fjit"
        type     = "network-hdd"
        size     = 10
      }
    }

    scheduling_policy {
      preemptible = true
    }

    network_interface {
      subnet_ids = [yandex_vpc_subnet.public.id]
      nat        = true
    }

    metadata = {
      ssh-keys  = local.vms_ssh_root_key
      user-data = <<-EOF
        #!/bin/bash
        apt-get update
        apt-get install -y apache2
        systemctl start apache2
        systemctl enable apache2
        cat > /var/www/html/index.html <<HTML
        <!DOCTYPE html>
        <html>
        <head><title>LAMP</title></head>
        <body>
          <h1>Hello from LAMP instance!</h1>
          <img src="https://storage.yandexcloud.net/${yandex_storage_bucket.bucket.bucket}/image.jpg" alt="image"/>
        </body>
        </html>
        HTML
      EOF
    }
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    zones = [var.default_zone]
  }

  deploy_policy {
    max_unavailable = 1
    max_creating    = 1
    max_expansion   = 1
    max_deleting    = 1
  }

  health_check {
    http_options {
      port = 80
      path = "/"
    }
    interval            = 10
    timeout             = 5
    unhealthy_threshold = 2
    healthy_threshold   = 2
  }

  load_balancer {
    target_group_name = "lamp-target-group"
  }
}
