provider "aws" {
  region = "${var.aws_region}"
}

resource "template_file" "docker-registry-task" {
  template = "${file("ecs-tasks/docker-registry.json")}"

  vars {
    s3_bucket  = "${aws_s3_bucket.docker-registry.id}"
    aws_key    = "${aws_iam_access_key.docker-registry.id}"
    aws_secret = "${aws_iam_access_key.docker-registry.secret}"
    aws_region = "${var.aws_region}"
  }
}

resource "aws_ecs_task_definition" "docker-registry" {
  family                = "docker-registry"
  container_definitions = "${template_file.docker-registry-task.rendered}"
}

resource "aws_ecs_service" "docker-registry" {
  name            = "docker-registry-service"
  cluster         = "engineering"
  task_definition = "${aws_ecs_task_definition.docker-registry.arn}"
  desired_count   = 1
  iam_role        = "${lookup(var.ecs_role, var.aws_region)}"

  load_balancer {
    elb_name       = "${aws_elb.docker-reg.name}"
    container_name = "registry"
    container_port = 5000
  }
}
