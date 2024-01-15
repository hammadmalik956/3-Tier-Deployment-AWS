

data "aws_route53_zone" "public-zone" {
  name         = var.hosted_zone_name
  private_zone = false
}
resource "aws_route53_record" "subdomain_record" {
  zone_id = data.aws_route53_zone.public-zone.zone_id
  name    = "hammad.${data.aws_route53_zone.public-zone.name}"
  type    = "A"

  alias {
    name = var.alb_dns_name
    zone_id =var.alb_zone_id
    evaluate_target_health = false
  }
}