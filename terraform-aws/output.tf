output "instance_public_ip_master" {
  value = [for i in aws_instance.master : i.public_ip]
}
output "instance_public_ip_worker" {
   value = [for i in aws_instance.worker : i.public_ip]
}