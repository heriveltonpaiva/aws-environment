/**
resource "aws_iam_policy" "policy_code_pipeline" {
  name = "code_pipeline_policy"
  path = "/"
  description = "Policy Code pipeline"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "codepipeline:PutThirdPartyJobSuccessResult",
                "codepipeline:PutThirdPartyJobFailureResult",
                "codepipeline:PollForThirdPartyJobs",
                "codepipeline:PutJobFailureResult",
                "codepipeline:PutJobSuccessResult",
                "codepipeline:AcknowledgeJob",
                "codepipeline:AcknowledgeThirdPartyJob",
                "codepipeline:GetThirdPartyJobDetails",
                "codepipeline:GetJobDetails"
            ],
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": "codepipeline:*",
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor2",
            "Effect": "Allow",
            "Action": "codepipeline:*",
            "Resource": "arn:aws:codepipeline:*:*:*"
        }
    ]
}
EOF
}
resource "aws_iam_role" "code_build_role" {
  name = "code_build_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
   {
      "Sid": "CodeBuildDefaultPolicy",
      "Effect": "Allow",
      "Action": [
        "codebuild:*",
        "iam:PassRole"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}
**/