resource "aws_key_pair" "app_kp" {
  key_name   = "${var.repository}-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC6pkLMdc205B8kBKxN+UBjoH/ezXqOaWkK1OnkRXvROulrK9X3ENEwW6ApYQ41mRPxyLahOHmfVDe3l7thRUdHBXA1SGjPBVjwmAEB5ABoO6EQNB4KL3N0LKNlAjCAbcw6RgXWjTliHyKWWJZTmjWVE8eO+2VuJZCKDgeKi31eowQEVDWgsCpGsFluC9Gl1IZMtpP44r7UM7X5BiFWDMx7BzUBeHYKaible6jXmeNr8+uGfWdHqFwBC+ylK5brL9CYb97vS4cdAKdyGB+n037zZIjuP/Jc0E0eevRpiouoTGADSjglA/jeW8UOLcNcRwc4UtJQLueSrb19MSOde74Sf8kLIyPs6ZKgvV9Yz2lZL74IiETDdyzOrgAaEjG5OuSFDbdELlgsXJzChmO0zVti5B76UUGlwLZvyF9y/eiowDYNubo1geK3bA9Y5Pqn30Ds5YwmBgWjZRuQTzYPfWuUf+bkSBv71TKMdWZUjqIj8leS5PVNObxRS5RyL8i5g65ND7iKqMZ4bgkH8j7e/yW09n89VBOOIgPz/mo7qA/UiBeXdihP4wgqceZkKxQqkMmXH88L4EKhf2QZrs3bXkYdQpTlO01RWHF3oDD42DuI4e0uQB5lbUvrJRDWli/FggUQ3HZ6ge7aTo+cjjHu4uHQC76AAowohlakk1fbOPRlNw== ${var.repository}"
}

resource "aws_launch_configuration" "app_lg" {
  name                 = "${var.repository}-lg"
  image_id             = data.aws_ami.ubuntu_18_04.id
  instance_type        = "t2.micro"
  key_name             = aws_key_pair.app_kp.key_name
  enable_monitoring    = true
  iam_instance_profile = aws_iam_instance_profile.app_ip.name
  security_groups      = [aws_security_group.ec2_sg.id]
  user_data_base64     = base64encode(data.template_file.user_data.rendered)

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg" {
  name                      = "${var.repository}-asg"
  desired_capacity          = 2
  min_size                  = 2
  max_size                  = 4
  termination_policies      = ["OldestInstance"]
  launch_configuration      = aws_launch_configuration.app_lg.name
  wait_for_elb_capacity     = 1
  wait_for_capacity_timeout = "5m"

  vpc_zone_identifier = [
    data.aws_subnet.secure_subnet_1.id,
    data.aws_subnet.secure_subnet_2.id,
    data.aws_subnet.secure_subnet_3.id,
  ]

  target_group_arns = [
    aws_lb_target_group.app_nlb_tg.arn,
  ]

  lifecycle {
    create_before_destroy = true
  }

  tags = [
    {
      key                 = "Name"
      value               = "${var.repository}-asg"
      propagate_at_launch = false
    },
    {
      key                 = "Repository"
      value               = var.repository
      propagate_at_launch = false
    },
    {
      key                 = "ManagedBY"
      value               = var.managed_by
      propagate_at_launch = false
    },
  ]
}
