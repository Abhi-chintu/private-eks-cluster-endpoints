resource "aws_vpc_endpoint" "interface_endpoint" {
    for_each = {for svc in var.service : svc.name => svc if svc.type == "Interface"}
  
    vpc_id            = var.vpc_id
    service_name      = "com.amazonaws.${var.region}.${each.value.name}"
    subnet_ids        = var.subnet_ids
    vpc_endpoint_type = "Interface"
    private_dns_enabled = each.value.private_dns_enabled
    security_group_ids = var.security_group_ids
    
    tags = {
        Name = "${var.project}-${each.value.name}-endpoint"
    }
}

resource "aws_vpc_endpoint" "gateway_endpoint" {
    for_each = {for svc in var.service : svc.name => svc if svc.type == "Gateway"}
  
    vpc_id       = var.vpc_id
    service_name = "com.amazonaws.${var.region}.${each.value.name}"
    route_table_ids = var.route_table_ids
    vpc_endpoint_type = "Gateway"
    
    tags = {
        Name = "${var.project}-${each.value.name}-endpoint"
    }
}