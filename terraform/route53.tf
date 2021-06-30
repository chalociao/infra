resource "aws_route53_zone" "main" {
  name = "pradeep.tr-talent.de"

  tags = {
    Environment = "pradeep_test"
  }

  vpc {
    vpc_id = aws_vpc.fra_vpc.id
  }
}

resource "aws_route53_record" "pradeep" {
  allow_overwrite = true
  name    = "pradeep.tr-talent.de"
  type    = "A"
  ttl     = "300"
  zone_id = aws_route53_zone.main.zone_id
  records = coalesce(aws_route53_zone.main.name_servers)
}
