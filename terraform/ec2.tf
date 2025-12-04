# EC2 Instance Configuration

# Automatically fetch latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# EC2 instance with public IP and SSH access
resource "aws_instance" "ec2" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  key_name               = var.key_pair_name
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.ec2.id]

  # User data script runs on instance launch
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y git wget curl htop mysql

              # Create welcome file with instance metadata
              echo "Welcome to Terraform EC2 Instance" > /home/ec2-user/welcome.txt
              echo "Instance ID: $(curl -s http://169.254.169.254/latest/meta-data/instance-id)" >> /home/ec2-user/welcome.txt
              echo "Availability Zone: $(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)" >> /home/ec2-user/welcome.txt
              echo "Public IP: $(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)" >> /home/ec2-user/welcome.txt
              chown ec2-user:ec2-user /home/ec2-user/welcome.txt
              EOF

  tags = {
    Name = "${var.project_prefix}-ec2-instance"
  }
}
