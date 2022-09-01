terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.0.1"
    }
    template = {
      source  = "hashicorp/template"
      version = "~> 2.2.0"
    }
    null = {
      source = "hashicorp/null"
      version = "3.1.1"
    }
  }
}

resource "aws_vpc" "example" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

data "aws_availability_zones" "available" {}

resource "aws_subnet" "example" {
  count                   = 1
  vpc_id                  = aws_vpc.example.id
  cidr_block              = "10.0.${count.index + 1}0.0/24"
  availability_zone       = data.aws_availability_zones.available.names.0
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "example" {
  vpc_id = aws_vpc.example.id
}

resource "aws_eip" "example" {
  vpc = true
}

resource "aws_nat_gateway" "example" {
  allocation_id = aws_eip.example.id
  subnet_id     = aws_subnet.example[0].id
}

resource "aws_default_route_table" "example" {
  default_route_table_id = aws_vpc.example.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.example.id
  }
}

resource "aws_route_table_association" "example" {
  subnet_id      = aws_subnet.example[0].id
  route_table_id = aws_default_route_table.example.id
}

resource "aws_default_network_acl" "example" {
  default_network_acl_id = aws_vpc.example.default_network_acl_id

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
}

resource "aws_default_security_group" "example" {
  vpc_id = aws_vpc.example.id

  ingress {
    protocol    = "tcp"
    from_port   = 0
    to_port     = 65535
    cidr_blocks = [aws_vpc.example.cidr_block]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

locals {
  sg_tcp_ports = []
  sg_udp_ports = []
}

resource "aws_security_group" "example" {
  vpc_id = aws_vpc.example.id
  name   = "nomad-sg"

  dynamic "ingress" {
    for_each = toset(local.sg_tcp_ports)
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = [aws_vpc.example.cidr_block]
    }
  }

  dynamic "ingress" {
    for_each = local.sg_udp_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "udp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [var.myip_cidr]
  security_group_id = aws_security_group.example.id
}

resource "aws_security_group_rule" "nomad" {
  type              = "ingress"
  from_port         = 4646
  to_port           = 4646
  protocol          = "tcp"
  cidr_blocks       = [var.myip_cidr]
  security_group_id = aws_security_group.example.id
}

resource "aws_security_group_rule" "rpc" {
  type              = "ingress"
  from_port         = 4647
  to_port           = 4647
  protocol          = "tcp"
  cidr_blocks       = [var.myip_cidr]
  security_group_id = aws_security_group.example.id
}

resource "aws_security_group_rule" "federation" {
  type              = "ingress"
  from_port         = 4648
  to_port           = 4648
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.example.id
}

data "aws_region" "current" {}

## EC2 구성
data "template_file" "server" {
  template = file("${path.module}/template/install_server.tpl")

  vars = {
    region = data.aws_region.current.name
  }
}

data "template_file" "client" {
  template = file("${path.module}/template/install_client.tpl")

  vars = {
    region    = data.aws_region.current.name
    server_ip = aws_instance.server.private_ip
  }
}

resource "aws_key_pair" "example" {
  key_name   = "nomad-key-pair"
  public_key = file("${path.module}/.ssh/id_rsa.pub")
}

data "aws_ami" "example" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_eip" "server" {
  vpc      = true
  instance = aws_instance.server.id
}

resource "aws_instance" "server" {
  subnet_id     = aws_subnet.example[0].id
  ami           = data.aws_ami.example.image_id
  instance_type = "t3.micro"
  key_name      = aws_key_pair.example.key_name
  vpc_security_group_ids = [
    aws_security_group.example.id
  ]
  user_data = data.template_file.server.rendered

  tags = {
    type = "server"
  }

  lifecycle {
    ignore_changes = [
      user_data,
    ]
  }
}

resource "null_resource" "server" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers = {
    public_ip = aws_eip.server.public_ip
    ec2_id    = aws_instance.server.id
  }

  connection {
    host        = aws_eip.server.public_ip
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("${path.module}/.ssh/id_rsa")
  }

  provisioner "remote-exec" {
    inline = [
      "while [ ! -f /etc/nomad.d/nomad.tpl ]; do echo check; sleep 2; done",
      "sudo sh -c \"sed 's/ADVIP/${aws_eip.server.public_ip}/g' /etc/nomad.d/nomad.tpl > /etc/nomad.d/nomad.hcl\"",
      "sudo chown nomad:nomad /etc/nomad.d/nomad.hcl",
      "sudo systemctl start nomad"
    ]
  }
}


resource "aws_eip" "client" {
  count    = var.client_count
  vpc      = true
  instance = aws_instance.client[count.index].id
}

resource "aws_instance" "client" {
  count         = var.client_count
  subnet_id     = aws_subnet.example[0].id
  ami           = data.aws_ami.example.image_id
  instance_type = "t3.micro"
  key_name      = aws_key_pair.example.key_name
  vpc_security_group_ids = [
    aws_security_group.example.id
  ]
  user_data = data.template_file.client.rendered

  lifecycle {
    ignore_changes = [
      user_data,
    ]
  }
}
