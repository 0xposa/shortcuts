<#
.SYNOPSIS
    Installed Tools & Shortcuts Detector for Windows PowerShell
.DESCRIPTION
    Grouped strictly by each installed application and package (not generic categories).
#>

[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [string]$Query = "",
    [switch]$All
)

if ($Query -in @("-h", "--help", "/?")) {
    Write-Host ""
    Write-Host "⚡ Installed Tools & Shortcuts Detector (Windows PowerShell)" -ForegroundColor Cyan
    Write-Host "Usage:" -ForegroundColor DarkGray
    Write-Host "  .\shortcuts.ps1             List shortcuts grouped by installed app/tool" -ForegroundColor Green
    Write-Host "  .\shortcuts.ps1 <query>     Filter by tool name or command (e.g. .\shortcuts.ps1 git)" -ForegroundColor Green
    Write-Host "  .\shortcuts.ps1 -All        Show all raw tools and packages" -ForegroundColor Green
    Write-Host "  .\shortcuts.ps1 -h, --help  Show this help message" -ForegroundColor Green
    Write-Host ""
    exit
}

Clear-Host
Write-Host ""
Write-Host "╭──────────────────────────────────────────────────────────────╮" -ForegroundColor Cyan
Write-Host "│  ⚡ INSTALLED TOOLS & SHORTCUTS                              │" -ForegroundColor White
Write-Host "│  Grouped by each installed tool & package                    │" -ForegroundColor DarkGray
Write-Host "╰──────────────────────────────────────────────────────────────╯" -ForegroundColor Cyan

$psVer = $PSVersionTable.PSVersion.ToString()
Write-Host "  Platform : Windows PowerShell ($psVer)  | User : $env:USERNAME" -ForegroundColor Green
if ($Query) {
    Write-Host "  Filter   : '$Query' (case-insensitive search)" -ForegroundColor Yellow
}
Write-Host ""

$totalTools = 0
$totalShortcuts = 0

function Render-ToolGroup ($title, $commands) {
    $matched = @()
    foreach ($item in $commands) {
        $parts = $item -split '\|'
        $cmd = $parts[0]
        $alias = $parts[1]
        $desc = $parts[2]

        if ($Query) {
            if ($title -notlike "*$Query*" -and $cmd -notlike "*$Query*" -and $alias -notlike "*$Query*" -and $desc -notlike "*$Query*") {
                continue
            }
        }
        $matched += [PSCustomObject]@{
            Cmd = $cmd
            Alias = $alias
            Desc = $desc
        }
    }

    if ($matched.Count -eq 0) { return }

    Write-Host "📦 $title" -ForegroundColor Blue
    Write-Host "────────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
    foreach ($m in $matched) {
        $aliasStr = if ($m.Alias) { "($($m.Alias))" } else { "" }
        Write-Host ("  {0,-16} {1,-20} {2}" -f $m.Cmd, $aliasStr, $m.Desc) -ForegroundColor Green
        $script:totalShortcuts++
    }
    Write-Host ""
    $script:totalTools++
}

# Example Groups for Windows Tools
Render-ToolGroup "Git Version Control" @(
    "git||Distributed version control CLI",
    "git-bash||Git Bash terminal launcher"
)

Render-ToolGroup "Node.js & Package Managers" @(
    "node||Node.js JavaScript runtime",
    "npm|npx|Node Package Manager & runner"
)

Render-ToolGroup "Python & Virtual Environments" @(
    "python|py|Python interpreter",
    "pip||Python package manager"
)

# Custom PowerShell User Aliases
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
            Write-Host ("  {0,-16} → {1}" -f $a.Name, $a.Definition) -ForegroundColor Magenta
            $totalShortcuts++
        }
        Write-Host ""
    }
}

Write-Host "────────────────────────────────────────────────────────────────" -ForegroundColor Cyan
if ($Query) {
    Write-Host ("  📊 SUMMARY : Found {0} shortcuts matching '{1}'" -f $totalShortcuts, $Query) -ForegroundColor White
} else {
    Write-Host ("  📊 SUMMARY : {0} Installed Tools & Custom Aliases ({1} total shortcuts)" -f $totalTools, $totalShortcuts) -ForegroundColor White
}
Write-Host "────────────────────────────────────────────────────────────────" -ForegroundColor Cyan
Write-Host ""
