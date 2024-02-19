

Function PS-Draw
{
    param(
            [String] [parameter(mandatory=$true, Valuefrompipeline = $true)] $Path,
            [Switch] $ToASCII
    )
    Begin
    {
        [void] [System.Reflection.Assembly]::LoadWithPartialName('System.drawing')
        
        # Console Colors and their Hexadecimal values
        $Colors = @{
            'FFFFFFFF' =   'White'
            'FF000000' =   'Black'         
            'FF000080' =   'DarkBlue'      
            'FF008000' =   'DarkGreen'     
            'FF008080' =   'DarkCyan'      
            'FF800000' =   'DarkRed'       
            'FF800080' =   'DarkMagenta'   
            'FF808000' =   'DarkYellow'    
            'FFC0C0C0' =   'Gray'          
            'FF808080' =   'DarkGray'      
            'FF0000FF' =   'Blue'          
            'FF00FF00' =   'Green'         
            'FF00FFFF' =   'Cyan'          
            'FFFF0000' =   'Red'           
            'FFFF00FF' =   'Magenta'       
            'FFFFFF00' =   'Yellow'         
                 
        }
        
        # Algorithm to calculate closest Console color (Only 16) to a color of Pixel
        Function Get-ClosestConsoleColor($PixelColor)
        {
            ($(foreach ($item in $Colors.Keys) {
                [pscustomobject]@{
                    'Color' = $Item
                    'Diff'  = [math]::abs([convert]::ToInt32($Item,16) - [convert]::ToInt32($PixelColor,16))
                } 
            }) | Sort-Object Diff)[0].color
        }
    }
    Process
    {
        Foreach($item in $Path)
        {
            #Convert Image to BitMap            
            $BitMap = [System.Drawing.Bitmap]::FromFile((Get-Item $Item).fullname)

            Foreach($y in (1..($BitMap.Height-1)))
            {
                Foreach($x in (1..($BitMap.Width-1)))
                {
                    $Pixel = $BitMap.GetPixel($X,$Y)        
                    $BackGround = $Colors.Item((Get-ClosestConsoleColor $Pixel.name))
                    

                    If($ToASCII) # Condition to check ToASCII switch
                    {
                        Write-Host "$([Char](Get-Random -Maximum 126 -Minimum 33))" -NoNewline -ForegroundColor $BackGround
                    }
                    else
                    {
                        Write-Host " " -NoNewline -BackgroundColor $BackGround
                    }
                }
                Write-Host '' # Blank write-host to Start the next row
            }
        }        
    
    }
    end
    {
    
    }

}

<#

.NOTES 
	This will get either the targets full name associated with the registered microsoft account 
	or it will default to grabbing the username of the account to use as a greeting for this script
#>

 function Get-fullName {

    try {

    $fullName = Net User $Env:username | Select-String -Pattern "Full Name";$fullName = ("$fullName").TrimStart("Full Name")

    }
 
 # If no name is detected function will return $env:UserName 

    # Write Error is just for troubleshooting 
    catch {Write-Error "No name was detected" 
    return $env:UserName
    -ErrorAction SilentlyContinue
    }

    return $fullName 

}

# -------------------------------------------------------------------------------------------
# Download the image from wherever you are hosting it

iwr https://girlstink.cloud/testimage2.bmp?dl=1 -O $env:TMP\testimage2.bmp
# -------------------------------------------------------------------------------------------

# Get name to use in the greeting

cls

$fullName = Get-fullName

echo "Hello $fullName"
# -------------------------------------------------------------------------------------------

<#

.NOTES 
	Then the script will be paused until the mouse is moved 
	script will check mouse position every indicated number of seconds
	This while loop will constantly check if the mouse has been moved 
	"CAPSLOCK" will be continuously pressed to prevent screen from turning off
	it will then sleep for the indicated number of seconds and check again
	when mouse is moved it will break out of the loop and continue the script
#>


Add-Type -AssemblyName System.Windows.Forms
$o=New-Object -ComObject WScript.Shell
$originalPOS = [System.Windows.Forms.Cursor]::Position.X

    while (1) {
        $pauseTime = 3
        if ([Windows.Forms.Cursor]::Position.X -ne $originalPOS){
            break
        }
        else {
            $o.SendKeys("{CAPSLOCK}");Start-Sleep -Seconds $pauseTime
        }
    }


<#

.NOTES 
	This is where you call the function to draw out your image
	Replace the path below with the path of your image 

.SYNTAX 
	"$env:TMP\testimage2.bmp" | PS-Draw
	PS-Draw -Path "$env:TMP\testimage2.bmp"
#>

# -------------------------------------------------------------------------------------------

# Call the function with the image you'd like to have drawn here

"$env:TMP\testimage2.bmp" | PS-Draw
pause
