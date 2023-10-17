$ModuleName = 'PowerWoL'
$ModuleManifestName = "$ModuleName.psd1"
$ModuleManifestPath = "$PSScriptRoot\..\$ModuleManifestName"

Remove-Module PowerWOL -Force -ErrorAction SilentlyContinue

Import-Module $ModuleManifestPath -Force

Describe 'Module Manifest Tests' {
    It 'Passes Test-ModuleManifest' {
        Test-ModuleManifest -Path $ModuleManifestPath | Should Not BeNullOrEmpty
        $? | Should Be $true
    }
}

Describe 'Parameter Validation Tests' {
    It 'Returns an error if the IP Address is not valid' {
        try{
            Invoke-WoL -IPAddress "2.4.5." -MACAddress "00:11:22:33:44:55"
        } catch {
            $_.FullyQualifiedErrorId | Should Be 'ParameterArgumentValidationError,Invoke-WoL'
        }
    }
    It 'Returns an error if the MAC Address is not valid' {
        try {
            Invoke-WoL -IPAddress "2.4.5.6" -MACAddress "00:11:22:33:44-5"
        }
        catch {
            $_.FullyQualifiedErrorId | Should Be 'ParameterArgumentValidationError,Invoke-WoL'
        }
    }
}

Describe 'Pipeline Tests' {
    It 'Returns multiple objects when fed an object array' {
        $array = New-Object System.Collections.Generic.List[Object]
        $array.Add([pscustomobject]@{IPAddress = "127.0.0.1"; MACAddress = "00:11:22:33:44:55" })
        $array.Add([pscustomobject]@{IPAddress = "127.0.0.2"; MACAddress = "00:11:22:33:44:56" })
        $results = $array | Invoke-WoL
        $results.Count | Should Be 2
        $? | Should Be $true
    }
}

<#
    Possibly write a test that creates a UDP client and reads the WoL packets generated to the local IP and MAC Address
#>