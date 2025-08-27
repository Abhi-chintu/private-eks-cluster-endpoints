output "interface_endpoint" {
    value = {for k, v in aws_vpc_endpoint.interface_endpoint : k => v.id}
}

output "gateway_endpoint" {
    value = {for k, v in aws_vpc_endpoint.gateway_endpoint : k => v.id}
}