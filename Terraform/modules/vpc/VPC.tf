
# Create VPC
resource "aws_vpc" "my_vpc" {
  cidr_block          = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support  = true
}

# Create public subnet in AZ_1
resource "aws_subnet" "pubsub1" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.pubsub1_cidr
  availability_zone = var.availability_zone1

  tags = {
    Name = "public-subnet-1"
  }
}

# Create private subnet in AZ_1
resource "aws_subnet" "prisub1" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.prisub1_cidr
  availability_zone = var.availability_zone1

  tags = {
    Name = "private-subnet-1"
  }
}

# Create public subnet in AZ_2
resource "aws_subnet" "pubsub2" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.pubsub2_cidr
  availability_zone = var.availability_zone2

  tags = {
    Name = "public-subnet-2"
  }
}

# Create private subnet in AZ_2
resource "aws_subnet" "prisub2" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.prisub2_cidr
  availability_zone = var.availability_zone2

  tags = {
    Name = "private-subnet-2"
  }
}

# Create Internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "my-IGW"
  }
}



# Create route table for public subnets
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

# Associate public subnets with public route table
resource "aws_route_table_association" "public_az1" {
  subnet_id      = aws_subnet.pubsub1.id
  route_table_id = aws_route_table.public_route_table.id
}

# Associate public subnets with public route table
resource "aws_route_table_association" "public_az2" {
  subnet_id      = aws_subnet.pubsub2.id
  route_table_id = aws_route_table.public_route_table.id
}

# Create route table for private subnets
# and route for nat gateway after nat created to public subnet AZ1
resource "aws_route_table" "private_route_tableAZ1" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_pubsub1.id
  }
  depends_on = [ aws_nat_gateway.nat_gateway_pubsub1 ]

  tags = {
    Name = "private-route-tableAZ1"
  }
}

# Create route table for private subnets
# and route for nat gateway after nat created to public subnet AZ2
resource "aws_route_table" "private_route_tableAZ2" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_pubsub2.id
  }
  depends_on = [ aws_nat_gateway.nat_gateway_pubsub2 ]

  tags = {
    Name = "private-route-tableAZ2"
  }
}

# Associate private subnets with private route table
resource "aws_route_table_association" "private_az1" {
  subnet_id      = aws_subnet.prisub1.id
  route_table_id = aws_route_table.private_route_tableAZ1.id
}

# Associate private subnets with private route table
resource "aws_route_table_association" "private_az2" {
  subnet_id      = aws_subnet.prisub2.id
  route_table_id = aws_route_table.private_route_tableAZ2.id
}


########### for NAT Gateway  ########################
# Allocate Elastic IPs for NAT Gateways
resource "aws_eip" "nat_eip_pubsub1" {}

resource "aws_eip" "nat_eip_pubsub2" {}

# Create NAT Gateways
resource "aws_nat_gateway" "nat_gateway_pubsub1" {
  allocation_id = aws_eip.nat_eip_pubsub1.id
  subnet_id     = aws_subnet.pubsub1.id
}

resource "aws_nat_gateway" "nat_gateway_pubsub2" {
  allocation_id = aws_eip.nat_eip_pubsub2.id
  subnet_id     = aws_subnet.pubsub2.id
}

