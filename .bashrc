# alias
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias ls='ls --file-type --color=auto'
alias ll="ls -l"

# function
rclone_mount()
{
    rclone mount --daemon --vfs-cache-mode writes $1 $2
}
mount_netdisk()
{
    set_proxy
    rclone_mount dropbox:/ ~/netdisk/dropbox/
    rclone_mount onedrive:/ ~/netdisk/onedrive/
    unset_proxy
}

set_proxy()
{
    export http_proxy=http://127.0.0.1:7890
    export https_proxy=$http_proxy
    export HTTP_PROXY=$http_proxy
    export HTTPS_PROXY=$http_proxy
}
unset_proxy()
{
    export http_proxy=
    export https_proxy=$http_proxy
    export HTTP_PROXY=$http_proxy
    export HTTPS_PROXY=$http_proxy
}
