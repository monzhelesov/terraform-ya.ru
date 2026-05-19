output "nat_external_ip" {
  value = yandex_compute_instance.nat.network_interface.0.nat_ip_address
}

output "nat_internal_ip" {
  value = yandex_compute_instance.nat.network_interface.0.ip_address
}

output "public_vm_external_ip" {
  value = yandex_compute_instance.public.network_interface.0.nat_ip_address
}

output "public_vm_internal_ip" {
  value = yandex_compute_instance.public.network_interface.0.ip_address
}

output "private_vm_internal_ip" {
  value = yandex_compute_instance.private.network_interface.0.ip_address
}

output "bucket_image_url" {
  value = "https://storage.yandexcloud.net/${yandex_storage_bucket.bucket.bucket}/image.jpg"
}

output "nlb_external_ip" {
  value = yandex_lb_network_load_balancer.nlb.listener.*.external_address_spec[0].*.address
}
