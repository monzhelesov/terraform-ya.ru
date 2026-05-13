data "yandex_compute_image" "nat" {
  family = "nat-instance-ubuntu"
}

data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2004-lts"
}

resource "yandex_compute_instance" "nat" {
  name        = var.nat.vm_name
  platform_id = var.nat.platform_id

  resources {
    cores         = var.nat.cpu
    memory        = var.nat.ram
    core_fraction = var.nat.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.nat.image_id
      type     = "network-hdd"
      size     = var.nat.disk
    }
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.public.id
    nat        = true
    ip_address = "192.168.10.254"
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = local.vms_ssh_root_key
  }
}

resource "yandex_compute_instance" "public" {
  name        = var.vm_public.vm_name
  platform_id = var.vm_public.platform_id

  resources {
    cores         = var.vm_public.cpu
    memory        = var.vm_public.ram
    core_fraction = var.vm_public.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      type     = "network-hdd"
      size     = var.vm_public.disk
    }
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public.id
    nat       = true
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = local.vms_ssh_root_key
  }
}

resource "yandex_compute_instance" "private" {
  name        = var.vm_private.vm_name
  platform_id = var.vm_private.platform_id

  resources {
    cores         = var.vm_private.cpu
    memory        = var.vm_private.ram
    core_fraction = var.vm_private.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      type     = "network-hdd"
      size     = var.vm_private.disk
    }
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private.id
    nat       = false
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = local.vms_ssh_root_key
  }
}
