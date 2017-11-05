resource "aws_security_group" "fortigate_fw_sg" {
    name    = "${var.sg_name}"
    description = "Security group applied to all fortigate firewalls"
    vpc_id = "${var.vpc_id}"

    ingress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    }

    tags            = "${merge(var.tags, map("Name", format("%s", var.sg_name)))}"
}

resource "aws_eip" "external_ip" {
  vpc   = true
  count = "${var.number_of_instances}"

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_network_interface" "fw_private_nic" {
    count               = "${var.number_of_instances}"
    subnet_id           = "${element(var.private_subnet_id, count.index)}"
    description         = "${var.private_nic_description}"
    source_dest_check   = "${var.source_dest_check}"
    security_groups     = ["${aws_security_group.fortigate_fw_sg.id}"]
    tags                = "${merge(var.tags, map("Name", format("%s_%01d_private", var.instance_name_prefix, count.index + 1)))}"

    attachment {
        instance        = "${element(aws_instance.ec2_instance.*.id, count.index)}"
        device_index    = 1
    }
}

/*resource "aws_network_interface" "fw_public_nic" {
    count               = "${var.number_of_instances}"
    subnet_id           = "${element(var.public_subnet_id, count.index)}"
    description         = "${var.public_nic_description}"
    source_dest_check   = "${var.source_dest_check}"
    security_groups     = ["${aws_security_group.fortigate_fw_sg.id}"]
    tags                = "${merge(var.tags, map("Name", format("%s_%01d_public", var.instance_name_prefix, count.index + 1)))}"
}*/

resource "aws_eip_association" "fw_external_ip" {
    count                   = "${var.number_of_instances}"
    allocation_id           = "${element(aws_eip.external_ip.*.id, count.index)}"
    network_interface_id    = "${element(aws_instance.ec2_instance.*.network_interface_id, count.index)}"
}

resource "aws_instance" "ec2_instance" {
    ami                         = "${var.ami_id}"
    count                       = "${var.number_of_instances}"
    subnet_id                   = "${element(var.public_subnet_id, count.index)}"
    instance_type               = "${var.instance_type}"
    key_name                    = "${var.key_name}"
    source_dest_check           = "${var.source_dest_check}"
    vpc_security_group_ids      = ["${aws_security_group.fortigate_fw_sg.id}"]
    volume_tags                 = "${merge(var.tags, map("Name", format("%s_%01d", var.instance_name_prefix, count.index + 1)))}"
    tags                        = "${merge(var.tags, map("Name", format("%s_%01d", var.instance_name_prefix, count.index + 1)))}"
    /*network_interface {
        network_interface_id    = "${element(aws_network_interface.fw_public_nic.*.id, count.index)}"
        device_index            = 0
    }*/
    root_block_device {
        volume_type = "${var.root_volume_type}"
        volume_size = "${var.root_volume_size}"
    }
    ebs_block_device {
        device_name = "${var.ebs_device_name}"
        volume_type = "${var.ebs_volume_type}"
        volume_size = "${var.ebs_volume_size}"
        encrypted   = "${var.ebs_volume_encrypted}"
    }
}

/*resource "aws_network_interface_attachment" "fw_private_nic_attachment" {
    count                   = "${var.number_of_instances}"
    instance_id             = "${element(aws_instance.ec2_instance.*.id, count.index)}"
    network_interface_id    = "${element(aws_network_interface.fw_private_nic.*.id, count.index)}"
    device_index            = 1
}*/
