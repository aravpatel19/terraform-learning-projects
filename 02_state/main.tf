resource "local_sensitive_file" "example1" {
  content  = "sensitivepassword123"
  filename = "${path.module}/sensitive.txt"
}
