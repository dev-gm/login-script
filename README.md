# login-script
A simple login script that I wrote in bash. Uses a file in your home called `.loginmanrc` as config.
I wrote this after getting tired of trying to get 'ly' to work on Gentoo with openrc and sway/wayland.

NOTE: The following probably won't work for most people, and is probably not best practice. But, TBH it is mostly just so I don't forget.

## How to use
Replace my username in the script's 'username' var with yours.

Download the script and copy it to `/usr/local/bin/login-loginmanrc`. Run `chmod +x /usr/local/bin/login-loginmanrc`

Replace the third line under "TERMINALS" in /etc/inittab with this:

`c2:2345:respawn:/sbin/agetty --skip-login --login-program /usr/local/bin/login-loginmanrc 38400 tty2 linux`

Add a `.loginmanrc` file in your home that sources `.bash_profile`, cd's into your home, run window manager, etc.

### For swaywm users (such as myself)
Add this to your `.bash_profile`, which you should source from your `.loginmanrc` file:

```
if test -z "${XDG_RUNTIME_DIR}"; then
    export XDG_RUNTIME_DIR=/tmp/${UID}-runtime-dir
    if ! test -d "${XDG_RUNTIME_DIR}"; then
        mkdir "${XDG_RUNTIME_DIR}"
        chmod 0700 "${XDG_RUNTIME_DIR}"
    fi
fi
```

And then add this to your `.loginmanrc` file, at the end:

`usr/bin/dbus-run-session /usr/bin/sway`
