terraform {
  backend "s3" {
    bucket         = "team5-petcarelog-terraform-cld05-state"
    key            = "envs/dev/terraform.tfstate"
    region         = "ap-northeast-2"
    dynamodb_table = "team5-petcarelog-terraform-lock"
    encrypt        = true

  }
}