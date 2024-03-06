### vpc_creation

resource "aws_vpc" "main" {
  cidr_block       = var.cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
  tags = merge(
    var.commn_tags, 
    var.vpc_tags,

    {
        Name = local.name
    }
  )
}

#### internet_gateway

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.commn_tags,
    var.igw_tags,
    {
      Name = local.name
    }
  )
}

### public_subnets

resource "aws_subnet" "public" {
  count = length(var.public_subnets_cidr)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnets_cidr[count.index]
  availability_zone = local.az_names[count.index]
  map_public_ip_on_launch = true

   tags = merge(
     var.commn_tags, 
     var.public_subnets_tags,
    {
      Name = "${local.name}-public-${local.az_names[count.index]}"
    }
   )
}

### private_subnets

resource "aws_subnet" "private" {
    count = length(var.private_subnets_cidr)
    vpc_id = aws_vpc.main.id
    cidr_block = var.private_subnets_cidr[count.index]
    availability_zone = local.az_names[count.index]

    tags = merge(
        var.commn_tags,
        var.private_subnets_tags,
        {
            Name = "${local.name}-private-${local.az_names[count.index]}"
        }
    )
}

### database_subnets

resource "aws_subnet" "database" {
   count = length(var.database_subnets_cidr)
   vpc_id = aws_vpc.main.id
   cidr_block = var.database_subnets_cidr[count.index]
   availability_zone = local.az_names[count.index]

   tags = merge(
          var.commn_tags,
          var.database_subnets_tags,
          {
            Name = "${local.name}-database-${local.az_names[count.index]}"
          }
   )

}

### database_subnet_group_rds

resource "aws_db_subnet_group" "default" {
  name       = "${local.name}"
  subnet_ids = aws_subnet.database[*].id

  tags = {
    Name = "${local.name}"
  }
}

### elastic_ip

resource "aws_eip" "elastic_ip" {
  domain    = "vpc"
}

### nat_gateway

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.elastic_ip.id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(
    var.commn_tags,
    var.nat_gateway_tags,
    {
    Name = "${local.name}"
    }
   )

  depends_on = [aws_internet_gateway.igw]
}

### public_route_table

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  
  tags = merge(
    var.commn_tags,
    var.public_route_table_tags,
    {
    Name = "${local.name}-public"
    }
  )
}

### private_route_table

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  
  tags = merge(
    var.commn_tags,
    var.private_route_table_tags,
    {
    Name = "${local.name}-private"
    }
  )
}

### database_route_table

resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id
  
  tags = merge(
    var.commn_tags,
    var.database_route_table_tags,
    {
    Name = "${local.name}-database"
    }
  )
}

### public_route

resource "aws_route" "public_route" {
  route_table_id          = aws_route_table.public.id
  destination_cidr_block  = "0.0.0.0/0"
  gateway_id              = aws_internet_gateway.igw.id
  
}

### private_route

resource "aws_route" "private_route" {
  route_table_id          = aws_route_table.private.id
  destination_cidr_block  = "0.0.0.0/0"
  nat_gateway_id          = aws_nat_gateway.main.id
}

### database_route

resource "aws_route" "database_route" {
  route_table_id          = aws_route_table.database.id
  destination_cidr_block  = "0.0.0.0/0"
  nat_gateway_id          = aws_nat_gateway.main.id
}

### public_subnet_route_table_association

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets_cidr)  # length function
  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.public.id
}

### private_subnet_route_table_association

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets_cidr)
  subnet_id      = element(aws_subnet.private[*].id, count.index)
  route_table_id = aws_route_table.private.id
}

### database_subnet_route_table_association

resource "aws_route_table_association" "databse" {
  count          = length(var.database_subnets_cidr)
  subnet_id      = element(aws_subnet.database[*].id, count.index)
  route_table_id = aws_route_table.database.id
}