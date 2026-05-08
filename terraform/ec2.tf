resource "aws_instance" "devops_server" {
  ami           = "ami-04dd8a25f4efa9b82"
  instance_type = "t3.micro"
  key_name = "devops-key"
  tags = {
    Name = "DevOps-Server"
  }
}
