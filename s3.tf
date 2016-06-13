resource "aws_iam_user" "docker-registry" {
    name = "docker.registry"
    path = "/system/"
}

resource "aws_iam_access_key" "docker-registry" {
    user = "${aws_iam_user.docker-registry.name}"
}

resource "template_file" "s3_policy" {
  template = "${file("policies/s3_dockerreg.json")}"

  vars {
    arn   = "${aws_iam_user.docker-registry.arn}"
    s3_id = "${lookup(var.s3_bucket_name, var.aws_region)}"
  }
  depends_on = ["aws_iam_user.docker-registry"]
}

resource "template_file" "iam_policy" {
  template = "${file("policies/iam_dockerreg_user.json")}"

  vars {
    s3_id = "${lookup(var.s3_bucket_name, var.aws_region)}"
  }
}

resource "aws_s3_bucket" "docker-registry" {
    bucket = "${lookup(var.s3_bucket_name, var.aws_region)}"
    acl    = "private"
    policy = "${template_file.s3_policy.rendered}"

    versioning {
      enabled = true
    }

    tags {
        Name = "Docker Registry"
        billingcode = "dino"
    }
    depends_on = ["aws_iam_user.docker-registry","template_file.s3_policy"]
}

resource "aws_iam_user_policy" "docker-registry" {
    name       = "test"
    user       = "${aws_iam_user.docker-registry.name}"
    policy     = "${template_file.iam_policy.rendered}"
    depends_on = ["aws_s3_bucket.docker-registry"]
}
