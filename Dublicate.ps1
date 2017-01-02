#Find path
$Path = "D:\_Development"

#Create Log
write-host "Duplicate files found"
$Output = "C:\temp\Log.csv"
#Add-Content $Output 'Original,Status,Duplicate'

$count = 0
$hash = @()
# Get all the files
$files = (Get-ChildItem $Path -Recurse | where {$_.Length -gt 0})
Foreach($file in $files) {
    # work out the hash
    $hash += get-filehash -Path $file.FullName
    # Write-Progress -Activity "hashing" -status ($file.FullName) -PercentComplete (($count++ / $files.Count) * 100)
    Write-Progress -Activity $files.Count -status ($file.FullName + " - " + ($count++ -as [string]))
}
# group the files
foreach($DuplicateFile in ($hash | Group-Object hash | where { $_.count -gt 1 })) {
	# $Duplicates += $DuplicateFile.group | select Hash,Path
    $Text = $DuplicateFile.group | select Hash,Path
    Add-Content $Output $Text
    # Add-Content $Output $DuplicateFile.group | select Hash,Path
} 
# $Duplicates