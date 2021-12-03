resource "aws_security_group" "tomcat-security-group" {
  name        = "tomcat-security-group"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.petclinic.id

  ingress {
    # SSH Port 22 allowed from any IP
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
      # SSH Port 80 allowed from any IP
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


data "template_file" "user_data" {
  template = "${file("tomcat_install.sh")}"

}

resource "aws_instance" "tomcat" {
  ami           = var.ami
  instance_type = var.type
  subnet_id = aws_subnet.pubsubnet[0].id
  key_name = aws_key_pair.petclinic.id 
  security_groups = ["${aws_security_group.tomcat-security-group.id}"]
  user_data = data.template_file.user_data.rendered


  tags = {
    Name = "${var.envname}-tomcat"
  }
}
resource "aws_key_pair" "petclinic" {
  key_name   = "petclinic-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC/k5Lg8jK6d5jCJCKJlp2ocltd7WB9HZb2Vyid2w19xQ06O5A7zXLAdkN+3Nu+hdH1fpVW29fTIVeO/bN4FyipbRCrCiAAmztHkRDSHFuVy39flXPnIJIlHC9zZtwgd5PaHy70fZ88RqEXl0Siksi0TG07NEFcpm0kxnMBNU5qr0xoR2UhmsSmqsDpPZuFnnHxrFe0xM6XG8FQ/eCnUfpRoC5ADqFvm+rpbXcVtM6gylSXwFdeqoyRZnUkfWGEbGAzK2wznOQqBaDPc2S1RsdAyzK9nGECfwTKebsg0i/ZU4S1/R03JCmX9Xxv5n96h/Vuh+It/lZCzaAfHE3JpUYeJUVFynyw+JfykyJD8Xce1XGxK2to0mZh8M5pU7uwhE5DeSmAr4jvY94+8gjEhIep/zmKsuQVaWhkLMlGYghV4iaodUj2tPLlnuxl/N/IltJ+dDkghF+MMi5a5hpF21kjZd7NkmGOjUuY9WO3ZfmxEujKpnPRue5XiG5SbeMEtfM= ANJU YADAV@LAPTOP-IFFFOLT4"
}


























  