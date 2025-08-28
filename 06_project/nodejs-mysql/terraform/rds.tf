/*

1. rds tf resource
2. security group resource
    -   3306 (mysql)
        -   security-group -> ec2-sg
        -   cidr_block -> ["local ip"]

3. outputs
*/

# rds resource

resource "aws_db_instance" "tf_rds_instance" {
  allocated_storage    = 10
  db_name              = "arav_demo"
  identifier           = "nodejs-rds-mysql"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = "admin"
  password             = "password"
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  publicly_accessible  = true
  vpc_security_group_ids = [aws_security_group.tf_rds_sg.id]
}

resource "aws_security_group" "tf_rds_sg" {
    name = "allow_mysql"
    vpc_id = "vpc-075b52eb2d5f7da61"
    description = "Allow MySQL traffic"

    ingress {
        description = "Allow MySQL traffic from EC2"
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        cidr_blocks = ["71.187.190.120/32"] # local ip
        security_groups = [aws_security_group.tf_ec2_sg.id] # Allow traffic from EC2 security group
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"] # Allow all outbound traffic
    }
}