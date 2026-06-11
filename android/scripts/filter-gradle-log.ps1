param(
    [Parameter(Mandatory = $true)]
    [string]$LogPath
)

Get-Content -LiteralPath $LogPath -Encoding UTF8 | ForEach-Object {
    if ($_.StartsWith('Note:')) {
        return
    }
    $_
}
