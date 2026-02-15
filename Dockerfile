# Utiliser Ubuntu 20.04 comme base (correspond au projet Ubuntu Web original)
FROM ubuntu:20.04

# Éviter les invites interactives pendant l'installation
ENV DEBIAN_FRONTEND=noninteractive

# Installer les dépendances système, le bureau et les outils
RUN apt-get update && apt-get install -y \
    xfce4 xfce4-goodies \
    wget curl ca-certificates git sudo \
    mtools xorriso squashfs-tools make \
    neofetch plank \
    # Dépendances pour KasmVNC
    libvncserver1 libjpeg-turbo8 xauth x11-xkb-utils \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Installer KasmVNC (Version Pro stable pour Ubuntu 20.04)
RUN wget https://github.com/kasmtech/KasmVNC/releases/download/v1.3.1/kasmvncserver_focal_1.3.1_amd64.deb -O /tmp/kasmvnc.deb && \
    apt-get update && apt-get install -y /tmp/kasmvnc.deb && \
    rm /tmp/kasmvnc.deb

# Installer les thèmes Premium (WhiteSur & Papirus)
RUN git clone https://github.com/vinceliuice/WhiteSur-gtk-theme.git /tmp/whitesur && \
    /tmp/whitesur/install.sh -d /usr/share/themes && \
    rm -rf /tmp/whitesur && \
    apt-get update && apt-get install -y papirus-icon-theme

# Configurer l'utilisateur principal avec sudo sans mot de passe
RUN useradd -m -s /bin/bash ubuntuweb && \
    echo "ubuntuweb:ubuntu" | chpasswd && \
    adduser ubuntuweb sudo && \
    echo "ubuntuweb ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Copier les scripts
COPY setup_branding.sh /usr/local/bin/setup_branding.sh
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/setup_branding.sh /usr/local/bin/entrypoint.sh
RUN /usr/local/bin/setup_branding.sh

# Configurer l'environnement de travail
WORKDIR /home/ubuntuweb/iso-builder
RUN chown ubuntuweb:ubuntuweb /home/ubuntuweb/iso-builder

# Port KasmVNC (Web GUI par défaut sur 8443, mais on peut le mapper)
EXPOSE 6901

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
