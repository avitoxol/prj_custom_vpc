resource "aws_vpc" "mytestvpc" {
    cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"

    tags = {
      Name = "mytestvpc"
    }
}

resource "aws_internet_gateway" "myigw" {
    vpc_id = aws_vpc.mytestvpc.id

    tags = {
      Name = "MyIGW"
    }
}

resource "aws_route_table" "my_pub_rt_table" {
    vpc_id = aws_vpc.mytestvpc.id

    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.myigw.id
    }

    tags = {
      Name = "My_Public_Route"
    }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "primary" {
    vpc_id = aws_vpc.mytestvpc.id
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = true
    availability_zone = data.aws_availability_zones.available.names[0]

    tags = {
      Name = "public_sub_one"
    }
}

resource "aws_subnet" "secondary" {
  vpc_id = aws_vpc.mytestvpc.id
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "public_sub_two"
  }
}

resource "aws_subnet" "priv_one" {
  vpc_id = aws_vpc.mytestvpc.id
  cidr_block = "10.0.3.0/24"

  tags = {
    Name = "private_subnet_one"
  }
}

resource "aws_subnet" "priv_two" {
  vpc_id = aws_vpc.mytestvpc.id
  cidr_block = "10.0.4.0/24"

  tags = {
    Name = "private_subnet_two"
  }
}

resource "aws_db_subnet_group" "db_prv_sub" {
  name = "main"
  subnet_ids = [aws_subnet.priv_one.id, aws_subnet.priv_two.id]

  tags = {
    Name = "My DB subnet group"
  }
}
