# ALMA Cloud — Disaster Recovery Plan

**Project:** CAA900 Capstone — ALMA Cloud (Venezuelan Food E-Commerce)
**Team:** Leandro Delgado, Sharun
**Platform:** AWS (us-east-1)
**Date:** November 2026

---

## 1. Overview

ALMA Cloud is a serverless e-commerce application built entirely on managed AWS services. Because there are no servers to maintain, recovery focuses on three areas: rebuilding infrastructure from code, restoring data, and redeploying the front end.

**Recovery Time Objective (RTO):** 30 minutes
**Recovery Point Objective (RPO):** 24 hours (DynamoDB point-in-time recovery)

---

## 2. Architecture Summary

| Component | Service | Recovery method |
|---|---|---|
| Front end | AWS Amplify + CloudFront | Redeploy from GitHub via CI/CD |
| API layer | Amazon API Gateway | Rebuilt by CloudFormation |
| Business logic | AWS Lambda (3 functions) | Rebuilt by CloudFormation |
| Database | Amazon DynamoDB (2 tables) | Point-in-time restore |
| Authentication | Amazon Cognito User Pool | Rebuilt by CloudFormation |
| Monitoring | CloudWatch alarm | Rebuilt by CloudFormation |
| IaC | CloudFormation | Source in `/infrastructure/template.yaml` |
| CI/CD | GitHub Actions | Source in `/.github/workflows/deploy.yml` |

---

## 3. Failure Scenarios

### 3.1 Lambda function failure
**Symptom:** API returns 500 errors. CloudWatch alarm `alma-lambda-errors` fires (ErrorCount >= 1 in 5 min).
**Recovery:**
1. Check CloudWatch Logs for the failing Lambda (`/aws/lambda/alma-process-order`, etc.)
2. Identify the error in the log stream
3. Push a fix to the `main` branch — GitHub Actions redeploys automatically
4. Verify CloudWatch logs clear after deploy

**RTO:** 10–15 minutes

### 3.2 DynamoDB table deleted or corrupted
**Symptom:** Lambda returns 400/500, logs show `ResourceNotFoundException` or wrong data.
**Recovery:**
1. Go to AWS Console > DynamoDB > Tables
2. Select the affected table (`Alma-orders` or `Alma-products`)
3. Click **Backups** > **Restore to point in time**
4. Choose the restore point (up to 35 days back)
5. Restore to a new table, then update the Lambda environment variable `TABLE_NAME` to point to the restored table
6. Alternatively, re-run `aws cloudformation deploy` to recreate the table from IaC, then re-seed products data

**RTO:** 20–30 minutes
**RPO:** Up to 24 hours (continuous backups enabled)

### 3.3 Full stack failure (account or region issue)
**Symptom:** All services unreachable.
**Recovery:**
1. Clone the repository: `git clone https://github.com/leandg5/caa900-almacloud`
2. Deploy infrastructure: `aws cloudformation deploy --template-file infrastructure/template.yaml --stack-name alma-cloud --capabilities CAPABILITY_IAM`
3. Set Lambda environment variables in AWS Console (RESEND_API_KEY, STRIPE_SECRET_KEY)
4. Push to `main` to trigger Amplify CI/CD rebuild
5. Verify live URL is accessible and a test order completes

**RTO:** 30 minutes

### 3.4 Front end unavailable (Amplify build failure)
**Symptom:** Website returns error or blank page.
**Recovery:**
1. Go to AWS Amplify console > ALMA app > Build history
2. Check the failed build log
3. Fix the issue in the repo and push to `main`
4. Amplify auto-triggers a new build
5. If urgent: manually trigger a build from the Amplify console

**RTO:** 5–10 minutes

### 3.5 Stripe or Resend API key compromised
**Symptom:** Orders fail with payment errors or emails stop sending.
**Recovery:**
1. Rotate the key in the Stripe or Resend dashboard immediately
2. Update the Lambda environment variable in AWS Console:
   - `STRIPE_SECRET_KEY` for Stripe
   - `RESEND_API_KEY` for Resend
3. Test a new order end to end

**RTO:** 5 minutes

---

## 4. DR Test Performed

**Date:** November 2026
**Scenario tested:** Lambda function failure and recovery

**Steps taken:**
1. Introduced a deliberate syntax error in `alma-process-order` and deployed it
2. Attempted to place a test order — API returned 500
3. CloudWatch alarm `alma-lambda-errors` triggered as expected
4. Fixed the code, pushed to `main`
5. GitHub Actions deployed the corrected Lambda automatically
6. Placed a new test order — succeeded, email received, order saved in DynamoDB

**Result:** PASS
**Time to recover:** 8 minutes
**RTO achieved:** 8 minutes (target: 30 minutes)
**RPO achieved:** 0 minutes (no data was lost — Lambda is stateless)

---

## 5. Backup Configuration

| Resource | Backup method | Retention |
|---|---|---|
| DynamoDB Alma-orders | Point-in-time recovery (enabled) | 35 days |
| DynamoDB Alma-products | Point-in-time recovery (enabled) | 35 days |
| Lambda code | GitHub repository (source of truth) | Indefinite |
| Infrastructure | CloudFormation template in repo | Indefinite |
| Front end | GitHub repository + Amplify build history | Indefinite |

---

## 6. Rebuild from Scratch (Step by Step)

These steps allow any team member to rebuild the entire ALMA Cloud stack from zero.

**Prerequisites:** AWS CLI configured, Node.js installed, GitHub access.

1. Clone the repo:
```
git clone https://github.com/leandg5/caa900-almacloud
cd caa900-almacloud
```

2. Deploy core infrastructure:
```
aws cloudformation deploy \
  --template-file infrastructure/template.yaml \
  --stack-name alma-cloud \
  --capabilities CAPABILITY_IAM \
  --region us-east-1
```

3. Add secrets to Lambda environment variables (AWS Console or CLI):
   - `STRIPE_SECRET_KEY` = sk_test_...
   - `RESEND_API_KEY` = re_...

4. Push to main to trigger Amplify auto-deploy:
```
git push origin main
```

5. Seed product data if DynamoDB Products table is empty (run seed script or add via admin panel).

6. Verify: open the live URL, add a product to cart, complete checkout with Stripe test card `4242 4242 4242 4242`, confirm email arrives.

**Total rebuild time:** ~30 minutes

---

## 7. Responsibilities

| Task | Owner |
|---|---|
| Monitor CloudWatch alarms | Leandro |
| Infrastructure rebuild | Leandro |
| Data restore (DynamoDB) | Leandro |
| Key rotation (Stripe, Resend) | Leandro |
| Front end redeploy | Sharun |
| DR test documentation | Leandro |

---

## 8. Well-Architected Alignment

This DR plan addresses the **Reliability** pillar of the AWS Well-Architected Framework:

- **Automatic recovery:** CloudWatch alarm detects Lambda errors automatically
- **Test recovery procedures:** DR test performed and documented (Section 4)
- **Scale horizontally:** Lambda scales automatically with load — no single point of failure
- **Stop guessing capacity:** Serverless architecture eliminates capacity planning
- **Manage change through automation:** All infrastructure changes go through CloudFormation and GitHub Actions CI/CD
zz
