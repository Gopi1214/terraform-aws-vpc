### AWS VPC modules

This module will help to create following resources.
NOTE: For High Availability(HA), I have used 2 AZ-(us-east-1a, us-east-1b).

* Created VPC
* Created internet gateway(igw) and attached to VPC
* Created 2 public subnets in 1a and 1b
* Created 2 private subnets in 1a and 1b
* Created 2 database subnets in 1a and 1b
* Created database subnet group in rds
* Created Elastic ip
* Created NAT gateway in 1a public subnet
* Created route tables for public, private, database 
* Created routes for public with igw, private and database with NAT gateway
* Subnets and route tables association
* VPC peering if user requests
* Adding the peering route in default VPC, if user don't provide acceptor VPC explicitly.
* Adding the peering routes in public, private and database route tables

### OUTPUTS

