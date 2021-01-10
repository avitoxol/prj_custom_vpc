resource "aws_security_group" "websg" {
  name = "websg"
  description = "ports for httpd"
  vpc_id = aws_vpc.mytestvpc.id

    dynamic "ingress" {
      for_each = var.webports
      iterator = port
      content {
        from_port = port.value
        to_port = port.value
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    }

    egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
}


resource "aws_security_group" "db-port-sg" {
  vpc_id = aws_vpc.mytestvpc.id
  name = "db-port-sg"
  description = "allow db port for mysql"

  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    security_groups = [aws_security_group.websg.id]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/24"]
  }

  tags = {
    Name = "allow mysql"
  }
}
