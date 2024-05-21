resource "aws_instance" "web" {
  ami                    = "ami-01bef798938b7644d"
  instance_type          = "t2.medium"
  key_name               = "Jenkins"
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
   user_data              = templatefile("./install.sh", {})


  tags = {
    Name = "jenkins-sg-gitlab"
  }

  root_block_device {
    volume_size = 30
  }
}

resource "aws_security_group" "jenkins-sg-gitlab" {
  name        = "jenkins-sg-gitlab"
  description = "Allow TLS inbound traffic"

  ingress = [
    for port in [22, 443, 80, 8080] : {
      description      = "inbound rules"
      from_port        = port
      to_port          = port
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "jenkins-sg-gitlab"
  }



}
