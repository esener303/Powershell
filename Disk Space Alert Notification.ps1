#################################################################################################################################################################
#
# Michał Demczyszak @ Konica Minolta Buisness Solution Sp. z o.o. 2017
#
#################################################################################################################################################################
Set-ExecutionPolicy -ExecutionPolicy "Unrestricted" -Scope LocalMachine -Force 
$users = "michal.demczyszak@konicaminolta.pl" # List of users to email your report to (separate by comma)
$fromemail = "eod@zecstar.pl"
$server = "DCQGCDD2.ZEC.lokalne" #enter your own SMTP server DNS name / IP address here
#This accepts the argument you add to your scheduled task for the list of servers. i.e. list.txt
$computers = "DCQGCDD2" #grab the names of the servers/computers to check from the list.txt file.
#Set free disk space threshold below in percent (default at 10%)
[decimal]$thresholdspace = 10
 
#assemble together all of the free disk space data from the list of servers and only include it if the percentage free is below the threshold we set above.
$tableFragment = Get-WMIObject -ComputerName $computers Win32_LogicalDisk -fi "drivetype=3" | select VolumeName, Name, @{n='Size (Gb)' ;e={"{0:n2}" -f ($_.size/1gb)}},@{n='FreeSpace (Gb)';e={"{0:n2}" -f ($_.freespace/1gb)}}, @{n='PercentFree';e={"{0:n2}" -f ($_.freespace/$_.size*100)}} | Where-Object {([decimal]$_.PercentFree -lt [decimal]$thresholdspace)} | ConvertTo-Html

# assemble the HTML for our body of the email report.
$HTMLmessage = @"
<font color=""black"" face=""Arial, Verdana"" size=""4"">
<u><b>Disk Space Storage Alert</b></u>
<br>
<br>This report was generated because the drive(s) listed below have less than $thresholdspace % free space. Drives above this threshold will not be listed.
<br>
<style type=""text/css"">body{font: .9em ""Lucida Grande"", Tahoma, Arial, Helvetica, sans-serif;}
ol{margin:0;padding: 0 1.5em;}
table{color:#FFF;background:#C00;border-collapse:collapse;width:647px;border:5px solid #900;}
thead{}
thead th{padding:1em 1em .5em;border-bottom:1px dotted #FFF;font-size:120%;text-align:left;}
thead tr{}
td{padding:.5em 1em;}
tfoot{}
tfoot td{padding-bottom:1.5em;}
tfoot tr{}
#middle{background-color:#900;}
</style>
<body BGCOLOR=""white"">
$tableFragment
</body>
"@ 
 
# Set up a regex search and match to look for any <td> tags in our body. These would only be present if the script above found disks below the threshold of free space.
# We use this regex matching method to determine whether or not we should send the email and report.
$regexsubject = $HTMLmessage
$regex = [regex] '(?im)<td>'

# if there was any row at all, send the email
if ($regex.IsMatch($regexsubject)) 
{ 
send-mailmessage -from $fromemail -to $users -subject "Disk Space $computers Alert - This report was generated because the drive(s) listed below have less than $thresholdspace % free space." -BodyAsHTML -body $HTMLmessage -priority High -smtpServer $server 
}
# End of Script