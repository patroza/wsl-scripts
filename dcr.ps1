$directory = get-item $PWD
$found = ""
while ($directory.FullName -ne "/") {
    $fn = ($directory.FullName + "/Dockerfile")
    $rc = Get-Item -Force -ErrorAction SilentlyContinue $fn
    if ($rc.Exists) {
        $found = $rc
        break;
    }
    $directory = $directory.Parent
}

if ($found) { 
    $commands=@(docker-compose run $directory.Name)
    $commands+=($args[1..($args.length - 1)]) -join " "
    $theCommand = "cmd.exe /c """ + ($commands -join " && ") + """"
    Write-Host $theCommand
    Invoke-Expression $theCommand
}

