# Risk and issue register: ALMA Cloud

Last reviewed: 2026-11-14 by Leandro Delgado

## How to rate

- **Likelihood (L):** 1 = unlikely, 2 = possible, 3 = likely
- **Impact (I):** 1 = minor (hours of rework), 2 = moderate (a component is late or marks are lost), 3 = severe (the demo fails, data is exposed, or a deadline is missed)
- **Score** = L x I. Discuss every risk scoring 6 or more at each meeting.
- **Status:** open, mitigating, closed, or happened (then add it to the issue log below)

## Risks

| ID | Risk (if ..., then ...) | L | I | Score | Owner | Mitigation | Status |
|---|---|---|---|---|---|---|---|
| R1 | If we use up our Learner Lab credit before Week 12, then we cannot run the final demo | 2 | 3 | 6 | Leandro Delgado | Monitor remaining credit at every session; use serverless architecture (Lambda, API Gateway, DynamoDB) to minimize costs; destroy unused resources after each session; no idle EC2 instances | Mitigating |
| R2 | If AWS Learner Lab session expires during a deploy or demo, then CLI credentials stop working and the pipeline fails | 3 | 2 | 6 | Leandro Delgado | Update GitHub secrets AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY and AWS_SESSION_TOKEN at the start of each session; do not start a deploy in the last 30 minutes of a session; check session timer before any demo | Mitigating |
| R3 | If a required AWS service is restricted in Learner Lab, then a component is blocked | 2 | 3 | 6 | Leandro Delgado | Verified all services in use: Amplify, S3, CloudFront, Cognito, API Gateway, Lambda, DynamoDB, SES — all available in Learner Lab | Mitigating |
| R4 | If the demo environment lives only in one member's Learner Lab account and that member is absent, then the demo environment is gone | 1 | 3 | 3 | Leandro Delgado | Full infrastructure defined in Terraform IaC; can be rebuilt in a second account in under 30 minutes | Open |
| R5 | If a secret or token is committed to GitHub, then it must be rotated and the Security mark is reduced | 2 | 3 | 6 | Leandro Delgado | .gitignore covers .env, *.tfvars, .terraform/, *.tfstate; all secrets stored in GitHub encrypted secrets; SonarCloud security scan integrated in CI pipeline; SHA pinning applied to all GitHub Actions | Mitigating |
| R6 | If SES is in sandbox mode during the demo, then confirmation emails only reach verified addresses | 2 | 2 | 4 | Sharun Manakkara | Verify sender and all demo recipient addresses in advance; send a test email the day before each demo | Open |
| R7 | If the Stripe webhook secret is misconfigured, then every webhook fails signature check and orders stay pending | 2 | 3 | 6 | Sharun Manakkara | Store the whsec_ value of the deployed endpoint; make a test-mode payment after every deploy; alarm on webhook errors | Open |
| R8 | If a member is unavailable in a crunch week, then their component stalls | 2 | 2 | 4 | Both | Each component documented in README; Leandro owns infrastructure and security, Sharun owns payments and notifications | Open |
| R9 | If stretch features are built before required components are complete, then required components are late | 2 | 2 | 4 | Both | MVP first: product catalog, cart, checkout, order confirmation; stretch features only after Submission 3 items work; feature-complete date Nov 19 | Open |
| R10 | If the classroom network or AWS fails during the final presentation, then the live demo fails | 1 | 3 | 3 | Leandro Delgado | Phone hotspot as backup; recorded demo video prepared; run sheet with backup presenter | Open |

## Issue log (risks that happened, and other problems)

| ID | Issue | Raised (date, by) | Impact | Owner | Action | Due | Status |
|---|---|---|---|---|---|---|---|
| I1 | AWS Learner Lab credentials expired mid-session, breaking GitHub Actions deploy workflow | 2026-11-14, Leandro Delgado | Deploy pipeline failed; frontend not updated | Leandro Delgado | Updated AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY and AWS_SESSION_TOKEN in GitHub secrets; re-ran workflow successfully | 2026-11-14 | Closed |
| I2 | SonarCloud initial scan identified 5 security vulnerabilities (CWE-829, CWE-353, CWE-311) | 2026-11-14, Leandro Delgado | Security Rating C; Quality Gate failed | Leandro Delgado | Applied SHA pinning to GitHub Actions, added SRI to admin.html, added S3 HTTPS-only policy and logging in Terraform; final scan passed with Security Rating A | 2026-11-14 | Closed |

## Credit and cost log

| Date | Account (whose) | Credit used to date | Change since last entry | Biggest cost item | Note |
|---|---|---|---|---|---|
| 2026-11-14 | Leandro Delgado, AWS Learner Lab | ~$18 USD | ~$18 USD | S3 + CloudFront | Amplify hosting, S3 storage, CloudFront distribution, API Gateway, Lambda, DynamoDB; all serverless to minimize cost |
