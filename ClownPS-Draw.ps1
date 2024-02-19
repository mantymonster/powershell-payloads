function Get-fullName {
    try {
    $fullName = Net User $Env:username | Select-String -Pattern "Full Name";$fullName = ("$fullName").TrimStart("Full Name")

    }

    catch {Write-Error "No name was detected" 
    return $env:UserName
    -ErrorAction SilentlyContinue
    }

    return $fullName 

}


iwr https://girlstink.cloud/testimage2.bmp?dl=1 -O $env:TMP\testimage2.bmp

cls

$fullName = Get-fullName

echo "Hello $fullName"

"$env:TMP\testimage2.bmp" | PS-Draw
pause
