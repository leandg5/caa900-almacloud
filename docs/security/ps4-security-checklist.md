# Progress Submission 4 — Security Checklist

**Project:** CAA900 Capstone — ALMA Cloud (Venezuelan Food E-Commerce)
**Team:** Leandro Delgado (114416241), Sharun Manakkara (148442247)
**Date:** November 2026

---

| # | Control | Evidence | Status |
|---|---|---|---|
| 1 | **Identity** — All users authenticated before accessing protected resources | Amazon Cognito User Pool enforces sign-in for all checkout and admin routes. API Gateway rejects unauthenticated requests with 401. | Done |
| 2 | **Tokens** — Auth tokens validated on every API call | API Gateway authorizer validates Cognito JWT on every request to `/order`, `/product`, and `/admin` endpoints. | Done |
| 3 | **Secrets** — No secrets in source code or repository | All secrets (STRIPE_SECRET_KEY, RESEND_API_KEY) stored in AWS Lambda environment variables and GitHub encrypted secrets. `.gitignore` covers `.env` and `*.tfvars`. SonarCloud scan confirms 0 hardcoded secrets. | Done |
| 4 | **Least privilege** — IAM roles grant only the permissions the function needs | Each Lambda function has its own IAM execution role. `alma-process-order` has DynamoDB read/write only on `Alma-orders`. `alma-get-products` has DynamoDB read-only on `Alma-products`. No `*` actions in any role. | Done |
| 5 | **Repository** — `.gitignore` prevents accidental secret commits | `.gitignore` covers `.env`, `*.tfvars`, `.terraform/`, `*.tfstate`, `*.tfstate.*`. Verified with SonarCloud security scan (CWE-312 — no exposed secrets). | Done |
| 6 | **Input validation** — API inputs validated before processing | Lambda functions validate required fields (product ID, quantity, Stripe token) and return 400 on missing or malformed input. | Done |
| 7 | **Output encoding** — Responses do not leak internal details | Lambda error responses return generic messages (e.g., "Order processing failed"). Stack traces are logged to CloudWatch only, never returned to the client. | Done |
| 8 | **Dependency scanning** — Third-party packages checked for known CVEs | SonarCloud dependency scan integrated in GitHub Actions CI pipeline. Build fails if critical CVEs are detected. Last scan: 0 critical vulnerabilities. | Done |
| 9 | **HTTPS** — All traffic encrypted in transit | CloudFront distribution enforces HTTPS-only (HTTP redirects to HTTPS). S3 bucket policy denies all HTTP access (`aws:SecureTransport: false`). API Gateway uses HTTPS endpoints only. | Done |
| 10 | **Security headers** — HTTP response headers protect against common attacks | CloudFront returns `Strict-Transport-Security`, `X-Content-Type-Options: nosniff`, `X-Frame-Options: DENY`, and `Content-Security-Policy` on all responses. | Done |
| 11 | **Logging** — Security-relevant events are logged | CloudWatch Logs enabled for all three Lambda functions. CloudWatch alarm `alma-lambda-errors` fires on ErrorCount >= 1 in 5 minutes. API Gateway access logging enabled. | Done |
| 12 | **Backups** — Data can be recovered after loss or corruption | DynamoDB Point-in-Time Recovery (PITR) enabled on both tables (`Alma-orders`, `Alma-products`). Retention: 35 days. RPO: 24 hours. DR test performed November 2026 — PASS. | Done |
| 13 | **Encryption at rest** — Stored data encrypted | DynamoDB tables use AWS-managed encryption at rest (SSE enabled by default). S3 bucket uses SSE-S3 encryption. | Done |
| 14 | **Rate limiting** — API protected against abuse | API Gateway usage plan limits requests to 1000 per second with a burst of 2000. Prevents DoS on order and product endpoints. | Done |
| 15 | **Static analysis** — Code scanned for security issues before deploy | SonarCloud integrated in GitHub Actions CI/CD pipeline. Quality Gate blocks merge on Security Rating below A. Final scan result: Security Rating A, 0 vulnerabilities, 0 security hotspots. | Done |
