
/*resource "aws_instance" "web" {
  ami                    = "ami-0705384c0b33c194c"      #change ami id for different region
  instance_type          = "t3.micro"
  key_name               = "terraform"              #change key name as per your setup
  vpc_security_group_ids = [aws_security_group.Jenkins-VM-SG.id]


  tags = {
    Name = "Jenkins-SonarQube"
  }

}

resource "aws_security_group" "Jenkins-VM-SG" {
  name        = "Jenkins-VM-SG"
  description = "Allow TLS inbound traffic"

  ingress  {
    description      = "Allow SSH"
     from_port        = 8080
     to_port          = 8080
     protocol         = "tcp"
     cidr_blocks      = ["0.0.0.0/0"]
}

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Jenkins-VM-SG"
  }
}*/







resource "aws_vpc" "lab_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "lab_vpc"
  }
}

resource "aws_subnet" "lab_public_subnet" {
  vpc_id     = aws_vpc.lab_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "lab_public_subnet"
  }
}

resource "aws_subnet" "lab_private_subnet" {
  vpc_id     = aws_vpc.lab_vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "lab_private_subnet"
  }
}

resource "aws_security_group" "lab_sg" {
   name        = "lab_sg"
   description = "Allow SSH traffic"
   vpc_id      = aws_vpc.lab_vpc.id

  ingress {
     description      = "Allow SSH"
     from_port        = 22
     to_port          = 22
     protocol         = "tcp"
     cidr_blocks      = [aws_vpc.lab_vpc.cidr_block, "0.0.0.0/0"]
   }

   egress {
     from_port        = 0
     to_port          = 0
     protocol         = "-1"
     cidr_blocks      = ["0.0.0.0/0"]
   }

   tags = {
     Name = "allow_ssh"
   }
 }


 resource "aws_instance" "Lab_Web_Server" {
   ami = "ami-0705384c0b33c194c"
   instance_type          = "t3.micro"
  key_name               = "terraform"
   subnet_id = aws_subnet.lab_public_subnet.id
   vpc_security_group_ids = [aws_security_group.lab_sg.id]
  
   tags = {
     Name = "Lab_Web_Server"
   }
 }
