# Week 3 check-in and Update 1 prep: ALMA Cloud

| Item | Detail |
|---|---|
| Team | ALMA Cloud |
| Members | Leandro Delgado |
| Platform and region | Host member's Learner Lab, owned by Leandro Delgado |
| Repository | https://github.com/leandg5/caa900-almacloud |
| Live URL | Not yet |

## 1. Learning and Progress Update 1 (5 minutes, strict)

| Part | Time | Speaker | What we say or show |
|---|---|---|---|
| Learned | 1 min | Leandro Delgado | Serverless architecture scales automatically and costs nothing when idle, so we chose Lambda and DynamoDB over EC2 and RDS to keep ALMA affordable for a one-person company |
| Progress | 2 min | Leandro Delgado | Pain point: "I lose orders because people message me on Instagram and WhatsApp and I forget to follow up. I have no way to take payments online." Show Learner Lab page with remaining credit, GitHub repository with README, and architecture v0 diagram |
| Blockers | 1 min | Leandro Delgado | Biggest unknown: whether Cognito, SES, and API Gateway are fully available in Learner Lab. What we tried: reviewed the Learner Lab README and confirmed Cognito user pools are supported |
| Next | 1 min | Leandro Delgado | True by Oct 5: front end live with owner view and customer view, architecture v1, identity and network design. Owner: Leandro Delgado |

## 2. Check-in answers (10 minutes with the instructor)

| Check-in question | Our answer | Who answers |
|---|---|---|
| Who is on the team, and who did what in Submission 1? | Leandro Delgado: defined the OPC persona, wrote the pain point, designed architecture v0, set up the GitHub repository, and completed Progress Submission 1 | Leandro Delgado |
| Say the pain point in the owner's words. Who is the second user role? | "I lose orders because people message me on Instagram and WhatsApp and I forget to follow up. I have no way to take payments online, I never know which products are selling, and I spend more time answering messages than making food." Second role: customer | Leandro Delgado |
| Which reference pattern, and what is different in your version? | Pattern A, serverless e-commerce. We added Stripe test mode for sandbox payments and Terraform for infrastructure as code because ALMA needs a reproducible deployment for future franchise locations | Leandro Delgado |
| Is the platform working? Show the console and your cost control | Learner Lab page with remaining credit ready to show. Access to Learner Lab provided by instructor. LabRole used for all functions. Confirmed in lab README: Cognito, Lambda, API Gateway, DynamoDB, S3, SES, CloudWatch are supported | Leandro Delgado |
| What is the first thing you will show live on Oct 8? | The ALMA frontend live at a public CloudFront URL with the customer product listing page and the owner dashboard, using sample product data | Leandro Delgado |
| Any concern about the team, workload, or the topic? | Solo team. MVP is a working e-commerce flow where a customer browses products, places an order, pays via Stripe test mode, and receives an email confirmation. Cut: owner analytics dashboard and inventory management | Leandro Delgado |

## 3. Open these before class

- [ ] Learner Lab session started
- [ ] Screenshot of remaining credit on the Learner Lab page
- [ ] GitHub repository: https://github.com/leandg5/caa900-almacloud
- [ ] Progress Submission 1 and architecture v0
- [ ] Nothing secret on screen

## 4. After the check-in

Instructor decision:

- [ ] Topic approved
- [ ] Approved with changes
- [ ] Resubmit by Sun Sept 27

| # | Action agreed at the check-in | Owner | Due |
|---|---|---|---|
| | | | |

## 5. Readiness and Gap Analysis

| Gap area | Current state | Target state | Gap size |
|---|---|---|---|
| People | Solo student, no prior AWS deployment experience | Able to deploy full serverless stack on AWS independently | High |
| Process | No CI/CD pipeline exists yet | GitHub Actions deploys automatically on every push | Medium |
| Technology | No AWS resources created yet, Learner Lab access pending | Full serverless stack running on Learner Lab | High |

Biggest gap: Technology. No AWS resources exist yet because Learner Lab access has not been provided by the instructor as of October 3.

Readiness score: 4 out of 10. Proposal, architecture, repository, and documentation are complete. Infrastructure deployment has not started due to missing Learner Lab access.
