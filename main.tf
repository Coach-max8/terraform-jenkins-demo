provider "aws" {
  region = var.region
}

resource "aws_instance" "demo" {
  ami           = "ami-091138d0f0d41ff90"
  instance_type = var.instance_type

  tags = {
    Name = "${var.environment}-server"
  }
}
