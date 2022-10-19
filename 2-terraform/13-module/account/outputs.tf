output "id" { # id를 아웃풋 
  description = "The AWS Account ID."
  value       = data.aws_caller_identity.this.account_id
}

output "name" {   # 결과적으로 alias값을 output
  description = "Name of the AWS account. The account alias."
  value       = aws_iam_account_alias.this.account_alias
}

output "signin_url" {   # 사용자의 편의를 위해 접속 url을 제공 
  description = "The URL to signin for the AWS account."
  value       = "https://${var.name}.signin.aws.amazon.com/console"
}

output "password_policy" {
  description = "Password Policy for the AWS Account. `expire_passwords` indicates whether passwords in the account expire. Returns `true` if `max_password_age` contains a value greater than 0."
  value       = aws_iam_account_password_policy.this
}
