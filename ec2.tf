resource "aws_instance" "web_one" {
    ami = data.aws_ami.my_image.id
    count = var.counting
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.websg.id]
    subnet_id = element(local.subs, count.index)

    tags = {
      Name = "web-${var.instname[count.index]}"
    }
}
