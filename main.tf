resource "aws_vpc" "vpc_test" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc_test.id

  tags = {
    Name = "main"
  }
}

#output "aws_internet_gateway_ip" {
#  value=aws_internet_gateway.gw.id
#}
resource "aws_route_table" "route_table1" {
  vpc_id = aws_vpc.vpc_test.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_subnet" "subnet1" {
  vpc_id            = aws_vpc.vpc_test.id
  cidr_block        = var.vpc_test_cidr
  availability_zone = "us-east-1a"
  tags = {
    Name = "main"
  }
}
resource "aws_route_table_association" "route-subnet1" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.route_table1.id
}

resource "aws_internet_gateway_attachment" "igw_vpc_test" {
  internet_gateway_id = aws_internet_gateway.gw.id
  vpc_id              = aws_vpc.vpc_test.id
}

resource "aws_subnet" "private-1a" {
  vpc_id            = aws_vpc.vpc_test.id
  cidr_block        = var.private-1a_cidr
  availability_zone = "us-east-1a"
  tags = {
    Name = "private"
  }
}

resource "aws_subnet" "private-1b" {
  vpc_id            = aws_vpc.vpc_test.id
  cidr_block        = var.private-1b_cidr
  availability_zone = "us-east-1b"
  tags = {
    Name = "private"
  }
}
resource "aws_security_group" "private" {
  name        = "allow_tls,ssh and web"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.vpc_test.id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.vpc_test.cidr_block]
  }

  ingress {
    description = "ssh from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.vpc_test.cidr_block]
  }

  ingress {
    description = "Web from VPC"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.vpc_test.cidr_block]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_instance" "instance" {
  ami           = data.aws_ami.aws-linux.id
  instance_type = var.env_instance_settings[var.deploy_environment].instance_type
  //instance_type = var.environment_instance_settings["PROD"].instance_type
  subnet_id              = aws_subnet.subnet1.id
  vpc_security_group_ids = [aws_security_group.private.id]
  count                  = var.instance_count

  monitoring = var.env_instance_settings[var.deploy_environment].monitoring

  tags = { Environment = var.environment_list[0] }

}

data "aws_ami" "aws-linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-hvm*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
