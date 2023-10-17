function Invoke-WoL {
    [CmdletBinding()]
    param (
        # IP Address of the device to wake (can be broadcast address)
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateScript(
            {
                if (-not ($_ -match "^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$")) {
                    throw [System.Management.Automation.ValidationMetadataException] "IP Address is not valid"
                }
                else {
                    return $true
                }
            }
        )]
        [string]
        $IPAddress
        ,
        # MAC Address of the device to wake
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateScript(
            {
                switch ((($_ | Select-String "([\w\d]{2})" -AllMatches).matches.value).count -eq 6) {
                    $false {
                        throw [System.Management.Automation.ValidationMetadataException] "MAC Address is not valid"
                    }
                    Default { $true }
                }
            }
        )]
        [string]
        $MACAddress
        ,
        # Sleep time in seconds
        [Parameter(Mandatory = $false)]
        [int]
        $SleepTime = 1
        ,
        # Number of packets to send
        [Parameter(Mandatory = $false)]
        [int]
        $PacketCount = 1
    )
    process {
        $MacByteArray = ($MACAddress | Select-String "([\w\d]{2})" -AllMatches).matches.value | ForEach-Object { [Byte] "0x$_" }
        [Byte[]] $MagicPacket = (, 0xFF * 6) + ($MacByteArray * 16)
        $UdpClient = New-Object System.Net.Sockets.UdpClient
        [void]$UdpClient.Connect(($IPAddress), 7)
        for ($i = 0; $i -lt $PacketCount; $i++) {
            Write-Verbose "Sending WoL packet $($i + 1) of $PacketCount"
            [void]$UdpClient.Send($MagicPacket, $MagicPacket.Length)
            if ($PacketCount -gt 1) {
                Start-Sleep -Seconds $SleepTime
            }
        }
        [PSCustomObject]@{
            IPAddress = $IPAddress
            MACAddress = $MACAddress
            PacketCount = $PacketCount
            SleepTime = $SleepTime
            WOLSent = $true
        }
        $UdpClient.Close()
    }
}