resource "aws_s3_bucket" "bucket" {
  bucket = "gss-infoteck-siri"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
# enble versioning
resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}
# upload multiple files
resource "aws_s3_bucket_object" "test" {
  for_each = fileset(path.module, "sample/**")
  bucket   = aws_s3_bucket.bucket.bucket
  key      = each.value
  source   = "${path.module}/${each.value}"

}
output "fileset-results" {
  value = fileset(path.module, "sample/**")
}
# attach policy $ static website
resource "aws_s3_bucket_policy" "default" {
  bucket = aws_s3_bucket.bucket.id
  policy = data.aws_iam_policy_document.default.json
}
data "aws_iam_policy_document" "default" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.bucket.arn}/*"]
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }
}
