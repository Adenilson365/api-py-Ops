
# SG EC2
resource "aws_security_group" "sg-001" {
  name        = "sg-001-alert-allow-full"
  description = "Security group test tf"
  vpc_id      = aws_vpc.vpc-tf.id
  tags        = var.default_tags
}

resource "aws_vpc_security_group_egress_rule" "egress_total" {
  security_group_id = aws_security_group.sg-001.id
  description       = "total exit"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "ingress_total" {
  security_group_id = aws_security_group.sg-001.id
  description       = "Allow all inbound traffic"
  cidr_ipv4       = "0.0.0.0/0"
  from_port         = 0
  to_port           = 0
  ip_protocol          = "-1"
}


#80 aberta para ELB
resource "aws_vpc_security_group_ingress_rule" "allow_http_from_web" {
  security_group_id = aws_security_group.sg-001.id
  description       = "Allow http from web"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}



resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.sg-001.id
  description       = "Allow ssh from web"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}





