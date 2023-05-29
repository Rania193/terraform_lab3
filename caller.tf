module "lab3_vpc" {
  source   = "./vpc"
  vpc_cidr = "10.0.0.0/16"
  vpc_name = "lab3 vpc"
  gw_name  = "lab3 internet gateway"
}

module "lab3_subnet" {
  source         = "./subnet"
  created_vpc_id = module.lab3_vpc.vpc_id
  subnet_cidr    = ["10.0.0.0/24", "10.0.2.0/24", "10.0.1.0/24", "10.0.3.0/24"]
  az             = ["eu-west-1a", "eu-west-1b", "eu-west-1a", "eu-west-1b"]
  subnet_name    = ["pub_sub1_az1", "pub_sub2_az2", "private_sub1_az1", "private_sub2_az2"]
}


module "public_security_group" {
  source         = "./sg"
  created_vpc_id = module.lab3_vpc.vpc_id

  ingress = {
    ssh = {
      port        = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    http = {
      port        = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress = {
    port        = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  sg_name = "public_security_group"
}


module "private_security_group" {
  source         = "./sg"
  created_vpc_id = module.lab3_vpc.vpc_id

  ingress = {
    ssh = {
      port        = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress = {
    port        = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  sg_name = "private_security_group"
}

module "nat_gateway1" {
  source           = "./nat_gateway"
  eip              = true
  public_subnet_id = module.lab3_subnet.pub_id_1
  nat_name         = "nat_gateway"
}

module "public_routing_table" {
  source         = "./route_tables"
  created_vpc_id = module.lab3_vpc.vpc_id
  the_cidr    = "0.0.0.0/0"
  the_gatway  = module.lab3_vpc.internet_gateway_id
  table_name     = "public_rt"
  the_subnets  = [module.lab3_subnet.pub_id_1, module.lab3_subnet.pub_id_2]
   } 


module "private_routing_table" {
  source         = "./route_tables"
  created_vpc_id = module.lab3_vpc.vpc_id
  the_cidr    = "0.0.0.0/0"
  the_gatway  = module.nat_gateway1.nat_id
  table_name     = "private_rt"
  the_subnets  = [module.lab3_subnet.priv_id_1, module.lab3_subnet.priv_id_2]
   } 

module "load_balancer" {
  source = "./load_balancer"
  lb_name = ["public-lb" , "private-lb"]
  internal_or = [false , true]
  lb_type = "application"
  lb_sg = [module.public_security_group.sg_id , module.public_security_group.sg_id ]
  public_subnets = [module.lab3_subnet.pub_id_1 , module.lab3_subnet.pub_id_2] 
  private_subnets = [module.lab3_subnet.priv_id_1, module.lab3_subnet.priv_id_2]
  lb_env = ["dev_pub_lb" , "dev_private_lb"]
  tg_name = ["public-tg" , "privat-tg"]
  tg_port = 80
  tg_protocol = "HTTP"
  created_vpc_id = module.lab3_vpc.vpc_id
  default_action_type = "forward" 
}

module "ec2_creation" {
  source = "./ec2"
  key_name = "ec2_key"
  instance_type = "t2.micro"
  pub_sub = [module.lab3_subnet.pub_id_1 , module.lab3_subnet.pub_id_2]
  priv_sub = [ module.lab3_subnet.priv_id_1, module.lab3_subnet.priv_id_2]
  pub_sg = [module.public_security_group.sg_id]
  priv_sg = [module.private_security_group.sg_id]
  pub_associate_ip = true
  priv_associate_ip = false
  pub_instance_name = ["pub-1" , "pub-2"]
  priv_instance_name = ["priv-1" , "priv-2"]
  lb_dns = module.load_balancer.priv_lb_dns
  instance_us = "./userdata.tpl"
}

module "public_tg_attachment" {
  source = "./tg_attachment"
  tg_port = 80
  instances = [module.ec2_creation.public_ec2_1 , module.ec2_creation.public_ec2_2]
  lb_tg_arn = module.load_balancer.lb_target_group_arn_pub
}

module "priavte_tg_attachment" {
  source = "./tg_attachment"
  tg_port = 80
  instances = [module.ec2_creation.priv_ec2_1 , module.ec2_creation.priv_ec2_2]
  lb_tg_arn = module.load_balancer.lb_target_group_arn_priv
}