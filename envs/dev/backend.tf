terraform {
  backend "s3" {
    bucket         = "tfstate-lionkdt5-team5"
    key            = "project2/dev/terraform.tfstate"
    region         = "ap-northeast-2"
    dynamodb_table = "tfstate-lock-team5"
    encrypt        = true
  }
}