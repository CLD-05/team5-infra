# ------------------------------------------------------------------------------
# Trust Policy for IRSA
# ------------------------------------------------------------------------------

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    principals {
      type = "Federated"
      identifiers = [
        var.oidc_provider_arn
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "${var.oidc_provider_url}:sub"

      values = [
        "system:serviceaccount:${var.namespace}:${var.service_account_name}"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "${var.oidc_provider_url}:aud"

      values = [
        "sts.amazonaws.com"
      ]
    }
  }
}

# ------------------------------------------------------------------------------
# IAM Role for App Pod
# ------------------------------------------------------------------------------

resource "aws_iam_role" "this" {
  name               = "${var.name_prefix}-app-s3-irsa-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-app-s3-irsa-role"
  })
}

# ------------------------------------------------------------------------------
# S3 Access Policy
# ------------------------------------------------------------------------------

data "aws_iam_policy_document" "s3_access" {
  statement {
    sid    = "ListBucket"
    effect = "Allow"

    actions = [
      "s3:ListBucket"
    ]

    resources = [
      var.bucket_arn
    ]

    condition {
      test     = "StringLike"
      variable = "s3:prefix"

      values = [
        "${var.image_prefix}/*"
      ]
    }
  }

  statement {
    sid    = "ManageImageObjects"
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]

    resources = [
      "${var.bucket_arn}/${var.image_prefix}/*"
    ]
  }
}

resource "aws_iam_policy" "this" {
  name        = "${var.name_prefix}-app-s3-policy"
  description = "Allow PetCareLog app pod to manage pet image objects in S3"
  policy      = data.aws_iam_policy_document.s3_access.json

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-app-s3-policy"
  })
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}