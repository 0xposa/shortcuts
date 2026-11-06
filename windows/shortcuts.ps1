<#
.SYNOPSIS
    Dynamic Installed Tools & Shortcuts Detector for Windows PowerShell
.DESCRIPTION
    Pure dynamic detection and clustering (zero hardcoding).
    Groups tools by dedicated directory, executable prefix, and symlink targets.
#>

[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [string]$Query = "",
    [switch]$All
)

if ($Query -in @("-h", "--help", "/?")) {
    Write-Host ""
    Write-Host "⚡ Dynamic Installed Tools & Shortcuts Detector (Windows PowerShell)" -ForegroundColor Cyan
    Write-Host "Usage:" -ForegroundColor DarkGray
    Write-Host "  .\shortcuts.ps1             Auto-detect & group shortcuts by installed application" -ForegroundColor Green
    Write-Host "  .\shortcuts.ps1 <query>     Filter by tool name or command (e.g. .\shortcuts.ps1 git)" -ForegroundColor Green
    Write-Host "  .\shortcuts.ps1 -All        Show all raw tools and packages" -ForegroundColor Green
    Write-Host "  .\shortcuts.ps1 -h, --help  Show this help message" -ForegroundColor Green
    Write-Host ""
    exit
}

Clear-Host
Write-Host ""
Write-Host "╭──────────────────────────────────────────────────────────────╮" -ForegroundColor Cyan
Write-Host "│  ⚡ DYNAMIC INSTALLED TOOLS & SHORTCUTS                      │" -ForegroundColor White
Write-Host "│  Auto-detected & grouped by installed application            │" -ForegroundColor DarkGray
Write-Host "╰──────────────────────────────────────────────────────────────╯" -ForegroundColor Cyan

$psVer = $PSVersionTable.PSVersion.ToString()
Write-Host "  Platform : Windows PowerShell ($psVer)  | User : $env:USERNAME" -ForegroundColor Green
if ($Query) {
    Write-Host "  Filter   : '$Query' (case-insensitive search)" -ForegroundColor Yellow
}
Write-Host ""

$totalPackages = 0
$totalShortcuts = 0

function Test-Noise ($name) {
    if ($All) { return $false }
    $noiseList = @(
        'fastapi','idna','uvicorn','playwright','pip','pip3','wheel','easy_install','setuptools',
        'pytest','mypy','black','flake8','agentapi','webm_encoder','shortcuts'
    )
    return ($noiseList -contains $name.ToLower())
}

# 1. Discover Custom Directories
$sysPaths = @(
    "C:\Windows",
    "C:\Windows\System32",
    "C:\Windows\SysWOW64",
    "C:\Windows\System32\Wbem",
    "C:\Windows\System32\WindowsPowerShell\v1.0"
)

$pathList = ($env:PATH -split ';') | Where-Object { $_ -and (Test-Path $_) } | ForEach-Object { $_.TrimEnd('\') } | Select-Object -Unique
$userPaths = $pathList | Where-Object {
    $p = $_
    -not ($sysPaths -contains $p -or $p -like "C:\Windows\*")
}

$extraDirs = @(
    "$HOME\bin",
    "$HOME\.local\bin",
    "$HOME\Scripts",
    "$env:ProgramData\chocolatey\bin",
    "$HOME\.cargo\bin",
    "$HOME\.bun\bin",
    "$HOME\.deno\bin"
) | Where-Object { (Test-Path $_) }

$scanDirs = @($userPaths) + @($extraDirs) | Select-Object -Unique

# 2. Collect All Executables
$commands = @()
foreach ($dir in $scanDirs) {
    $files = Get-ChildItem -Path $dir -File -ErrorAction SilentlyContinue | Where-Object {
        $_.Extension -in @(".bat", ".cmd", ".ps1", ".exe") -and -not (Test-Noise $_.BaseName)
    }

    foreach ($f in $files) {
        $parent = (Split-Path (Split-Path $dir -Parent) -Leaf).TrimStart('.')
        $target = if ($f.LinkType) { (Split-Path $f.Target -Leaf) } else { $f.Name }

        $commands += [PSCustomObject]@{
            Name   = $f.Name
            Base   = $f.BaseName
            Target = $target
            Dir    = $dir
            Parent = $parent
            Ext    = $f.Extension
        }
    }
}

# 3. Dynamic Grouping
$groups = @{}
foreach ($c in $commands) {
    $group = ""
    # Check dedicated parent directory
    if ($c.Parent -and $c.Parent -notin @("Users", "AppData", "Local", "Roaming", "bin", "Program Files")) {
        $group = $c.Parent
    } else {
        # Prefix clustering
        $prefix = ($c.Base -split '[-_]')[0]
        $targetPrefix = ($c.Target -split '[-_]')[0]

        if ($prefix -ne $c.Base -and $prefix.Length -ge 3) {
            $group = $prefix
        } elseif ($c.Target -ne $c.Name) {
            $group = ($c.Target -split '\.')[0]
        } else {
            $group = $c.Base
        }
    }

    if (-not $groups.ContainsKey($group)) {
        $groups[$group] = @()
    }
    $groups[$group] += $c
}

# 4. Render Dynamic Groups
foreach ($g in ($groups.Keys | Sort-Object)) {
    $cmds = $groups[$g]
    $matched = @()
    foreach ($c in $cmds) {
        if ($Query) {
            if ($g -like "*$Query*" -or $c.Name -like "*$Query*" -or $c.Target -like "*$Query*") {
                $matched += $c
            }
        } else {
            $matched += $c
        }
    }

    if ($matched.Count -eq 0) { continue }

    Write-Host "📦 $g" -ForegroundColor Blue
    Write-Host "────────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
    foreach ($m in $matched) {
        if ($m.Target -ne $m.Name) {
            Write-Host ("  {0,-18} → {1,-18} [symlink]" -f $m.Name, $m.Target) -ForegroundColor Green
        } else {
            Write-Host ("  {0,-18} [{1}]" -f $m.Name, $m.Ext.TrimStart('.')) -ForegroundColor Green
        }
        $totalShortcuts++
    }
    Write-Host ""
    $totalPackages++
}

# 5. Custom PowerShell User Aliases
$builtinAliases = @(
    'cat','cd','chdir','clc','clear','clhy','cli','clp','cls','clv','cns','compare',
    'copy','cp','cpi','cpp','cvpa','del','diff','dir','ebp','echo','epal','epcsv',
    'epsn','erase','etsn','exsn','fc','fhx','fl','foreach','ft','fw','gal','gbp',
    'gc','gci','gcm','gcs','gdr','gerr','ghy','gi','gin','gjb','gl','gm','gmo',
    'gp','gps','gpv','group','gsn','gsv','gu','gv','gwmi','h','history','icm',
    'iex','ihy','ii','ipal','ipcsv','ipsn','irm','ise','iwmi','iwr','kill','lp',
    'ls','man','md','measure','mi','mount','move','mp','mv','nal','ndr','ni','nmo',
    'nsn','nv','ogv','oh','popd','ps','pushd','pwd','r','rbp','rccsv','rdr','ren',
    'ri','rjb','rm','rmdir','rmo','rni','rnp','rp','rsn','rv','rvpa','rwmi','sajb',
    'sal','saps','sasv','sbp','sc','select','set','shcm','si','sl','sleep','sls',
    'sort','sp','spjb','spps','spsv','start','sujb','sv','swmi','tee','trcm','type',
    'wjb','write'
)

$userAliases = Get-Alias -ErrorAction SilentlyContinue | Where-Object {
    $_.Name -notin $builtinAliases -and $_.Source -ne "Microsoft.PowerShell.Core" -and $_.Options -ne "AllScope, ReadOnly"
}

if ($userAliases) {
    $aliasMatched = @()
    foreach ($a in ($userAliases | Sort-Object Name)) {
        if ($Query) {
            if ($a.Name -notlike "*$Query*" -and $a.Definition -notlike "*$Query*") { continue }
        }
        $aliasMatched += $a
    }

    if ($aliasMatched.Count -gt 0) {
        Write-Host "🔗 Custom PowerShell Aliases" -ForegroundColor Blue
        Write-Host "────────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
        foreach ($a in $aliasMatched) {
            Write-Host ("  {0,-18} → {1}" -f $a.Name, $a.Definition) -ForegroundColor Magenta
            $totalShortcuts++
        }
        Write-Host ""
    }
}

Write-Host "────────────────────────────────────────────────────────────────" -ForegroundColor Cyan
if ($Query) {
    Write-Host ("  📊 SUMMARY : Found {0} shortcuts matching '{1}'" -f $totalShortcuts, $Query) -ForegroundColor White
} else {
    Write-Host ("  📊 SUMMARY : {0} Tool Packages & Custom Aliases ({1} total shortcuts)" -f $totalPackages, $totalShortcuts) -ForegroundColor White
}
Write-Host "────────────────────────────────────────────────────────────────" -ForegroundColor Cyan
Write-Host ""
