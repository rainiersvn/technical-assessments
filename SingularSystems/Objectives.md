# DevOps Code Challenge Objectives

## Challenge Context

- This assessment tests your ability to research and develop DevOps solutions for cloud infrastructure and application deployment.
- You are provided with a Challenge Scenario to complete.
- The challenge is based on the requirements outlined in the provided `PDF` and this `Objectives` document.

> PLEASE NOTE: Only the main (1) `PDF Scenario`, (2) the `Terraform` IaC, (3) the `Dockerfile` and (4) the `README` are required for submission. All of the other objectives/sub-objectives are optional and when done will enhance your submission dramatically.
>
> These four criteria when done will allow us to evaluate the following skill-sets:
>
> - 1 - Your ability to follow and implement a given spec/scenario/requirement.
> - 2 - Your understanding of Infrastructure as Code (IaC) principles and practices.
> - 3 - Your ability to containerize applications and manage their lifecycle.
> - 4 - Your ability to write technical documentation and guides.
>
> CAVEAT: The use of AI is NOT prohibited, provided that you understand the implications and effects of the code it generates.

## 1. Required: Log Report Static Assets

- Given the DevOps Challenge specifications, implement the Log Reporter application/process.
- All `TASKS` in the spec must be completed to fulfill the requirements of this objective.

## 2. Required: Terraform Infrastructure as Code (IaC)

- All cloud resources must be managed using Terraform.
- For Azure, you should use the following resources:
  - `azurerm_resource_group`
  - `azurerm_storage_account`
  - `azurerm_storage_account_static_website`
  - `azurerm_storage_container`
  - `azurerm_storage_blob`
- If you choose AWS or GCP, use equivalent resources and follow the same IaC philosophy.
- The infrastructure must provision a static website hosting the generated reports HTML.
- You can make use of the default Azure Blob Storage static website FQDN.

## 3. Required: Containerisation of the Application

- Containerise the static site using Docker.
- Provide a `Dockerfile` that builds and serves the report via a web server (e.g., nginx, express.js, etc).
- Ensure the container exposes the correct port and includes all necessary static assets.

## 4. Optional: CI/CD Challenge Using GitHub Actions

- Implement a `GitHub Actions` workflow to automate building and deploying the static site.
- Example workflows may include:
  - Building the Docker image on push
  - Deploying the report to Azure Static Website using Azure CLI
- Use secrets for credentials and storage account information.

## 5. Optional: Generation of Site Favicon Using AI

- Generate a `favicon.ico` for the site using any AI tool or service.
- The favicon should be included in the static site and referenced appropriately.
- Document the AI method or tool used for favicon generation.

## 6. Required/Optional: Documentation

- Provide a README that explains your methodology used and gives step-by-step instructions to build and deploy the Docker container.
- Feel free to share additional context or artifacts that help demonstrate your fit for the role.
  - Include any extra materials that clarify your decisions or showcases the work.

---

## Deliverables

- (Required) 1. Static log report files (html, json) & application (PowerShell).
- (Required) 2. Terraform IaC for infrastructure provisioning.
- (Required) 3. The application's Dockerfile.
- (Optional) 4. GitHub Actions workflow for CI/CD - building the Dockerfile; deploying it to a target (GH Pages, Azure Static Web Site, etc.)
- (Optional) 5. AI-generated favicon.
- (Required) 6. README.md outlining:
  - (Required) Proposed steps to use/deploy the IaC and Containerised application.
  - (Optional) Documenting the AI favicon generation process, i.e., the tool used and the prompts given.
  - (Optional) Describe what you learned from the process, the challenges you faced, and how you overcame them.
  - (Optional) What would you have implemented differently, and what would you have added that the challenge didn’t specify?
