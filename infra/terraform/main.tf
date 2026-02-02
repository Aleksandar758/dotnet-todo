resource "aws_s3_bucket" "todo_assets" {
  bucket = "todo-assets-${random_id.bucket_id.hex}"
  tags = {
    Name = "todo-assets"
  }
}

resource "random_id" "bucket_id" {
  byte_length = 4
}

resource "aws_ecr_repository" "todo_repo" {
  name = "todo-repo"
}

# Example of exposing app with a load balancer (conceptual for LocalStack)
resource "aws_lb" "todo_lb" {
  name               = "todo-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = []
}
