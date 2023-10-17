# Implement your module commands in this script.

. .\public\Invoke-WoL.ps1

# Export only the functions using PowerShell standard verb-noun naming.
# Be sure to list each exported functions in the FunctionsToExport field of the module manifest file.
# This improves performance of command discovery in PowerShell.
# Export-ModuleMember -Function *-*
Export-ModuleMember -Function Invoke-WoL
