data "aws_availability_zones" "available" {}


module "Dev_VPC" {
  source        = "./modules/VPC"
  cidr_block    = var.dev_vpn_cidr_block
  dns_hostnames = var.dev_vpn_dns_hostnames
  dns_support   = var.dev_vpn_dns_support
  tags = {
    Name        = "Ez-dev-VPN",
    Environment = "Development"
  }
}

module "internet_gateway" {
  source = "./modules/internetgw"
  vpc_id = module.Dev_VPC.id
  tags = {
    Name        = "Ez-dev-igw",
    Environment = "Development"
  }
}

module "public_subnet_2a" {
  source              = "./modules/subnet"
  vpc_id              = module.Dev_VPC.id
  cidr_block          = var.public_subnet_zone2a_cidr_block
  availability_zone   = data.aws_availability_zones.available.names[0]
  public_ip_on_launch = true
  tags = {
    Name                                    = "Ez-dev-public-${data.aws_availability_zones.available.names[0]}",
    Environment                             = "Development",
    "kubernetes.io/role/elb"                = "1",
    "kubernetes.io/cluster/${var.eks_name}" = "shared"
  }
}

module "public_subnet_2b" {
  source              = "./modules/subnet"
  vpc_id              = module.Dev_VPC.id
  cidr_block          = var.public_subnet_zone2b_cidr_block
  availability_zone   = data.aws_availability_zones.available.names[1]
  public_ip_on_launch = true
  tags = {
    Name                                    = "Ez-dev-public-${data.aws_availability_zones.available.names[1]}",
    Environment                             = "Development",
    "kubernetes.io/role/elb"                = "1",
    "kubernetes.io/cluster/${var.eks_name}" = "shared"
  }
}

module "private_subnet_2a" {
  source              = "./modules/subnet"
  vpc_id              = module.Dev_VPC.id
  cidr_block          = var.private_subnet_zone2a_cidr_block
  availability_zone   = data.aws_availability_zones.available.names[0]
  public_ip_on_launch = false
  tags = {
    Name                                    = "Ez-dev-private-${data.aws_availability_zones.available.names[0]}",
    Environment                             = "Development",
    "kubernetes.io/role/internal-elb"       = "1",
    "kubernetes.io/cluster/${var.eks_name}" = "owned"
  }
}

module "private_subnet_2b" {
  source              = "./modules/subnet"
  vpc_id              = module.Dev_VPC.id
  cidr_block          = var.private_subnet_zone2b_cidr_block
  availability_zone   = data.aws_availability_zones.available.names[1]
  public_ip_on_launch = false
  tags = {
    Name                                    = "Ez-dev-private-${data.aws_availability_zones.available.names[1]}",
    Environment                             = "Development",
    "kubernetes.io/role/internal-elb"       = "1",
    "kubernetes.io/cluster/${var.eks_name}" = "owned"
  }
}

module "isolated_subnet_2a" {
  source              = "./modules/subnet"
  vpc_id              = module.Dev_VPC.id
  cidr_block          = var.isolated_subnet_zone2a_cidr_block
  availability_zone   = data.aws_availability_zones.available.names[0]
  public_ip_on_launch = false
  tags = {
    Name        = "Ez-dev-isolated-${data.aws_availability_zones.available.names[0]}",
    Environment = "Development"
  }
}

module "isolated_subnet_2b" {
  source              = "./modules/subnet"
  vpc_id              = module.Dev_VPC.id
  cidr_block          = var.isolated_subnet_zone2b_cidr_block
  availability_zone   = data.aws_availability_zones.available.names[1]
  public_ip_on_launch = false
  tags = {
    Name        = "Ez-dev-isolated-${data.aws_availability_zones.available.names[1]}",
    Environment = "Development"
  }
}

module "elastic_ip_2a" {
  source = "./modules/elasticip"
  domain = "vpc"
  tags = {
    Name        = "Ez-dev-nat-eip-a2",
    Environment = "Development"
  }
}

module "elastic_ip_2b" {
  source = "./modules/elasticip"
  domain = "vpc"
  tags = {
    Name        = "Ez-dev-nat-eip-b2",
    Environment = "Development"
  }
}

module "nat_gateway" {
  source = "./modules/natgateway"
  nat_gateway = {
    availability_mode = "regional"
    connectivity_type = "public"
    vpc_id            = module.Dev_VPC.id
    availability_zone_address = [
      {
        allocation_ids    = [module.elastic_ip_2a.id],
        availability_zone = data.aws_availability_zones.available.names[0]
      },
      {
        allocation_ids    = [module.elastic_ip_2b.id],
        availability_zone = data.aws_availability_zones.available.names[1]
      }
    ]
    tags = {
      Name        = "Ez-dev-nat-gateway",
      Environment = "Development"
    }
  }
  depends_on = [module.internet_gateway, module.elastic_ip_2a, module.elastic_ip_2b]
}

module "route_table_public" {
  source = "./modules/routetables"
  vpc_id = module.Dev_VPC.id
  routes = [
    {
      cidr_block = "0.0.0.0/0"
      gateway_id = module.internet_gateway.id
    }
  ]
  tags = {
    Name        = "Ez-dev-public-route-table",
    Environment = "Development"
  }
}

module "route_table_private" {
  source = "./modules/routetables"
  vpc_id = module.Dev_VPC.id
  routes = [
    {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = module.nat_gateway.id
    }
  ]
  tags = {
    Name        = "Ez-dev-private-route-table",
    Environment = "Development"
  }
  depends_on = [module.nat_gateway]
}

module "route_table_association_public_2a" {
  source         = "./modules/routetableassociation"
  subnet_id      = module.public_subnet_2a.id
  route_table_id = module.route_table_public.id
}

module "route_table_association_public_2b" {
  source         = "./modules/routetableassociation"
  subnet_id      = module.public_subnet_2b.id
  route_table_id = module.route_table_public.id
}

module "route_table_association_private_2a" {
  source         = "./modules/routetableassociation"
  subnet_id      = module.private_subnet_2a.id
  route_table_id = module.route_table_private.id
}

module "route_table_association_private_2b" {
  source         = "./modules/routetableassociation"
  subnet_id      = module.private_subnet_2b.id
  route_table_id = module.route_table_private.id
}

