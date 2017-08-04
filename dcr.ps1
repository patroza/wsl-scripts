$directory = get-item $PWD
$found = ""
while ($directory) {
    $fn = ($directory.FullName + "/Dockerfile")
    $rc = Get-Item -Force -ErrorAction SilentlyContinue $fn
    if ($rc.Exists) {
        $found = $rc
        break;
    }
    $directory = $directory.Parent
}

if ($found) {
    $command=@("docker-compose run", $directory.Name) + $args -join " "
    Invoke-Expression $command
}
