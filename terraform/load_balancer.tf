resource "aws_security_group" "allow_80" {
  name = "allow_80"
  description = "Allows HTTP traffic on 80"

  vpc_id = aws_vpc.keyless_workflow_demo_vpc.id

  ingress {
        description = "HTTP from VPC"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"] # Allow inbound traffic on 80 from any ip
        ipv6_cidr_blocks = ["::/0"]
    }


  egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }
}

resource "aws_lb" "front_end" {
  name = "front-end"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.allow_80.id]
  subnets = [ aws_subnet.public_subnet_a.id, aws_subnet.public_subnet_b.id ]
}

resource "aws_lb_target_group" "front_end_target_group" {
  name = "keyless-workflow-tg"
  port = 3000
  protocol = "HTTP"
  target_type = "ip"
  vpc_id = aws_vpc.keyless_workflow_demo_vpc.id
  health_check {
    path = "/about"
  }
}

resource "aws_lb_listener" "front_end_listener" {
  load_balancer_arn = aws_lb.front_end.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.front_end_target_group.arn
  }
}
