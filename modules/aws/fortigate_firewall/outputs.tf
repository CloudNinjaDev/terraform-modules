output "security_group_id" {
    value = "${aws_security_group.fortigate_fw_sg.id}"
}

output "eip_id" {
    value = ["${aws_eip.external_ip.*.id}"]
}

output "eip_private_ip" {
    value = ["${aws_eip.external_ip.*.private_ip}"]
}

output "eip_public_ip" {
    value = ["${aws_eip.external_ip.*.public_ip}"]
}

output "ec2_instance_id" {
  value = ["${aws_instance.ec2_instance.*.id}"]
}

output "ec2_instance_network_id" {
    value = ["${aws_instance.ec2_instance.*.network_interface_id}"]
}

output "fw_private_nic_id" {
    value = ["${aws_network_interface.fw_private_nic.*.id}"]
}
