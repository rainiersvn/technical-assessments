# DevOps Code Challenge Objectives

- [Challenge Context](#challenge-context)
- [Deliverables](#deliverables)
- [1. Log Report Static Assets](#1-log-report-static-assets)
- [2. Containerisation of the Application](#2-containerisation-of-the-application)
- [3. CI/CD Challenge Using GitHub Actions](#3-cicd-challenge-using-github-actions)
- [4. Documentation](#4-documentation)

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

## Deliverables

- 1. Static log report files (html, json) & application (PowerShell).
- 3. The application's Dockerfile.
- 4. GitHub Actions workflow for CI/CD - building the Dockerfile; deploying it to a target (GH Pages, Azure Static Web Site, etc.)
- 6. README.md outlining:
  - Proposed steps to use/deploy the IaC and Containerised application.
  - Documenting the AI favicon generation process, i.e., the tool used and the prompts given.
  - Describe what you learned from the process, the challenges you faced, and how you overcame them.
  - What would you have implemented differently, and what would you have added that the challenge didn’t specify?

---

## 1. Log Report Static Assets

- Given the DevOps Challenge specifications, implement the Log Reporter application/process.
- All `TASKS` in the spec must be completed to fulfill the requirements of this objective.

## 2. Containerisation of the Application

- Provide a `Dockerfile` that builds and serves the report via a web server (e.g., nginx, express.js, etc).
  - Using middleware or best-practice configuration to serve static assets is encouraged. 
- Ensure the container exposes the correct port and includes all necessary static assets.

## 3. CI/CD Challenge Using GitHub Actions

- Implement a `GitHub Actions` workflow to automate building and deploying the static site.
- Example workflows may include:
  - Building the Docker image on push
  - Deploying the report to Azure Static Website using Azure CLI
- Use secrets for credentials and storage account information.

## 4. Documentation

- Provide a README that explains your methodology used and gives step-by-step instructions to build and deploy the Docker container.
- Feel free to share additional context or artifacts that help demonstrate your fit for the role.
  - Include any extra materials that clarify your decisions or showcases the work.

# FEEDBACK:
- Drop unneeded requirements, keep boilerplate setup to a minimum, focus on core deliverables.
- Ask the candidate to provide as much info on their usage of AI, preferably sharing public links to their chat history (or their full chat history in a medium like a Readme or Word Document).