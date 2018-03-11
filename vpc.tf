
/*
resource "aws_vpc" "default" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_hostnames = true
    tags {
        Name = "terraform-aws-vpc"
    }
}
*/




resource "aws_eip" "mmPubEip" {
  vpc = true
}

resource "aws_nat_gateway" "default" {
  //other arguments
  allocation_id = "${aws_eip.mmPubEip.id}"
  subnet_id = "${aws_subnet.prod-public.id}"
  depends_on = ["aws_internet_gateway.default"]
}




/*
  Public Subnet
*/
resource "aws_subnet" "prod-public" {
    vpc_id = "${var.vpc_id}"

    cidr_block = "${var.public_subnet_cidr}"
    availability_zone = "${var.aws_availability_zone}"

    tags {
        Name = "Public Subnet"
    }
}

resource "aws_route_table" "prod-public" {
    vpc_id = "${var.vpc_id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.default.id}"
    }

    tags {
        Name = "Public Subnet"
    }
}

resource "aws_route_table_association" "prod-public" {
    subnet_id = "${aws_subnet.prod-public.id}"
    route_table_id = "${aws_route_table.prod-public.id}"
}

/*
  Private Subnet
*/
resource "aws_subnet" "prod-private" {
    vpc_id = "${var.vpc_id}"

    cidr_block = "${var.private_subnet_cidr}"
    availability_zone = "${var.aws_availability_zone}"

    tags {
        Name = "Private Subnet"
    }
}

resource "aws_vpn_gateway" "vpn_gateway" {
  vpc_id = "${var.vpc_id}"

  tags = {
    Name = "vpn_gateway"
  }
}

resource "aws_route_table" "prod-private" {
    vpc_id = "${var.vpc_id}"
    propagating_vgws = ["${aws_vpn_gateway.vpn_gateway.id}"]

    tags {
        Name = "prod-private"
    }
}

resource "aws_route_table_association" "prod-private" {
    subnet_id = "${aws_subnet.prod-private.id}"
    route_table_id = "${aws_route_table.prod-private.id}"
}
