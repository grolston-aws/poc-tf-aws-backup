# AWS Backup Demo

The following Terraform-based project delivers the simple baseline backup strategy which leverages tagging to backup resources on a routine basis. **The solution can be implemented by simply placing a single tag on the AWS resource supported by AWS Backup.** Once the a specified tag is applied, the AWS resource will be backed up according to the `Backup Plan` designation.

> AWS Backup provides a centralized console to automate and manage backups across AWS services. AWS Backup supports Amazon EBS, Amazon RDS, Amazon DynamoDB, Amazon EFS, Amazon FSx, Amazon EC2, and AWS Storage Gateway, to enable you to backup key data stores, such as your storage volumes, databases, and file systems.

## Backup Plans

The demo AWS Backup solution delivers several tiers for managing backups which are based on a defined Recovery Point Objective (RPO).

| RPO | Runs Every | Tagging Schema |
| --- | ---------- | -------------- |
| 6 Hours | Runs at 6 AM/PM UTC and 12 AM/PM UTC | `rpo:6` |
| 12 Hours | Runs every 12 hours at 12 AM/PM UTC | `rpo:12` |
| 24 Hours | Runs every 24 hours at 3 AM | `rpo:24` |
| Weekly | Runs once a week on Sunday at 12 PM UTC | `rpo:weekly` |

## Variables

The following variables can be updated:

| variable | setting |
| -------- | ------- |
| cold_storage_after | 21 |
| delete_after | 111 |

> **Note:** The delete after day must be 90 days after moving to cold storage.
