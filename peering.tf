data "aws_caller_identity" "current" {}

/**
 * VPC peering connection.
 *
 * Establishes a relationship resource between the "primary" and "secondary" VPC.
 */
resource "aws_vpc_peering_connection" "primary2secondary" {
  peer_owner_id = "${data.aws_caller_identity.current.account_id}"
  peer_vpc_id = "${aws_vpc.default.id}"
  vpc_id = "${var.vpc_id}"
  auto_accept = true
}

/**
 * Route rule.
 *
 * Creates a new route rule on the "primary" VPC main route table. All requests
 * to the "secondary" VPC's IP range will be directed to the VPC peering
 * connection.
 */
resource "aws_route" "primary2secondary" {
  route_table_id = "rtb-54b2e632"
  destination_cidr_block = "${aws_vpc.default.cidr_block}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.primary2secondary.id}"
}

/**
 * Route rule.
 *
 * Creates a new route rule on the "secondary" VPC main route table. All
 * requests to the "secondary" VPC's IP range will be directed to the VPC
 * peering connection.
 */
resource "aws_route" "secondary2primary" {
  route_table_id = "${aws_route_table.prod-public.id}"
  destination_cidr_block = "172.31.16.0/20"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.primary2secondary.id}"
}