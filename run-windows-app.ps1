$command = $args[0]
$commands=@()
#$commands+= @("clean_chcp")
$directory = get-item $PWD
$found = ""
$windowsFound = ""

while ($directory.FullName -ne "/") {
    $fn = ($directory.FullName + "/.envrc")
    $rc = Get-Item -Force -ErrorAction SilentlyContinue $fn
    if ($rc.Exists) {
        $found = $rc
        $foundDir = $found.Directory.FullName
        $env = Get-Content -Force $found
        $batFile = $foundDir + "/.env.bat"
        $regex = '/mnt/(\w)/'
        $batContent = @("@echo off") + $env.Replace("export", "set").Replace("# ", "REM ")
        $batContent = ($batContent | Foreach {$_ -replace $regex,'$1:/'}).Replace("/", "\")
        Set-Content $batFile $batContent
        $windowsBatFile = $windowsFound + ".env.bat"
        $commands+=$windowsBatFile
    }
    $directory = $directory.Parent
    $windowsFound = $windowsFound + "..\"
}

$commands+=(@($command + ".exe") + $args[1..($args.length - 1)]) -join " "

$theCommand = "cmd.exe /c """ + ($commands -join " && ") + """"

Invoke-Expression $theCommand
