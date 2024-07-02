
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


#code form the chat GPT

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
    cidr_blocks      = ["0.0.0.0/0"]  # Changed to the correct CIDR block
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
  ami           = "ami-0705384c0b33c194c"
  instance_type = "t3."
  key_name      = "terraform"  # Ensure the correct key pair name is used
  subnet_id     = aws_subnet.lab_public_subnet.id
  vpc_security_group_ids = [aws_security_group.lab_sg.id]

  tags = {
    Name = "Lab_Web_Server"
  }
}



####################################################################################################
#CODE From the Cheat GPT Promt
/*
# Define AWS provider
provider "aws" {
  region = "us-west-2"  # Change this to your desired region
}

# Create VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Create Internet Gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
}

# Create Route Table
resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }
}

# Associate Route Table with Subnet
resource "aws_route_table_association" "my_route_association" {
  subnet_id      = aws_subnet.my_subnet.id
  route_table_id = aws_route_table.my_route_table.id
}

# Create Subnet
resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"  # Change this to your desired AZ
}

# Create Security Group for EC2 instances
resource "aws_security_group" "my_sg" {
  name        = "my_sg"
  description = "Allow SSH and HTTP traffic"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
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

# Launch EC2 instances
resource "aws_instance" "ec2_instance1" {
  ami                    = "ami-0c55b159cbfafe1f0"  # Amazon Linux 2 AMI ID
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.my_subnet.id
  security_group_ids     = [aws_security_group.my_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "EC2_Instance1"
  }
}

resource "aws_instance" "ec2_instance2" {
  ami                    = "ami-0c55b159cbfafe1f0"  # Amazon Linux 2 AMI ID
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.my_subnet.id
  security_group_ids     = [aws_security_group.my_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "EC2_Instance2"
  }
}

# Create S3 bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-unique-bucket-name"
  acl    = "private"

  tags = {
    Name = "MyBucket"
  }
}
*/
