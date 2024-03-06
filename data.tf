### using data_source fetching AZ available

data "aws_availability_zones" "available" {
  state = "available"
}

### fetching default VPC using data source

data "aws_vpc" "default"  {
   default = true
}

### fetching default route table for the default vpc using data source

data "aws_route_table" "default" {
    vpc_id = data.aws_vpc.default.id
    filter {
        name = "association.main"
        values = ["true"]
    }
}