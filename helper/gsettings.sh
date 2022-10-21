#!/bin/bash

gsettings set org.mate.Marco.general num-workspaces 6
gsettings set org.mate.Marco.general focus-mode 'mouse'
gsettings set org.mate.Marco.general center-new-windows true
gsettings set org.mate.Marco.general allow-tiling true
gsettings set org.mate.background show-desktop-icons true
gsettings set org.mate.caja.desktop home-icon-visible false
gsettings set org.mate.caja.desktop network-icon-visible false
gsettings set org.mate.caja.desktop trash-icon-visible false
gsettings set org.mate.caja.desktop volumes-visible false
gsettings set org.mate.media-handling automount-open false
gsettings set org.mate.media-handling automount false
gsettings set org.mate.applications-terminal exec 'mate-terminal --hide-menubar'

gsettings set org.mate.SettingsDaemon.plugins.media-keys www '<Mod4>w'
gsettings set org.mate.SettingsDaemon.plugins.media-keys home '<Mod4>f'

gsettings set org.mate.Marco.window-keybindings move-to-workspace-1 '<Shift><Mod4>exclam'
gsettings set org.mate.Marco.window-keybindings move-to-workspace-2 '<Shift><Mod4>quotedbl'
gsettings set org.mate.Marco.window-keybindings move-to-workspace-3 '<Shift><Mod4>section'
gsettings set org.mate.Marco.window-keybindings move-to-workspace-4 '<Shift><Mod4>dollar'
gsettings set org.mate.Marco.window-keybindings move-to-workspace-5 '<Shift><Mod4>percent'
gsettings set org.mate.Marco.window-keybindings move-to-workspace-6 '<Shift><Mod4>ampersand'
gsettings set org.mate.Marco.global-keybindings switch-to-workspace-1 '<Mod4>1'
gsettings set org.mate.Marco.global-keybindings switch-to-workspace-2 '<Mod4>2'
gsettings set org.mate.Marco.global-keybindings switch-to-workspace-3 '<Mod4>3'
gsettings set org.mate.Marco.global-keybindings switch-to-workspace-4 '<Mod4>4'
gsettings set org.mate.Marco.global-keybindings switch-to-workspace-5 '<Mod4>5'
gsettings set org.mate.Marco.global-keybindings switch-to-workspace-6 '<Mod4>6'


# read terminal:
# for i in `dconf list /org/mate/terminal/profiles/default/ `; do echo $i `dconf read /org/mate/terminal/profiles/default/$i` ; done

dconf write /org/mate/terminal/profiles/default/foreground-color "'#FFFFFFFFFFFF'"                                                
dconf write /org/mate/terminal/profiles/default/visible-name "'Default'"
dconf write /org/mate/terminal/profiles/default/palette "'#2E2E34343636:#CCCC00000000:#4E4E9A9A0606:#C4C4A0A00000:#34346565A4A4:#757550507B7B:#060698209A9A:#D3D3D7D7CFCF:#555557575353:#EFEF29292929:#8A8AE2E23434:#FCFCE9E94F4F:#72729F9FCFCF:#ADAD7F7FA8A8:#3434E2E2E2E2:#EEEEEEEEECEC'"
dconf write /org/mate/terminal/profiles/default/default-size-columns 130
dconf write /org/mate/terminal/profiles/default/default-size-rows 32
dconf write /org/mate/terminal/profiles/default/use-system-font "false"
dconf write /org/mate/terminal/profiles/default/background-darkness "0.79069767441860461"
dconf write /org/mate/terminal/profiles/default/use-custom-default-size "true"
dconf write /org/mate/terminal/profiles/default/use-theme-colors "false"
dconf write /org/mate/terminal/profiles/default/font "'Monospace 13'"
dconf write /org/mate/terminal/profiles/default/allow-bold "true"
dconf write /org/mate/terminal/profiles/default/bold-color "'#000000000000'"
dconf write /org/mate/terminal/profiles/default/background-color "'#000000000000'"
dconf write /org/mate/terminal/profiles/default/background-type "'transparent'"

dconf write /org/mate/desktop/keybindings/custom0/action "'dmenu_run'"
dconf write /org/mate/desktop/keybindings/custom0/binding "'<Mod4>e'"
dconf write /org/mate/desktop/keybindings/custom0/name "'Dmenu'"

gsettings set org.mate.interface accessibility false
gsettings set org.mate.Marco.general compositing-manager false

exit 0
