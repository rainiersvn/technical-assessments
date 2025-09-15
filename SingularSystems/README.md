## Singular Systems - DevOps Code Challenge 2025

### 1. Brief Description of Solution and Approach
This solution automates the aggregation and reporting of application logs using PowerShell. The `LogReporter.ps1` script downloads log files from a remote manifest, parses and aggregates log data by month and log level, and generates both JSON and HTML reports. The HTML report is served via a Dockerized Nginx container for easy viewing.

### 2. How to Run the Solution Locally
#### Prerequisites:
- PowerShell (Windows)
- Docker

#### Steps:
1. Run the log aggregation script:
	```powershell
	.\LogReporter.ps1
	```
	This will download logs, generate reports, and save them in the `report/` directory.
2. Build and run the static site with Docker:
	```powershell
	.\start-docker-site.ps1
	```
	This will build the Docker image and start a container serving the HTML report at [http://localhost:8080](http://localhost:8080).

### 3. Assumptions Made
- The log manifest and log files are publicly accessible at the provided URLs.
- The log files are in CSV format and match the expected headers.
- The environment is Windows with PowerShell and Docker installed.
- No authentication is required to access the log files.

### 4. Additional Notes or Comments
- The solution is modular and can be extended to support other log formats or output types.
- Error handling is included for network and file operations.
- The HTML report is generated for easy visualization and can be customized further.
- For any issues, check PowerShell and Docker installation, and ensure network access to the log file URLs.
- The full chat & prompt history can be found in the [prompt.md](prompt.md) file in this directory.