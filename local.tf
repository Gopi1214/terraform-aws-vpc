locals {
  name = "${var.project_name}-${var.environment}" # interpolation
  az_names = slice(data.aws_availability_zones.available.names,0,2)  # taking first 2 elements from the list using slice
}