/*
1. ec2 instance resource
2. security group resource
    -   22 (ssh)
    -   443 (https)
    -   3000 (nodejs) // ip:3000
*/

resource "aws_instance" "tf_ec2_instance" {
  ami           = "ami-0360c520857e3138f" # ubuntu image
  instance_type = "t2.micro"
  associate_public_ip_address = true
  key_name = "terraform-ec2"

  vpc_security_group_ids = [aws_security_group.tf_ec2_sg.id]

  depends_on = [aws_s3_object.tf_s3_object]

  user_data_replace_on_change = true

  user_data = <<-EOF
                #!/bin/bash

                # Git clone 
                git clone https://github.com/verma-kunal/nodejs-mysql.git /home/ubuntu/nodejs-mysql
                cd /home/ubuntu/nodejs-mysql

                # install nodejs
                sudo apt update -y
                sudo apt install -y nodejs npm

                # edit env vars
                echo "DB_HOST=" | sudo tee .env
                echo "DB_USER=" | sudo tee -a .env
                sudo echo "DB_PASS=" | sudo tee -a .env
                echo "DB_NAME=" | sudo tee -a .env
                echo "TABLE_NAME=" | sudo tee -a .env
                echo "PORT=" | sudo tee -a .env

                # start server
                npm install
                EOF

  tags = {
    Name = "Nodejs-server"
  }
}

# Security group

resource "aws_security_group" "tf_ec2_sg" {
    name = "nodejs-server-sg"
    description = "Allow SSH and HTTP traffic"
    vpc_id = "vpc-075b52eb2d5f7da61"

    ingress {
        description = "TLS from VPC"
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"] # allow from all IPs
    }

    ingress {
        description = "SSH"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"] # allow from all IPs
    }

    ingress {
        description = "TCP"
        from_port = 3000 # for nodejs app
        to_port = 3000
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"] # allow from all IPs
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

# output
output "ec2_public_ip" {
    value = "ssh -i terraform-ec2.pem ubuntu@${aws_instance.tf_ec2_instance.public_ip}"
}