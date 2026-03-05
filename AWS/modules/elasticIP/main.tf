resource "aws_eip" "main" {
  instance          = var.instance_id
  domain            = var.domain
  network_interface = var.network_interface_id
  tags              = var.tags
}
