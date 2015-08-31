#! /usr/bin/env bash
set -e

GETVRS=$(curl -s https://golang.org/doc/devel/release.html | grep 'Build version' | awk '{ print $3 }' | grep -o "[0-9.]...")

while getopts 'v:b::dph' OPT; do
  case $OPT in
    v)  VERSION=$OPTARG;;
    b)  BIT=$OPTARG;;
    d)  VERSION=$GETVRS;;
    p)  PURGE=true;;
    h)  hlp="yes";;
    *)  hlp="yes";;
  esac
done

# usage
HELP="
    usage: $0 [ -v version -b 32/64 -d -p -h ]
        -v --> Particular Go version < ex. 0.4.2
        -b --> Bit Version of Go < 32 or 64(default)
        -d --> Latest Stable Go version
        -p --> Deletes Go in its entirety from your system
        -h --> print this help screen
"

if [ "$hlp" = "yes" ]; then
  echo "$HELP"
  exit 0
fi

if [ -z "$VERSION" ] && [ -z "$PURGE" ] ; then
  echo "Please either choose a go version with '-v' or pass the '-d' flag for the default latest version"
  echo "$HELP"
  exit 1
fi

if [ "$PURGE" = true ] ; then
  read -r -p "Are you sure you want to delete go? This will delete EVERYTHING![y/N] " yn
  case $yn in
        [Yy]* ) rm -rf "$HOME/.go/"
                rm -rf "$HOME/go/"
                if [ "$SHELL" = "/bin/bash" ] ; then
                  sed -i '' '/# GoLang/d' "$HOME/.bashrc"
                  sed -i '' '/export GOROOT/d' "$HOME/.bashrc"
                  sed -i '' '/:$GOROOT/d' "$HOME/.bashrc"
                  sed -i '' '/export GOPATH/d' "$HOME/.bashrc"
                  sed -i '' '/:$GOPATH/d' "$HOME/.bashrc"
                  echo "Go purged!"
                elif [ "$SHELL" = "/bin/zsh" ] ; then
                  sed -i '' '/# GoLang/d' "$HOME/.zshrc"
                  sed -i '' '/export GOROOT/d' "$HOME/.zshrc"
                  sed -i '' '/:$GOROOT/d' "$HOME/.zshrc"
                  sed -i '' '/export GOPATH/d' "$HOME/.zshrc"
                  sed -i '' '/:$GOPATH/d' "$HOME/.zshrc"
                  echo "Go purged!"
                fi
                exit 0;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
  exit
fi

if [ "$BIT" = '64' ] ; then
    if [ -z "$VERSION" ] ; then
    VERSION=$GETVRS
    fi
    BINARY="go$VERSION.darwin-amd$BIT-osx10.8.tar.gz"
elif [ "$BIT" = '32' ] ; then
    if [ -z "$VERSION" ] ; then
    VERSION=$GETVRS
    fi
    BINARY="go$VERSION.darwin-386-osx10.8.tar.gz"
elif [ -z "$BIT" ] ; then
    if [ -z "$VERSION" ] ; then
    VERSION=$GETVRS
    fi
    BIT='64'
    BINARY="go$VERSION.darwin-amd$BIT-osx10.8.tar.gz"
else
  echo 'Not a valid bit version. Please select 32,64 or nothing at all.Exiting.'
  exit 1
fi

LINK="https://storage.googleapis.com/golang/$BINARY"
TMP="/tmp"
GOGOGO="$HOME/.go/go-$VERSION-$BIT"

function goswitch {

if [ "$SHELL" = "/bin/bash" ] ; then
  if cat $HOME/.bashrc | grep "GOROOT" > /dev/null ; then
    OLD=$(cat $HOME/.bashrc | grep "GOROOT" | grep -o "[0-9.][0-9.][0-9.]..")
    sed -i '' "s@GOROOT=$HOME/.go/go-$OLD-$BIT@GOROOT=$GOGOGO@g" $HOME/.bashrc
    echo "Type 'source ~/.bashrc' to start using go$VERSION"
  fi
elif [ "$SHELL" = "/bin/zsh" ]; then
  if cat $HOME/.zshrc | grep "GOROOT" > /dev/null ; then
    OLD=$(cat $HOME/.zshrc | grep "GOROOT" | grep -o "[0-9.][0-9.][0-9.]..")
    sed -i '' "s@GOROOT=$HOME/.go/go-$OLD-$BIT@GOROOT=$GOGOGO@g" $HOME/.zshrc
    echo "Type 'source ~/.zshrc' to start using go$VERSION"
  fi
elif [ "$SHELL" != "/bin/bash" ] || [ "$SHELL" != "/bin/zsh" ] ; then
    echo "Not a valid shell. Use bash or zsh"
    exit 1
fi
}

function goshell {

if [ "$SHELL" = "/bin/bash" ] ; then
  if ! cat $HOME/.bashrc | grep "GOROOT" > /dev/null ; then
    {
    echo '# GoLang'
    echo "export GOROOT=$GOGOGO"
    echo 'export PATH=$PATH:$GOROOT/bin'
    echo 'export GOPATH=$HOME/go'
    echo 'export PATH=$PATH:$GOPATH/bin'
    } >> "$HOME/.bashrc"
    echo "Type 'source ~/.bashrc' to start using go$VERSION"
    exit 0
  fi
elif [ "$SHELL" = "/bin/zsh" ]; then
  if ! cat $HOME/.zshrc | grep "GOROOT" > /dev/null ; then
 {
    echo '# GoLang'
    echo "export GOROOT=$GOGOGO"
    echo 'export PATH=$PATH:$GOROOT/bin'
    echo 'export GOPATH=$HOME/go'
    echo 'export PATH=$PATH:$GOPATH/bin'
    } >> "$HOME/.zshrc"
    echo "Type 'source ~/.zshrc' to start using go$VERSION"
    exit 0
  fi
elif [ "$SHELL" != "/bin/bash" ] || [ "$SHELL" != "/bin/zsh" ] ; then
    echo "Not a valid shell. Use bash or zsh"
    exit 1
fi
}

if go version 2> /dev/null | grep "go$VERSION linux/amd$BIT" > /dev/null ; then
  echo "Go version $VERSION-$BIT already installed."
  goshell
  goswitch
  exit 0
elif ls $HOME/.go 2> /dev/null | grep "go-$VERSION-$BIT" > /dev/null ; then
  echo "Switching Go to version $VERSION-$BIT"
  goshell
  goswitch
  exit 0
fi

cd $TMP
echo "Downloading $LINK"
curl -O $LINK
if [ $? -ne 0 ]; then
    echo "Download failed! Are you sure you are using a valid version? Exiting..."
    exit 1
fi
tar -C $HOME -xzf $TMP/$BINARY
rm -rf $TMP/$BINARY
mkdir -p $HOME/.go
mv $HOME/go $GOGOGO
mkdir -p $HOME/go
echo "Go version $VERSION installed!"
goshell
goswitch
