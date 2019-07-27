<#
.SYNOPSIS

.DESCRIPTION

.PARAMETER Message

.PARAMETER ReportPath

.PARAMETER LogPath

.PARAMETER Type

.EXAMPLE

.NOTES
     Script Name: Write-LogFile
     Author: Scott Barton
     Version: 1

#>

function Invoke-SQLConnection {
     [cmdletBinding()]
     Param (
          [Parameter(Mandatory = $true)]
          [String]$Query,
          [Parameter(Mandatory = $true)]
          [String]$SQLServer,
          [Parameter(Mandatory = $true)]
          [String]$SQLDBName
     )

     try {
          $SQLConnection = New-Object System.Data.SqlClient.SqlConnection
          $SQLConnection.ConnectionString = "Server = $SQLServer; Database = $SQLDBName; Integrated Security = True"
          $SQLConnection.Open()
     }
     catch {
          Write-Host "Unable to connect to database: ($_.Exception.Message)"
     }

     if ($SQLConnection.State -eq "Open") {
          try {
               $SQLQuery = "$Query"
               $SQLCmd = New-Object System.Data.SqlClient.SqlCommand
               $SQLCmd.CommandTimeout = '6000'
               $SQLCmd.CommandText = $SQLQuery
               $SQLCmd.Connection = $SQLConnection
               $SQLAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
               $SQLAdapter.SelectCommand = $SQLCmd
               $SQLData = New-Object System.Data.DataSet
               $SQLAdapter.Fill($SQLData) | Out-Null
               $SQLConnection.Close()
               Return $SQLData.Tables[0]
          }
          catch {
               $SQLConnection.Close()
               Write-Host "Unable to obtain SQL data: ($_.Exception.Message)"
          }
     }
     else {
          Write-Host "Connection was closed"
          $SQLConnection.Close()
     }
}