# simple file resource
resource "local_file" "tf_example1" {
    filename = "${path.module}/example-${count.index}.txt" 
    content = "Arav is a good student"
    count = 3
}
