locals {
  oidc_provider_url = replace(var.cluster_oidc_issuer_url, "https://", "")
}

data "tls_certificate" "eks_oidc" {
  url = var.cluster_oidc_issuer_url
}

resource "aws_iam_openid_connect_provider" "eks" {
  url = var.cluster_oidc_issuer_url

  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = [
    data.tls_certificate.eks_oidc.certificates[0].sha1_fingerprint
  ]

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-eks-oidc-provider"
  })
}

data "aws_iam_policy_document" "irsa_assume_role" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    principals {
      type = "Federated"

      identifiers = [
        aws_iam_openid_connect_provider.eks.arn
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.oidc_provider_url}:sub"

      values = [
        "system:serviceaccount:${var.namespace}:${var.service_account_name}"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.oidc_provider_url}:aud"

      values = [
        "sts.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "irsa" {
  name = "${var.name_prefix}-${var.service_account_name}-irsa-role"

  assume_role_policy = data.aws_iam_policy_document.irsa_assume_role.json

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-${var.service_account_name}-irsa-role"
  })
}

data "aws_iam_policy_document" "irsa_policy" {
  statement {
    sid    = "SecretsManagerRead"
    effect = "Allow"

    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret"
    ]

    resources = [
      "*"
    ]
  }

  statement {
    sid    = "S3ListPetImageBucket"
    effect = "Allow"

    actions = [
      "s3:ListBucket"
    ]

    resources = [
      var.pet_image_bucket_arn
    ]
  }

  statement {
    sid    = "S3PetImageObjectAccess"
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]

    resources = [
      "${var.pet_image_bucket_arn}/*"
    ]
  }
}

resource "aws_iam_policy" "irsa" {
  name = "${var.name_prefix}-${var.service_account_name}-irsa-policy"

  policy = data.aws_iam_policy_document.irsa_policy.json

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-${var.service_account_name}-irsa-policy"
  })
}

resource "aws_iam_role_policy_attachment" "irsa" {
  role       = aws_iam_role.irsa.name
  policy_arn = aws_iam_policy.irsa.arn
}
