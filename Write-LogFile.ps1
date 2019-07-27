<#
.SYNOPSIS

.DESCRIPTION
     Write-LogFile is a fantastic way to control output messages when running a script.

.PARAMETER Message
     This parameter is the main body of the message you wish to log into a file.

.PARAMETER ReportPath
     The ReportPath is the folder with which you want to save the file to. This is used if you want to save to a folder which might not already exist.

.PARAMETER LogPath
     The file name and location you wish you save.

.PARAMETER Type
     Use this parameter to specify the type of message, this will default to an information type log, unless specified. This also has a validation set against it for constant reporting.

.EXAMPLE
     Write-Log -Message "This message will show information" -Type Information
     Write-Log -Message "This is an error" -Type Error
     Write-Log -Message "This is a warning" -Type Warning
     Write-Log -Message "This will show a success" -Type Success

.NOTES
     Script Name: Write-LogFile
     Author: Scott Barton
     Version: 1

#>

function Write-LogFile {
     [CmdletBinding()]
     Param (
          [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
          [ValidateNotNullOrEmpty()]
          [String]$Message,
          [String]$ReportPath = "$ENV:USERPROFILE\DESKTOP\Report",
          [String]$LogPath = "$ENV:USERPROFILE\DESKTOP\Report\Logs-$(Get-Date -Format ddMMyyyy).log",
          [ValidateSet("Error", "Warning", "Information", "Success")]
          [String]$Type = "Information"
     )

     Begin {
          $OldVerbosePreference = $VerbosePreference
          $VerbosePreference = 'Continue'
     }

     Process {
          if (!(Test-Path $LogPath)) {
               Write-Verbose "Creating $LogPath."
               New-Item $ReportPath -Force -ItemType Directory -ErrorVariable Y -ErrorAction SilentlyContinue
               New-Item $LogPath -Force -ItemType File -ErrorVariable X -ErrorAction SilentlyContinue

               if ($Y) {
                    Write-Verbose "Failed to create report folder : $Y"
               }

               if ($X) {
                    Write-Verbose "Failed to create log file: $X"
               }

          }

          $FormattedDate = Get-Date -Format "dd-MM-yyyy HH:mm:ss"

          switch ($Type) {
               'Error' {
                    Write-Host "ERROR: $Message" -ForegroundColor Red
                    $TypeText = 'ERROR: '
               }
               'Warning' {
                    Write-Host "WARNING: $Message" -ForegroundColor Orange
                    $TypeText = 'WARNING: '
               }
               'Information' {
                    Write-Host "INFO: $Message" -ForegroundColor Cyan
                    $TypeText = 'INFO: '
               }
               'Success' {
                    Write-Host "SUCCESS: $Message" -ForegroundColor Green
                    $TypeText = 'Success: '
               }
          }
          "[$FormattedDate][$CurrentToolVersion][$ENV:USERNAME] $TypeText $Message" | Out-File -FilePath $LogPath -Append -ErrorAction SilentlyContinue
     }

     End {
          $VerbosePreference = $OldVerbosePreference
     }
}