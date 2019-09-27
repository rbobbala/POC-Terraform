provider "aws" {
   access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
   region     = "us-east-1"
  profile    = "default"

  region  = "us-east-1"
  profile = "default"
}




resource "aws_vpc" "default" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true

  tags = {
    Name = "${var.vpc_name}"
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"

  tags = {
    Name = "${var.IGW_name}"
  }
}

resource "aws_subnet" "subnet1-public" {
  vpc_id            = "${aws_vpc.default.id}"
  cidr_block        = "${var.public_subnet1_cidr}"
  availability_zone = "us-east-1a"

  tags = {
    Name = "${var.public_subnet1_name}"
  }
}

resource "aws_subnet" "subnet2-public" {
  vpc_id            = "${aws_vpc.default.id}"
  cidr_block        = "${var.public_subnet2_cidr}"
  availability_zone = "us-east-1b"

  tags = {
    Name = "${var.public_subnet2_name}"
  }
}

resource "aws_subnet" "subnet3-public" {
  vpc_id            = "${aws_vpc.default.id}"
  cidr_block        = "${var.public_subnet3_cidr}"
  availability_zone = "us-east-1c"

  tags = {
    Name = "${var.public_subnet3_name}"
  }
}

resource "aws_route_table" "terraform-public" {
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.default.id}"
  }

  #route {
  #  cidr_block                = "10.0.0.0/16"
  #  vpc_peering_connection_id = "${aws_vpc_peering_connection.connection.id}"
  #}

  tags = {
    Name = "${var.Main_Routing_Table}"
  }
}

resource "aws_route_table_association" "terraform-public" {
  subnet_id      = "${aws_subnet.subnet1-public.id}"
  route_table_id = "${aws_route_table.terraform-public.id}"
}

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic"
  vpc_id      = "${aws_vpc.default.id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "default" {
  ami                         = "ami-0cfee17793b08a293"
  availability_zone           = "us-east-1a"
  instance_type               = "t2.micro"
  key_name                    = "Srinivas"
  subnet_id                   = "${aws_subnet.subnet1-public.id}"
  vpc_security_group_ids      = ["${aws_security_group.allow_all.id}"]
  associate_public_ip_address = true

  #user_data = "${file("install_apache.sh")}"
  tags = {
    Name  = "Server-TF"
    Env   = "Prod"
    Owner = "kranthi"
  }

  provisioner "local-exec" {
    command = "echo ${aws_instance.default.public_ip} >> hosts"
  }
}

#resource "aws_vpc_peering_connection" "connection" {
 # peer_owner_id = "881670337532"
 # peer_vpc_id   = "vpc-04147e52dae505453"
 # vpc_id        = "${aws_vpc.default.id}"
 # auto_accept   = true

#  tags = {
 #   Name = "VPC Peering "
 # }

  #accepter {
   # allow_remote_vpc_dns_resolution = true
  #}

  #requester {
   # allow_remote_vpc_dns_resolution = true
  #}
#}

#resource "null_resource" "delay" {
  #provisioner "local-exec" {
 #   command = "sleep 100"
 # }
#}

#resource "null_resource" "remote" {
 # provisioner "remote-exec" {
  # connection {
   # type = "ssh"
   #host = "${aws_instance.default.public_ip}"

     # host       =  "18.191.225.60"
    #user        = "ubuntu"
   #private_key = "${file("key.pem")}"
  #agent       = false
 #timeout     = "100s"
#}

 #   inline = [
  #    "sudo mkdir /root/test",
   #   "sudo chmod 777 /root/test/",
    #  "sudo echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC/EH4SQoFTR267a3yaQ/BgXm9UuiXgobG6lI7LMnOdpOPxP2xuVkhy9v/i1IXgK2cnxe637qj3Q0WDKqyGYkz2KFLSfqbQaWCib/NP6lpZbvSpjdCTPOgHdAgihXGXGKTzJVnrF/jtqJo0hrgoUZleS47iefrWOFH8Nszm7IIjAURrWt2jyhbfugnO8DIIF6DJte/YusNxS1o/GzDErmUdr6LA3YbcA7DMCH7n7TjsPvDibrz+/jUEzUoaRBHeFFS4ph/S9Ku60bCql+O9+h2ba0M0ZYm9qrf6nMRLRekN3WRlB8jAm0hnGHCDjdS9OHPr99jV1bM+JOENlHvp3jTl jenkins@ip-10-10-10-40" >> /root/.ssh/authorized_keys "
     #  ]

    # "apt instal python-pip -y",
  #}

  #provisioner "local-exec" {
    #   command = "ansible-playbook -u ubuntu -i '${aws_instance.default.public_ip},'  --private-key "${file("private_key")}" provision.yml"
    #    command = "ansible -i hosts -u ubuntu --private-key /root/.ssh/kranthi1.pem  all -m ping"
   # command = " ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i /home/ubuntu/terraform/hosts  provision.yml -u ubuntu   --private-key /root/.ssh/kranthi1.pem"

    #     command = " ANSIBLE_HOST_KEY_CHECKING=False ansible -i hosts -u ubuntu --private-key /root/.ssh/kranthi1.pem  all -m ping"
  #}
#}
