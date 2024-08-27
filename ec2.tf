
data "template_file" "this" {
  template = file("${path.module}/templates/cloud-init.tpl")
}

resource "aws_instance" "this" {
  ami                         = var.image_ami
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.landing.id]
  monitoring                  = var.enable_detailed_monitoring
  subnet_id                   = var.public_subnet_1c
  user_data                   = base64encode(data.template_file.this.rendered)
  key_name                    = "msm-landing"
  associate_public_ip_address = true

  root_block_device {
    volume_size = "50"
    volume_type = "gp2"
  }

  tags = merge(var.common_tags, { Name = "msm-web-server-${var.common_tags["Environment"]}" })
}
