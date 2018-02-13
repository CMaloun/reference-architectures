[CmdletBinding()]
Param(
  [Parameter(Mandatory=$True)]
  [string]$AdminUser,

  [Parameter(Mandatory=$True)]
  [string]$AdminPassword,

  [Parameter(Mandatory=$True)]
  [string]$SafeModePassword,

  [Parameter(Mandatory=$True)]
  [string]$DomainName,

  [Parameter(Mandatory=$True)]
  [string]$SiteName,
  
  [Parameter(Mandatory=$True)]
  [string]$NTDSpath,
  
  [Parameter(Mandatory=$True)]
  [string]$SYSVOLpath
)

$secSafeModePassword = ConvertTo-SecureString $SafeModePassword -AsPlainText -Force
$secAdminPassword = ConvertTo-SecureString $AdminPassword -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential ("$DomainName\$AdminUser", $secAdminPassword)

Install-WindowsFeature –Name AD-Domain-Services -includemanagementtools

Install-ADDSDomainController `
-Credential $credential `
-DomainName $DomainName `
-CriticalReplicationOnly:$false `
-SafeModeAdministratorPassword $secSafeModePassword `
-InstallDNS:$true `
-LogPath $NTDSpath `
-DatabasePath $NTDSpath `
-ReadOnlyReplica:$true `
-SiteName $SiteName `
-SYSVOLPath $SYSVOLpath `
-Force:$true
