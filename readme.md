# PowerWoL

## Summary
A PowerShell Module providing an interface to send Wake-on-Lan packets to an IPv4/Broadcast address.

## Usage
```PowerShell
Invoke-WoL -IPAddress 1.2.3.4 -MACAddress 00:11:22:33:44:55

# Returns:
IPAddress   : 1.2.3.4
MACAddress  : 00:11:22:33:44:55
PacketCount : 1
SleepTime   : 1
WOLSent     : True
```

### Parameters
- `-IPAddress` - The IP address to send the Wake-On-Lan packet to. *
- `-MACAddress` - The MAC address to send the Wake-On-Lan packet to. *
- `-PacketCount` - The number of packets to send. Default is 1.
- `-SleepTime` - The interval between packets in seconds. Default is 1 second.

\* = Mandatory

## Installation
Clone this repository to your `Modules` folder with directory name: `PowerWoL`

Example:
```PowerShell
cd C:\Users\<username>\Documents\WindowsPowerShell\Modules
git clone https://github.com/Skryptek/PowerWoL
```