resource "aws_s3_bucket" "archlinux" {
  bucket = "archlinux.${cloudflare_zone.jaan_xyz.zone}"
  acl    = "public-read"

  website {
    index_document = "index.html"
  }
}

resource "aws_s3_bucket_policy" "archlinux" {
  bucket = aws_s3_bucket.archlinux.id

  policy = <<-EOF
  {
    "Version":"2012-10-17",
    "Statement":[
      {
        "Sid":"PublicRead",
        "Effect":"Allow",
        "Principal": "*",
        "Action":["s3:GetObject","s3:GetObjectVersion"],
        "Resource":["${aws_s3_bucket.archlinux.arn}/*"]
      }
    ]
  }
  EOF
}

resource "cloudflare_record" "archlinux" {
  zone_id = cloudflare_zone.jaan_xyz.id
  name    = "archlinux"
  type    = "CNAME"
  value   = aws_s3_bucket.archlinux.website_endpoint
}

resource "aws_iam_group" "archlinux" {
  name = "archlinux"
}

resource "aws_iam_group_policy" "allow_package_upload" {
  name   = "archlinux-upload"
  group  = aws_iam_group.archlinux.name
  policy = <<-EOF
  {
     "Version":"2012-10-17",
     "Statement":[
        {
           "Effect":"Allow",
           "Action": "s3:ListAllMyBuckets",
           "Resource":"arn:aws:s3:::*"
        },
        {
           "Effect":"Allow",
           "Action":["s3:ListBucket","s3:GetBucketLocation"],
           "Resource":"${aws_s3_bucket.archlinux.arn}"
        },
        {
           "Effect":"Allow",
           "Action":[
              "s3:PutObject",
              "s3:PutObjectAcl",
              "s3:GetObject",
              "s3:GetObjectAcl",
              "s3:DeleteObject"
           ],
           "Resource":"${aws_s3_bucket.archlinux.arn}/*"
        }
     ]
  }
  EOF
}

module "falstaff_build" {
  source = "./iam_user"

  name = "falstaff_build"
  path = "/archlinux/"
  groups = [
    aws_iam_group.archlinux.name,
  ]
}

output "iam_user-falstaff_build" {
  value     = module.falstaff_build
  sensitive = true
}
