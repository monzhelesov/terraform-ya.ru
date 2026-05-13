locals {
  vms_ssh_root_key = "ubuntu:${file("/home/roman/.ssh/id_ed25519.pub")}"
}
