resource "aws_instance" "Precious_instance" {
  count = 2
  ami =  "ami-0022f774911c1d690"
  instance_type = var.instance_type
  subnet_id = aws_subnet.Precious_subnet[count.index].id 
  vpc_security_group_ids = [aws_security_group.Precious_SG.id]  
  tags = {
    "Name" = "Precious-instance-${count.index}"
  }
}