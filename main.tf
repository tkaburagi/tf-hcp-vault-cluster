provider "hcp" {}
provider "vault" {}

data "hcp_hvn" "main" {
  hvn_id = "hvn"
}

data "vault_aws_access_credentials" "creds" {
  backend = "aws"
  role    = "iam_admin_creds"
}

resource "hcp_vault_cluster" "vault_dev" {
  cluster_id = "vault-cluster-tmp"
  hvn_id     = "hvn"
  tier       = "plus_small"
  metrics_config {
    cloudwatch_region = "ap-northeast-1"
    cloudwatch_access_key_id  = data.vault_aws_access_credentials.creds.access_key
    cloudwatch_secret_access_key = data.vault_aws_access_credentials.creds.secret_key
  }
  audit_log_config {
    cloudwatch_region = "ap-northeast-1"
    cloudwatch_access_key_id  = data.vault_aws_access_credentials.creds.access_key
    cloudwatch_secret_access_key = data.vault_aws_access_credentials.creds.secret_key
  }
  lifecycle {
    prevent_destroy = true
  }
}
