resource "yandex_iam_service_account" "sa-bucket" {
  name = "sa-bucket"
}

resource "yandex_resourcemanager_folder_iam_member" "sa-bucket-editor" {
  folder_id = var.folder_id
  role      = "storage.editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa-bucket.id}"
}

resource "yandex_iam_service_account_static_access_key" "sa-bucket-key" {
  service_account_id = yandex_iam_service_account.sa-bucket.id
}

resource "yandex_storage_bucket" "bucket" {
  bucket     = "roman-${formatdate("YYYY-MM-DD", timestamp())}"
  access_key = yandex_iam_service_account_static_access_key.sa-bucket-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-bucket-key.secret_key

  anonymous_access_flags {
    read = true
    list = false
  }
}

resource "yandex_storage_object" "image" {
  bucket     = yandex_storage_bucket.bucket.bucket
  key        = "image.jpg"
  source     = "./image.jpg"
  acl        = "public-read"
  access_key = yandex_iam_service_account_static_access_key.sa-bucket-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-bucket-key.secret_key
}
