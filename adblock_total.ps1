$files = gc -Path .\adblock_src.txt
$ipaddr ='\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b' #regex for a valid ipv4 address
foreach ($f in $files) {
    Invoke-WebRequest -uri "$f" | Add-Content -Path .\adblock_hosts.txt
}

$tmp = gc -Path "adblock_hosts.txt" | Select-String -pattern '(#)|([)|(])' -notmatch  #strip all comments and bracket blocks from entire file
$unsorted = $tmp -replace $ipaddr,"" -replace '(^\s+|\s+$)','' -replace '\s+','' | %{"||$_^"} #remove spaces and ip addresses, change format to adblock-plus eg. ||domain.example.com^ 
$unsorted > .\unsorted_list.txt #unsorted
$unsorted | sort-object -Unique > .\sorted_list.txt #sorted and duplicates removed