#!/bin/bash

### Get the default profile ID
PROFILE=$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d "'")
DIRECTORY_LOCATION="$(pwd)"
cd /tmp

#------------------------#
#-------WALLPAPER--------#
#------------------------#

WALLPAPER="${DIRECTORY_LOCATION}/img/wallpaper.jpg"
echo $WALLPAPER
gsettings set org.gnome.desktop.background picture-uri "$WALLPAPER"
gsettings set org.gnome.desktop.background picture-uri-dark "$WALLPAPER"


#------------------------#
#----------APPS----------#
#------------------------#

# Installing apps
sudo apt update -y
## Install jq to edit .json files
sudo apt install jq -y
## Install Brave
sudo apt install curl -y
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update -y && sudo apt install brave-browser -y
# Set Brave as default Browser
xdg-settings set default-web-browser brave-browser.desktop

## Install keepassxc
sudo apt update -y && sudo apt install keepassxc -y

## Install shutter
sudo apt update -y && sudo apt-get install shutter -y

## Install neofetch
sudo apt install neofetch -y

## Install Obsidian
### GitHub user/repo
REPO="obsidianmd/obsidian-releases"
### GitHub API URL for releases
API_URL="https://api.github.com/repos/$REPO/releases/latest"
### Use curl to fetch the latest release data and jq to parse the .deb download URL
DEB_URL=$(curl -s $API_URL | jq -r '.assets[] | select(.name | endswith("_amd64.deb")) | .browser_download_url')
# Extract the filename from the URL
FILENAME=$(basename "$DEB_URL")
# Download the .deb package
curl -L -o "$FILENAME" "$DEB_URL"
sudo dpkg -i "$FILENAME"

## Install latest version of VScode
wget -O vscode.deb "https://update.code.visualstudio.com/latest/linux-deb-x64/stable"
sudo dpkg -i vscode.deb
sudo apt-get install -f

## Install NordVPN
echo "deb [signed-by=/usr/share/keyrings/nordvpn-archive-keyring.gpg] https://repo.nordvpn.com/deb/nordvpn/debian stable main" | sudo tee /etc/apt/sources.list.d/nordvpn.list
wget -qO - https://repo.nordvpn.com/gpg/nordvpn_public.asc | gpg --dearmor | sudo tee /usr/share/keyrings/nordvpn-archive-keyring.gpg >/dev/null
sudo apt update -y && sudo apt install nordvpn -y

## Install Spotify
curl -sS https://download.spotify.com/debian/pubkey_6224F9941A8AA6D1.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt-get update -y && sudo apt-get install spotify-client -y

## Install Ulauncher
REPO="Ulauncher/Ulauncher"
API_URL="https://api.github.com/repos/$REPO/releases/latest"
DEB_URL=$(curl -s $API_URL | jq -r '.assets[] | select(.name | endswith("_all.deb")) | .browser_download_url')
curl -L -o ulauncher_latest.deb "$DEB_URL"
sudo dpkg -i ulauncher_latest.deb
sudo apt-get install -f -y
sudo apt update -y
### Theme
mkdir -p ~/.config/ulauncher/user-themes
cd ~/.config/ulauncher/user-themes
git clone https://github.com/kalenpw/transparent-adwaita.git

## Install Vim
sudo apt install vim -y

## Install Oh-my-posh
sudo curl -s https://ohmyposh.dev/install.sh | sudo bash -s
### Install a font
oh-my-posh font install Hack ### I like the Hack one
### Install a theme
mkdir ~/oh-my-posh
curl https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/lambda.omp.json -o ~/oh-my-posh/lamda.omp.json ### I like lambda
### Configure it to be run on start
echo "" >> ~/.bashrc
echo 'eval "$(oh-my-posh init bash --config ~/oh-my-posh/lamda.omp.json)"' >> ~/.bashrc
### Change the font
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE/ font 'Hack 12'
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE/ use-system-font false
exec bash

# ## Modify terminal theme
# ### Get all profile IDs
# PROFILE_IDS=$(gsettings get org.gnome.Terminal.ProfilesList list | tr -d "[]',")

# ### Find 'Green on Black' profile
# for ID in $PROFILE_IDS; do
#     NAME=$(gsettings get org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$ID/ visible-name)
#     if [[ "$NAME" == "'Green on Black'" ]]; then
#         gsettings set org.gnome.Terminal.ProfilesList default "$ID"
#         break
#     fi
# done

# We delete all .deb that could left
rm *.deb

## Install locate (Add apps to install before this)
sudo apt install locate -y && sudo updatedb

#------------------------#
#----------DOCK----------#
#------------------------#

# Define your desired applications to add to the dock
## To find the name of the .desktop run:  locate APP | grep .desktop 
apps_to_add=(
    'org.gnome.Terminal.desktop'
    'org.gnome.Nautilus.desktop'
    'spotify.desktop'
    'brave-browser.desktop'
    'org.keepassxc.KeePassXC.desktop'
    'obsidian.desktop'
    'code.desktop'
    'nordvpn.desktop'
)

# Convert the array to a string formatted as GNOME expects
formatted_apps=$(printf "'%s', " "${apps_to_add[@]}")
formatted_apps="[${formatted_apps%, }]"

# Use gsettings to set the new dock list
gsettings set org.gnome.shell favorite-apps "$formatted_apps"

echo "Dock has been updated."

#------------------------#
#-------GNOME APPS-------#
#------------------------#
sudo apt update -y

# To find the UUIDs of the extensions you like, visit its webpage on GNOME official webpage and then go to the Github and search in the metadata.json
array=( Vitals@CoreCoding.com quick-settings-tweaks@qwreey CoverflowAltTab@palatis.blogspot.com user-theme@gnome-shell-extensions.gcampax.github.com )

for i in "${array[@]}"
do
    VERSION_TAG=$(curl -Lfs "https://extensions.gnome.org/extension-query/?search=${i}" | jq '.extensions[0] | .shell_version_map | map(.pk) | max')
    wget -O ${i}.zip "https://extensions.gnome.org/download-extension/${i}.shell-extension.zip?version_tag=$VERSION_TAG"
    gnome-extensions install --force ${EXTENSION_ID}.zip
    if ! gnome-extensions list | grep --quiet ${i}; then
        busctl --user call org.gnome.Shell.Extensions /org/gnome/Shell/Extensions org.gnome.Shell.Extensions InstallRemoteExtension s ${i}
    fi
    gnome-extensions enable ${i}
    rm ${EXTENSION_ID}.zip
done

#------------------------#
#----------THEME---------#
#------------------------#

# GTK theme
sudo apt update -y
sudo apt install git meson sassc libglib2.0-dev-bin libxml2-utils -y
git clone https://github.com/vinceliuice/Orchis-theme.git
cd Orchis-theme
./install.sh
sudo apt update -y && sudo apt install gnome-tweaks -y
gsettings set org.gnome.desktop.interface gtk-theme "Orchis"

# Icon theme
# GitHub API URL for the latest release
cd /tmp
REPO="vinceliuice/Tela-icon-theme"
API_URL="https://api.github.com/repos/${REPO}/releases/latest"
TARBALL_URL="https://github.com/vinceliuice/Tela-icon-theme/archive/refs/tags/2023-06-25.tar.gz"
curl -L -o Tela-icon-theme.tar.gz "$TARBALL_URL"
tar -xvf Tela-icon-theme.tar.gz
cd /tmp/Tela-icon-theme-2023-06-25
./install.sh
cd ..

reboot
