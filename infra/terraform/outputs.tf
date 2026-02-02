output "s3_bucket" {
  value = aws_s3_bucket.todo_assets.id
}

output "ecr_repo" {
  value = aws_ecr_repository.todo_repo.repository_url
}