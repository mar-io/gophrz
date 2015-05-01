#gophrz

gophrz is a simple bash script that will install and manage the [**Go programming language**](https://golang.org) on your linux system.

The script supports bash and zsh.

You can install different go versions and manage them in your shell.
You can switch between different go versions.
You can completely uninstall/purge go from your system.

By default, the script will find the latest version of 64-bit Go and install to your system.

##How to Use gophrz

Download gophrz bash script:  

[**gophrz script**](https://raw.githubusercontent.com/badmadrad/gophrz/master/gophrz.sh)  

or  

`wget https://raw.githubusercontent.com/badmadrad/gophrz/master/gophrz.sh`

Make script executeable:  

`chmod 700 gophrz.sh` 

To see script usage and help information:

`./gophrz.sh -h`

To install LATEST go version (64-bit default):

`./gophrz.sh`

To install a different version (64-bit default):

`./gophrz.sh -v 1.3.1`

To install 32 bit (will install LATEST):

`./gophrz.sh -b 32`

To install different version and 32 bit:

`./gophrz.sh -v 1.3.1 -b 32`

To purge go from your system:

`./gophrz.sh -p`

##Switching Go Versions

To switch versions simply specify the version you want to switch to:
`./gophrz.sh -v 1.4.1`

gophrz will install the specified version if its not on your system. However, if you have already installed that version in the past it simply will switch to it by changing GOROOT on your system.

**You may have to log out and back into the shell for changes to take effect.**

## Environment Variables

All your Go versions are saved here: `$HOME/.go`

gophrz will set `$GOROOT` to the version you specify. 

gophrz will set your go workspace or  `$GOPATH` to `$HOME/go`

## Basic Usage

     usage: $0 [ -v version -b 32/64 -d -p -h ]
        -n --> Particular Go version < ex. 0.4.2
        -b --> Bit Version of Go < 32 or 64(default)
        -d --> Latest Stable Go version
        -p --> Deletes Go in its entirety from your system
        -h --> print this help screen

## Issues

Any weird issues or concerns please let me know in the project issues.

## License

[See License](https://github.com/badmadrad/gophrz/blob/master/LICENSE)
