resource "aws_instance" "master" {
  count                  = var.instance_count_master
  subnet_id              = aws_subnet.pb-001.id
  instance_type          = var.instance_master
  ami                    = var.ami_default
  tags                   = var.default_tags
  volume_tags            = var.default_tags
  vpc_security_group_ids = [aws_security_group.sg-001.id]
  key_name               = var.key-name
  user_data = filebase64("./install_kubeadm_master.sh")
}

resource "aws_instance" "worker" {
  count                  = var.instance_count_worker
  subnet_id              = aws_subnet.pb-001.id
  instance_type          = var.instance_worker
  ami                    = var.ami_default
  tags                   = var.default_tags
  volume_tags            = var.default_tags
  vpc_security_group_ids = [aws_security_group.sg-001.id]
  key_name               = var.key-name
  user_data = filebase64("./install_kubeadm_worker.sh")
}