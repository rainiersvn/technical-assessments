class LogReporter {
    [string]$BaseUrl
    [string]$LogsManifest
    [string]$LocalLogFileDir
    [string]$LocalReportDir
    [string[]]$CsvHeaders = 'date', 'logLevel', 'user', 'message'
    [hashtable]$RawLogReport = @{}
    [object[]]$SortedLogReport

    LogReporter([string]$LogsManifest, [string]$LocalLogFileDir, [string]$LocalReportDir) {
        Write-Host "Initialising the LogReporter"
        try {
            $this.LogsManifest = $LogsManifest
            # https://files.singular-devops.com/challenges/01-applogs/index.txt
            $this.BaseUrl = "https://files.singular-devops.com/challenges/01-applogs" 
            $this.LocalLogFileDir = $LocalLogFileDir
            $this.LocalReportDir = $LocalReportDir
    
            # Create `logs` dir if it doesnt exist
            if (-not (Test-Path $this.LocalLogFileDir)) {
                Write-Host "  Creating directory" $this.LocalLogFileDir
                New-Item -ItemType Directory -Path $this.LocalLogFileDir | Out-Null
            }
    
            # Create `report` dir if it doesnt exist
            if (-not (Test-Path $this.LocalReportDir)) {
                Write-Host "  Creating directory" $this.LocalReportDir
                New-Item -ItemType Directory -Path $this.LocalReportDir | Out-Null
            }
        } catch {
            Write-Error $_.Exception.Message
        }
    }

    <#
        "Private" function used by `DownloadLogFiles`
        This function is used to query the manifest and build up an array of log file names
        that will be downloaded later on.
    #>
    [string[]] GetLogFileNames() {
        Write-Host "  Getting a list of all log files, from manifest, to aggregate"
        try {
            $Uri = $this.BaseUrl + "/" + $this.LogsManifest
            $Response = Invoke-WebRequest -Uri $Uri 
            $FilesToParse = $Response -split '\r?\n'
            # Filter out any empty file names from the response to not cause Write-Host 404 issues when downloading empty "" log file names,
            # lets just assume the above splitting will add an empty new line in the manifest as a file name entry to download.
            return $FilesToParse | Where-Object { $_ -ne "" }
        } catch {
            Write-Error $_.Exception.Message
            return $null
        }
    }

    # Does exactly what the name states, it downloads log files and saves them as CSV's to a local dr.
    [void] DownloadLogFiles() {
        Write-Host "  Downloading the list of log files for aggregation"
        try {
            $LogFiles = $this.GetLogFileNames()
            if ($null -eq $LogFiles) {
                Write-Error "Could not retrieve log file names to download"
                return
            }
        
            foreach ($LogFile in $LogFiles) {
                $LogFileUrl = $this.BaseUrl + "/" + $LogFile
                $LocalFilePath = Join-Path -Path $this.LocalLogFileDir -ChildPath $LogFile
                $CsvData = Invoke-WebRequest -Uri $LogFileUrl | ConvertFrom-Csv -Header $this.CsvHeaders
                $CsvData | Export-Csv -Path $LocalFilePath -NoTypeInformation
                Write-Host "    Downloaded log file: $LogFile"
            }     
        } catch {
            Write-Error $_.Exception.Message
        }
    }
    
    # This is the most meaty function, it does all of the aggergation and statistical calcs.
    [void] ParseLogFiles() {
        Write-Host "  Parsing and aggregating all log data"
        try {
            $LogFilesToParse = Get-ChildItem -Path $this.LocalLogFileDir -Filter *.csv
    
            # Loop over log file entries and read in the data with `Import-Csv`, then start constructing the data structure. 
            foreach ($LogFile in $LogFilesToParse) {
                $CsvData = Import-Csv $LogFile

                foreach ($LogEntry in $CsvData) {
                    # Extract the date from the log entry
                    $LogDate = [datetime]::ParseExact($LogEntry.date, "yyyy-MM-dd", $null)
                    $LogMonth = $LogDate.ToString("yyyy-MM")
        
                    if (-not $this.RawLogReport.ContainsKey($LogMonth)) {
                        $this.RawLogReport[$LogMonth] = @{
                            info    = 0
                            warning = 0
                            error   = 0
                        }
                    }
                    switch ($LogEntry.logLevel) {
                        { $_ -match 'info' } {
                            $this.RawLogReport[$LogMonth]["info"]++
                        }
                        { $_ -match 'warning' } {
                            $this.RawLogReport[$LogMonth]["warning"]++
                        }
                        { $_ -match 'error' } {
                            $this.RawLogReport[$LogMonth]["error"]++
                        }
                        default {
                            Write-Host "    The CSV row doesnt match anything!"
                            Write-Host "    LogEntry" $LogEntry
                        }
                    }
                }
            }
            <# 
                Here a lot of magic happens:
                - We Sort the data on the date(yyyy-MM)
                - We then loop over the data and construct a custom JSON array data object
                - We calculate the various changes in log levels for previous months
            #>
            $this.SortedLogReport = $this.RawLogReport.GetEnumerator() | Sort-Object -Property @{Expression={$_.Key};Ascending=$true} | ForEach-Object {
                $CurrentMonth = $_.Name
                $CurrentInfo = $_.Value.info
                $CurrentWarnings = $_.Value.warning
                $CurrentErrors = $_.Value.error
                
                if ($null -ne $PreviousWarnings -and $null -ne $PreviousErrors) {
                    $WarningChange = [Math]::Round((($CurrentWarnings - $PreviousWarnings) / $PreviousWarnings) * 100, 2)
                    $ErrorChange = [Math]::Round((($CurrentErrors - $PreviousErrors) / $PreviousErrors) * 100, 2)
                } else {
                    $WarningChange = $null
                    $ErrorChange = $null
                }
            
                [pscustomobject]@{
                    Month = $CurrentMonth
                    InfoLogCount = $CurrentInfo
                    WarningLogCount = $CurrentWarnings
                    ErrorLogCount = $CurrentErrors
                    WarningLogCountChange = $WarningChange
                    ErrorLogCountChange = $ErrorChange
                    # The below code will change the double values to strings and add a `%`, I left it commented to keep the code simpler.
                    # WarningLogCountChange = if ($warningChange) { $warningChange.ToString() + "%" } else { $null }
                    # ErrorLogCountChange   = if ($errorChange) { $errorChange.ToString() + "%" } else { $null } 
                }
            
                $PreviousWarnings = $CurrentWarnings
                $PreviousErrors = $CurrentErrors
            }
        } catch {
            Write-Error "" $_.Exception.Message
        }
    }

    # This function simply takes the sorted json data and converts it to a report
    [void] GenerateJsonReport() {
        Write-Host "  Storing the aggregated log report"
        try {
            # Convert the sorted data to JSON
            $JSON = $this.SortedLogReport | ConvertTo-Json -Depth 5
            $JsonReportPath = Join-Path $this.LocalReportDir "report.json"
            # Write the JSON back to a file in the specified location
            Set-Content -Path $JsonReportPath -Value $JSON
        } catch {
            Write-Error "" $_.Exception.Message
        }
    }
    
    [void]GenerateHtmlReport() {
        Write-Host "  Converting the json report to an html report"
        try {
            # Read and parse the JSON data
            $JsonDataPath = $this.LocalReportDir + "/report.json"
            $JsonData = Get-Content -Path $JsonDataPath | ConvertFrom-Json
            
            # Generate the HTML table
            $HtmlTable = "<table><style>table,th,td {border: 1px solid black; padding:15px}</style><thead><tr><th>Month</th><th>InfoLogs</th><th>WarningLogs</th><th>ErrorLogs</th><th>% Increase/Decrease of Warnings</th><th>% Increase/Decrease of Errors</th></tr></thead><tbody>"
            foreach ($MonthlyData in $JsonData.GetEnumerator() | Sort-Object -Property @{Expression = { $_.Key }; Ascending = $true }) {
                $HtmlTable += "<tr><td>$($MonthlyData.Month)</td><td>$($MonthlyData.InfoLogCount)</td><td>$($MonthlyData.WarningLogCount)</td><td>$($MonthlyData.ErrorLogCount)</td><td>$($MonthlyData.WarningLogCountChange)</td><td>$($MonthlyData.ErrorLogCountChange)</td></tr>"
            }
            $HtmlTable += "</tbody></table>"
            $HtmlLocalReportDir = $this.LocalReportDir + "/report.html"
            # Write the HTML file
            Set-Content -Path $HtmlLocalReportDir -Value $HtmlTable
        } catch {
            Write-Error "" $_.Exception.Message
        }
    }

    [void] AggregateLogData() {
        try {
            $this.DownloadLogFiles()
            $this.ParseLogFiles()
            $this.GenerateJsonReport()
            $this.GenerateHtmlReport()
        } catch {
            Write-Error $_.Exception.Message
        }
    }

}
[LogReporter]::new("index.txt", "./logs", "./report").AggregateLogData()
# $LogReporter = [LogReporter]::new("index.txt", "./logs", "./report")
# $LogReporter.DownloadLogFiles()
# $LogReporter.ParseLogFiles()
# $LogReporter.GenerateJsonReport()
# $LogReporter.GenerateHtmlReport()
# $LogReporter.AggregateLogData()