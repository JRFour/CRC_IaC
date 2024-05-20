#
#
# IAM User creation
#
#

module "iam_user" {
  source = "./.terraform/modules/iam/modules/iam-user"

  name = "user-1"
  force_destroy = false

  create_iam_user_login_profile = false
  create_iam_access_key = true
}
