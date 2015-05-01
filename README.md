#goShell

goShell is simple a bash script that will install go on your linux system.

The script supports bash and zsh.

You can install different go versions and manage them in your shell.
You can switch between different go versions.
You can completely uninstall/purge go from your system.

By default, the script will find the latest version of 64-bit Go and install to your system.

##How to Use goShell

Download goShell bash script:

`wget [goShell](https://raw.githubusercontent.com/badmadrad/goShell/master/goShell.sh)`

To see script usage and help information:

`./goShell.sh -h`

To install LATEST go version (64-bit default):

`./goShell.sh`

To install a different version (64-bit default):
`./goShell.sh -v 1.3.1`

To install 32 bit (will install LATEST):
`./goShell.sh -b 32`

To install different version and 32 bit:
`./goShell.sh -v 1.3.1 -b 32`

To purge go from your system:
`./goShell.sh -p`

##Switching Go Versions

To switch versions simply specify the version you want to switch to:
`./goShell.sh -v 1.4.1`

goShell will install the specified version if its not on your system. However, if you have already installed that version in the past it simply will switch to it by changing GOROOT on your system.

**You may have to log out and back into the shell for changes to take effect.**

## Basic Usage

     usage: $0 [ -v version -b 32/64 -d -p -h ]
        -n --> Particular Go version < ex. 0.4.2
        -b --> Bit Version of Go < 32 or 64(default)
        -d --> Latest Stable Go version
        -p --> Deletes Go in its entirety from your system
        -h --> print this help screen

## Issues

Any weird issues or concerns please let me know in the project issues.

