# Utility functions

# Man page colors
man() {
   env \
      LESS_TERMCAP_mb=$(printf "\e[1;31m") \
      LESS_TERMCAP_md=$(printf "\e[1;31m") \
      LESS_TERMCAP_me=$(printf "\e[0m") \
      LESS_TERMCAP_se=$(printf "\e[0m") \
      LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
      LESS_TERMCAP_ue=$(printf "\e[0m") \
      LESS_TERMCAP_us=$(printf "\e[1;32m") \
         man "$@"
}

# Compress a file or directory
function compress() {
    if [[ -e $1 ]]; then
        if [ $2 ]; then
            case $2 in
                tgz | tar.gz)   tar -zcvf$1.$2 $1                  ;;
                tbz2 | tar.bz2) tar -jcvf$1.$2 $1                  ;;
                tar.Z)          tar -Zcvf$1.$2 $1                  ;;
                tar)            tar -cvf$1.$2  $1                  ;;
                zip)            zip -r $1.$2   $1                  ;;
                gz | gzip)      gzip           $1                  ;;
                bz2 | bzip2)    bzip2          $1                  ;;
                gpg)            gpg -e --default-recipient-self $1 ;;
                *)
                echo "Error: $2 is not a valid compression type"
                ;;
            esac
        else
            compress $1 tar.gz
        fi
    else
        echo "File ('$1') does not exist!"
    fi
}

# View archive without unpacking
show-archive() {
    if [[ -f $1 ]]; then
        case $1 in
            *.tar.gz)      gunzip -c $1 | tar -tf - -- ;;
            *.tar)         tar -tf $1 ;;
            *.tgz)         tar -ztf $1 ;;
            *.zip)         unzip -l $1 ;;
            *.bz2)         bzless $1 ;;
            *)             echo "'$1' Error. Please go away" ;;
        esac
    else
        echo "'$1' is not a valid archive"
    fi
}

# Extract archive
function extract() {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xvjf $1     ;;
            *.tar.gz)    tar xvzf $1     ;;
            *.bz2)       bunzip2 $1      ;;
            *.rar)       unrar x $1      ;;
            *.gz)        gunzip $1       ;;
            *.tar)       tar xvf $1      ;;
            *.tbz2)      tar xvjf $1     ;;
            *.tgz)       tar xvzf $1     ;;
            *.zip)       unzip $1        ;;
            *.Z)         uncompress $1   ;;
            *.7z)        7z x $1         ;;
            *)           echo "'$1' cannot be extracted via >extract<" ;;
        esac
    else
        echo "'$1' is not a valid file!"
    fi
}

# Find files by name
function ff() { 
    find . -type f -iname '*'"$*"'*' -ls ; 
}
