
/* CodeBuild


data "template_file" "buildspec" {
  template = "${file("${path.module}/pipeline/buildspec.yml")}"

  vars = {
    repository_url = aws_ecr_repository.openjobs_app.repository_url
    region = var.region
    cluster_name = var.ecs_cluster_name
    subnet_id          = element(aws_subnet.public_subnet.*.id, 0)

  }
}


resource "aws_codebuild_project" "openjobs_build" {
  name = "openjobs-codebuild"
  build_timeout = "10"
  service_role = "${aws_iam_role.code_build_role.arn}"

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image = "aws/codebuild/docker:1.12.1"
    type = "LINUX_CONTAINER"
    privileged_mode = true
  }

  source {
    type = "CODEPIPELINE"
    buildspec = "${data.template_file.buildspec.rendered}"
  }
}


resource "aws_codepipeline" "pipeline" {
  name = "openjobs-pipeline"
  role_arn = "${aws_iam_policy.policy_code_pipeline.arn}"

  artifact_store {
    location = "${aws_s3_bucket.hpaiva-bucket.bucket}"
    type = "S3"
  }

  stage {
    name = "Source"

    action {
      name = "Source"
      category = "Source"
      owner = "ThirdParty"
      provider = "GitHub"
      version = "1"
      output_artifacts = [
        "source"]

      configuration  = {
        Owner = "heriveltonpaiva"
        Repo = "openjobs_experiment"
        Branch = "master"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name = "Build"
      category = "Build"
      owner = "AWS"
      provider = "CodeBuild"
      version = "1"
      input_artifacts = [
        "source"]
      output_artifacts = [
        "imagedefinitions"]

      configuration = {
        ProjectName = "openjobs-codebuild"
      }
    }
  }

  stage {
    name = "Production"

    action {
      name = "Deploy"
      category = "Deploy"
      owner = "AWS"
      provider = "ECS"
      input_artifacts = [
        "imagedefinitions"]
      version = "1"

      configuration = {
        ClusterName = "${var.ecs_cluster_name}"
        ServiceName = "${var.ecs_service_name}"
        FileName = "imagedefinitions.json"
      }
    }
  }
}

*/