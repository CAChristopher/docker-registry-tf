resource "aws_iam_server_certificate" "docker-registry" {
  name_prefix       = "oct-cert"
  certificate_body  = "${file("certs/cert.crt")}"
  private_key       = "${file("certs/key.pem")}"
  certificate_chain = "${file("certs/DigiCertCA.crt")}"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_elb" "docker-reg" {
  name                      = "docker-reg-elb"
  subnets                   = ["${split(",", lookup(var.subnet_ids, var.aws_region))}"]
  security_groups           = ["${split(",", lookup(var.security_group_ids, var.aws_region))}"]
  internal                  = true
  cross_zone_load_balancing = true

  listener {
    instance_port     = 5000
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
  listener {
    instance_port     = 5000
    instance_protocol = "http"
    lb_port           = 5000
    lb_protocol       = "http"
  }
  listener {
    instance_port      = 5000
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = "${aws_iam_server_certificate.docker-registry.arn}"
  }

  tags {
    Name = "docker-reg-elb"
  }
}

resource "aws_route53_record" "docker-registry" {
  zone_id = "${lookup(var.dns_zone, var.aws_region)}"
  name    = "${lookup(var.dns_name, var.aws_region)}"
  type    = "A"

  alias {
    name                   = "${aws_elb.docker-reg.dns_name}"
    zone_id                = "${aws_elb.docker-reg.zone_id}"
    evaluate_target_health = true
  }
}
