resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "lab-vpc"
  }
}
resource "aws_subnet" "this" {
  count = length(var.subnets)
  vpc_id = aws_vpc.main.id
  cidr_block = var.subnets[count.index].cidr
  availability_zone = var.subnets[count.index].availability_zone
  map_public_ip_on_launch = var.subnets[count.index].map_public_ip
  tags = {
    Name = var.subnets[count.index].name
  }
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-route-table"
  }
}
resource "aws_route_table_association" "public" {
  for_each = {
    for idx, subnet in var.subnets : idx => subnet
    if subnet.map_public_ip
  }

  subnet_id      = aws_subnet.this[tonumber(each.key)].id
  route_table_id = aws_route_table.public.id
}


resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.this[0].id
}


resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
}

resource "aws_route_table_association" "private" {
  for_each = {
    for idx, subnet in var.subnets : idx => subnet
    if subnet.map_public_ip == false
  }

  subnet_id      = aws_subnet.this[tonumber(each.key)].id
  route_table_id = aws_route_table.private.id
}
