provider "aws" {
  profile = "default"
  version = "~> 2.42"
  region  = var.aws_region
}

terraform {
  backend "s3" {
    bucket = "tfstate-workload1"
    key    = "workload1-awsbackup/terraform.tfstate"
    region = "us-west-2"
  }
}

resource "aws_iam_role" "aws_backup" {
  name               = "aws_backupOperator"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": ["sts:AssumeRole"],
      "Effect": "allow",
      "Principal": {
        "Service": ["backup.amazonaws.com"]
      }
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "aws_backup_role_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = aws_iam_role.aws_backup.name
}

resource "aws_backup_vault" "aws_backup_vault" {
  name        = "aws_backup_vault"
  kms_key_arn = aws_kms_key.aws_backup_kms.arn
}

resource "aws_kms_key" "aws_backup_kms" {
  description = "aws Backup KMS key"
}

## RPO 6 Hours
resource "aws_backup_plan" "aws_backup_rpo_6" {
  name = "aws_backup_rpo_6"

  rule {
    rule_name         = "aws_backup_rule_rpo_6"
    target_vault_name = aws_backup_vault.aws_backup_vault.name
    schedule          = "cron(0 0,6,12,18 * * ? *)" # runs at 6 AM/PM UTC and 12 AM/PM UTC
    lifecycle {
      cold_storage_after = var.cold_storage_after
      delete_after       = var.delete_after
    }
  }
}

resource "aws_backup_selection" "Rpo_6Hrs" {
  iam_role_arn = aws_iam_role.aws_backup.arn
  name         = "awsBackupPlanRPO6hours"
  plan_id      = aws_backup_plan.aws_backup_rpo_6.id

  selection_tag {
    type  = "STRINGEQUALS"
    key   = "rpo"
    value = "6"
  }
}

## RPO 12 Hours
resource "aws_backup_plan" "aws_backup_rpo_12" {
  name = "aws_backup_rpo_12"

  rule {
    rule_name         = "aws_backup_rule_rpo_12"
    target_vault_name = aws_backup_vault.aws_backup_vault.name
    schedule          = "cron(0 0,12 * * ? *)" # runs every 12 hours at 12PM UTC
    lifecycle {
      cold_storage_after = var.cold_storage_after
      delete_after       = var.delete_after
    }
  }
}

resource "aws_backup_selection" "Rpo_12Hrs" {
  iam_role_arn = aws_iam_role.aws_backup.arn
  name         = "awsBackupPlanRPO12hours"
  plan_id      = aws_backup_plan.aws_backup_rpo_12.id

  selection_tag {
    type  = "STRINGEQUALS"
    key   = "rpo"
    value = "12"
  }
}

## RPO 24 Hours
resource "aws_backup_plan" "aws_backup_rpo_24" {
  name = "aws_backup_rpo_24"

  rule {
    rule_name         = "aws_backup_rule_rpo_24"
    target_vault_name = aws_backup_vault.aws_backup_vault.name
    schedule          = "cron(0 3 * * ? *)" # Runs every 24 hours at 3 AM UTC
    lifecycle           {
      cold_storage_after = var.cold_storage_after
      delete_after       = var.delete_after
    }
  }
}

resource "aws_backup_selection" "Rpo_24Hrs" {
  iam_role_arn = aws_iam_role.aws_backup.arn
  name         = "awsBackupPlanRPO24hours"
  plan_id      = aws_backup_plan.aws_backup_rpo_24.id

  selection_tag {
    type  = "STRINGEQUALS"
    key   = "rpo"
    value = "24"
  }
}

## RPO 1 Week
resource "aws_backup_plan" "aws_backup_rpo_weekly" {
  name = "aws_backup_rpo_weekly"

  rule {
    rule_name         = "aws_backup_rule_rpo_weekly"
    target_vault_name = aws_backup_vault.aws_backup_vault.name
    schedule          = "cron(0 12 ? * SUN *)" # runs once a week on Sunday at 12 PM UTC
    lifecycle           {
      cold_storage_after = var.cold_storage_after
      delete_after       = var.delete_after
    }
  }
}

resource "aws_backup_selection" "Rpo_Weekly" {
  iam_role_arn = aws_iam_role.aws_backup.arn
  name         = "awsBackupPlanRPOWeekly"
  plan_id      = aws_backup_plan.aws_backup_rpo_weekly.id

  selection_tag {
    type  = "STRINGEQUALS"
    key   = "rpo"
    value = "Weekly"
  }
}