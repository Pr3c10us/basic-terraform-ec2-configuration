resource "aws_vpc" "Precious_vpc" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    "Name" = "Precious-vpc"
  }
}

resource "aws_subnet" "Precious_subnet" {
  vpc_id = aws_vpc.Precious_vpc.id
  count = 2
  cidr_block = var.vpc_subnet_cidr-block[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    "Name" = "Precious-${count.index}"
  }
}

resource "aws_internet_gateway" "Precious_Ig" {
  vpc_id = aws_vpc.Precious_vpc.id

  tags = {
    "Name" = "Precious-Ig"
  }
}

resource "aws_route_table" "Precious_RT" {
  vpc_id = aws_vpc.Precious_vpc.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Precious_Ig.id
  }

  tags = {
    "Name" = "Precious-Rt"
  }
}

resource "aws_route_table_association" "Precious_RTA" {
  for_each = {
    "subnet-1" = aws_subnet.Precious_subnet[0].id
    "subnet-2" = aws_subnet.Precious_subnet[1].id    
  }

  subnet_id = each.value
  route_table_id = aws_route_table.Precious_RT.id

}

resource "aws_security_group" "Precious_SG" {
  name = "Precious-SG"
  vpc_id = aws_vpc.Precious_vpc.id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Precious-SG"
  }
}

resource "aws_security_group_rule" "Precious_igress" {
  for_each = {
    ssh = {
      description = "SSH inboud rule"
      from_port = 22
      to_port = 22
    }
    HTTP = {
      description = "SSH inboud rule"
      from_port = 80
      to_port = 80
    }
    HTTPS = {
      description = "SSH inboud rule"
      from_port = 443
      to_port = 443
    }
  }
    type = "ingress"
    cidr_blocks = [ "0.0.0.0/0" ]
    description = each.value.description
    from_port = each.value.from_port
    ipv6_cidr_blocks = [ "::/0" ]
    protocol = "tcp"
    to_port = each.value.to_port
    security_group_id = aws_security_group.Precious_SG.id
}