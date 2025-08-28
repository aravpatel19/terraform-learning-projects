# VPC for EKS cluster
resource "aws_vpc" "eks_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "eks-vpc"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "eks_igw" {
  vpc_id = aws_vpc.eks_vpc.id

  tags = {
    Name = "eks-igw"
  }
}

# Public Subnets (for Load Balancers)
resource "aws_subnet" "public_subnets" {
  count = 2

  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = "10.0.${count.index + 1}.0/24"
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "eks-public-subnet-${count.index + 1}"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb" = "1"
  }
}

# Private Subnets (for Worker Nodes)
resource "aws_subnet" "private_subnets" {
  count = 2

  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = "10.0.${count.index + 10}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "eks-private-subnet-${count.index + 1}"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

# Route Table for Public Subnets
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.eks_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks_igw.id
  }

  tags = {
    Name = "eks-public-rt"
  }
}

# Route Table Association for Public Subnets
resource "aws_route_table_association" "public_rta" {
  count = 2

  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

# NAT Gateway for Private Subnets
resource "aws_eip" "nat_eip" {
  count = 2

  domain = "vpc"
  depends_on = [aws_internet_gateway.eks_igw]

  tags = {
    Name = "eks-nat-eip-${count.index + 1}"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  count = 2

  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = aws_subnet.public_subnets[count.index].id

  tags = {
    Name = "eks-nat-gw-${count.index + 1}"
  }
}

# Route Table for Private Subnets
resource "aws_route_table" "private_rt" {
  count = 2

  vpc_id = aws_vpc.eks_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw[count.index].id
  }

  tags = {
    Name = "eks-private-rt-${count.index + 1}"
  }
}

# Route Table Association for Private Subnets
resource "aws_route_table_association" "private_rta" {
  count = 2

  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_rt[count.index].id
}

# Data source for availability zones
data "aws_availability_zones" "available" {
  state = "available"
}
