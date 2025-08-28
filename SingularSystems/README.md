# Singular Systems - Static Site & DevOps Challenge

## Table of Contents

- [Singular Systems - Static Site \& DevOps Challenge](#singular-systems---static-site--devops-challenge)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Contents](#contents)
  - [How to Run Locally](#how-to-run-locally)
  - [Infrastructure as Code](#infrastructure-as-code)
  - [Additional Scripts](#additional-scripts)
  - [Notes](#notes)

## Overview

This repository contains the solution for the Singular Systems DevOps Code Challenge. The main deliverables are:

- A static HTML report site (`report/report.html`)
- A Dockerfile to host the static site using nginx
- PowerShell scripts for site management
- Terraform files for infrastructure as code

## Contents

- `report/` - Contains the static HTML report (`report.html`) and supporting files
- `Dockerfile` - Builds a container image to serve the static site with nginx
- `start-docker-site.ps1` - PowerShell script to build and run the Docker container locally
- `LogReporter.ps1` - PowerShell script for log reporting
- `terraform/` - Infrastructure as code for deploying the static site

## How to Run Locally

1. **Build the Docker image:**

```powershell
docker build -t singular-static-site .
```

2. **Run the container:**

```powershell
docker run -p 8080:80 singular-static-site
```

3. **Access the site:**
   Open your browser to [http://localhost:8080](http://localhost:8080)

Alternatively, use the provided PowerShell script:

```powershell
./start-docker-site.ps1
```

## Infrastructure as Code

Terraform files in the `terraform/` directory allow you to provision cloud infrastructure for hosting the static site. See comments in the files for usage instructions.

## Additional Scripts

- `LogReporter.ps1` - For log management and reporting

## Notes

- The static site is served from the `report/` directory using nginx in the Docker container.
- All configuration and setup is self-contained in this repo.

---

