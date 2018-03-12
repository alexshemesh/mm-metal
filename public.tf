/*
  Web Servers
*/



resource "aws_security_group" "pub" {
    name = "vpc_pub"
    description = "Allow incoming HTTP connections."

    
    ingress {
        from_port = 1194
        to_port = 1194
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["${var.vpc_cidr}","172.31.0.0/16"]
    }
    
    
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    vpc_id = "${aws_vpc.default.id}"

    tags {
        Name = "WebServerSG"
    }
}

resource "aws_instance" "openvpn" {
    ami = "${lookup(var.amis, var.aws_region)}"
    availability_zone = "${var.aws_availability_zone}"
    instance_type = "t2.micro"
    key_name = "${var.aws_key_name}"
    vpc_security_group_ids = ["${aws_security_group.pub.id}"]
    subnet_id = "${aws_subnet.prod-public.id}"
    associate_public_ip_address = true
    source_dest_check = false

    tags {
        Name = "Web Server 1"
    }
}

resource "aws_eip" "openvpn" {
    instance = "${aws_instance.openvpn.id}"
    vpc = true
}


resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"
}

resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.default.default_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.default.id}"
}