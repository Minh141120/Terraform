# khai báo provider, xác thực
provider "aws" {
  // access_key = "***"
  // secret_key = "***"
  region     = "ap-southeast-1" # Singapore region
}

# tạo ec2 instance
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance

resource "aws_instance" "web" {

  ami           = "ami-0d058fe428540cd89"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_a.id

  key_name               = aws_key_pair.dev.key_name
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "web-01"
  }
}

# tạo ssh keypair

resource "aws_key_pair" "dev" {
  key_name   = "dev-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCxvDuV8UBour5so/G9xT2hDlx+5szGrzssjek5KJFA1skD3jbjIPpcthp7DeXREfIWWHKHkt7VP+ExdjXef+vE/Gj5+n7FNEllTJHhdm+9mn/jDFH+Lx6o0a7aAr8rUhBwuqW0h2AuLkDBwQW0IKmJzk2tfZuR1yMjIUSgKKeOkM/TjXLqM9/cyft1ew+HR2hlx/OrTRs2Bu7dGOQ6FlQV8mnINpC6/8zY5rkv/tNTF4RNStTQ1PdMQNCf4Xwz3WpW9c055GW+MUMGbObmYIsBS8I3YMF9Ck3eBr+msVXRWaZorKVqyz8DUZvKxbeIg387HsN6WYFa7ta3+sKnVDBf"
}

# tạo security group allow ssh

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH from specify IPs"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["14.232.243.111/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# in ra public ip của ec2 instance
output "ec2_instance_public_ips" {
  value = aws_instance.web.*.public_ip
}