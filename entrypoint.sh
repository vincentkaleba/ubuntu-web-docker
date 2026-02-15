#!/bin/bash
export USER=ubuntuweb
export HOME=/home/ubuntuweb

# Initialisation du dossier .vnc pour KasmVNC
mkdir -p $HOME/.vnc
echo "ubuntu" | kasmvncpasswd -u ubuntuweb -o $HOME/.vnc/kasmvnc.yaml

# Configuration de l'apparence XFCE (Premium Look) au premier démarrage
if [ ! -f $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml ]; then
    mkdir -p $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/
    # Appliquer le thème WhiteSur et les icônes Papirus
    xfconf-query -c xsettings -p /Net/ThemeName -s "WhiteSur-Light" --create -t string
    xfconf-query -c xsettings -p /Net/IconThemeName -s "Papirus" --create -t string
    # Supprimer le panel du bas pour utiliser Plank à la place
    xfconf-query -c xfce4-panel -p /panels/panel-1/autohide-behavior -s 1 --create -t int
fi

# Lancer Plank (le Dock) en arrière-plan
plank &

# Démarrer KasmVNC (Interface Web moderne sur le port 6901)
# --disable-ssl pour faciliter le test dans Codespaces/Local
/usr/bin/vncserver :1 -select-product kasm -httpd /usr/share/kasmvnc/www -disable-ssl -ProxyPort 6901 -interface 0.0.0.0

tail -f /dev/null
