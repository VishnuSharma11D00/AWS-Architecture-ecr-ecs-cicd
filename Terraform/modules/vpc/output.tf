output "vpc_id" {
  value = aws_vpc.my_vpc.id
}

output "public_subnet_ids" {
  value = [aws_subnet.pubsub1.id, aws_subnet.pubsub2.id]
}

output "private_subnet_ids" {
  value = [aws_subnet.prisub1.id, aws_subnet.prisub2.id]
}
