output "vpc_id" {
    value = module.vpc.vpc_id
}

output "server_public_ip" {
    value = module.server.public_ip
}

output "server_private_ip" {
    value = module.server.private_ip
}

output "private_server_private_ip" {
    value = module.private_server.private_ip
}
