 <#
 #2022.11.24 --by zhou@Transform , this script to query disk space including mounting directories space on a server, take computer name by input box 
 # to get one server's current disk space status 
 # including mounted folder free space 
 #use ` to wrap lines continue next line
 # replace the computername to what to be queried.
 #>

 # use pop us window to input computer name for which disk space is concerned, then assigne to variable $sComputer 
 [void][Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')
 $title = 'Computer Name'
 $msg   = 'Enter your computer Name for its disk space to be queried:'
 $sComputer= [Microsoft.VisualBasic.Interaction]::InputBox($msg, $title)

 #echo the computer name inputted , use `n to give a blank line at top 
 Write-Host "`nDisk space on computer : "   $sComputer

 #if just run adhoc in command line, replace the $sComputer with the actual "computername" enbraced with quote
 #Get-WmiObject -Class win32_volume -ComputerName $sComputer | Select-Object Name,Label,@{N='Free';E={[math]::round($_.freespace / 1GB,2)}}, @{N=’Total’; E={[math]::Round($_.capacity / 1GB,2)}} | Where-Object{$_.name -like "*:*"}|Sort-Object  Name 
 
 #--get free percent and exclude mapped drives with 0 GB total , sort by Name or whatever you choose by change it.
 Get-WmiObject -Class win32_volume -ComputerName $sComputer  `
 | Select-Object Name,Label,@{N='FreeGB';E={[math]::round($_.freespace / 1GB,2)}}, @{N=’TotalGB’; E={[math]::Round($_.capacity / 1GB,2)}} , @{N="FreePct";E={[math]::round($_.freespace*100/$_.capacity, 2)}} `
 | Where-Object{($_.name -like "*:*") -and !($_.TotalGB -eq 0) } `
 |Sort-Object  Name `
 |Format-Table -Wrap
