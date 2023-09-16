# Create a vpc
resource "aws_vpc" "keyless_workflow_demo_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "keyless_workflow_demo_vpc"
  }
}

# Create a subnet
resource "aws_subnet" "keyless_workflow_demo_subnet" {
  vpc_id                  = aws_vpc.keyless_workflow_demo_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-2a" # Adjust as needed
  map_public_ip_on_launch = true # This will give instances in this subnet a public IP by default
  tags = {
    Name = "keyless_workflow_demo_subnet"
  }
}

resource "aws_security_group" "keyless_workflow_demo_sg" {
  name        = "keyless_workflow_demo_sg"
  description = "Allow traffic on port 3000"
  vpc_id      = aws_vpc.keyless_workflow_demo_vpc.id

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # All protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "keyless_workflow_demo_sg"
  }
}

#region Public subnet
## Create a public subnet with the following
## This is required so that FARGATE can pull from ECR

# Create an Internet Gateway and attach it to the VPC
resource "aws_internet_gateway" "keyless_workflow_demo_igw" {
  vpc_id = aws_vpc.keyless_workflow_demo_vpc.id
}

# Create a route table for the VPC
resource "aws_route_table" "keyless_workflow_demo_route_table" {
  vpc_id = aws_vpc.keyless_workflow_demo_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.keyless_workflow_demo_igw.id
  }

  tags = {
    Name = "keyless_workflow_demo_route_table"
  }
}

# Associate the route table with the subnet
resource "aws_route_table_association" "keyless_workflow_demo_rta" {
  subnet_id      = aws_subnet.keyless_workflow_demo_subnet.id
  route_table_id = aws_route_table.keyless_workflow_demo_route_table.id
}
#endregion
