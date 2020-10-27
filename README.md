# DELL XPS 15 9570 Elementary OS 5 Hera post installation script

### Table of Contents
1. [Post-install script](#post-install-script)
2. [Switching from one graphic card to the other](#how-to-switch-from-one-graphic-card-to-the-other)
3. [Troubleshooting](#troubleshooting)

---

All informations, tips and tricks was gathered from:

- [tomwwright gist for DELL XPS 15 9560](https://gist.github.com/tomwwright/f88e2ddb344cf99f299935e1312da880)
- [Atheros wifi card fix](https://ubuntuforums.org/showthread.php?t=2323812&page=2)
- [Respin script and info](http://linuxiumcomau.blogspot.com/)
- [JackHack96's original repo](https://github.com/JackHack96/dell-xps-9570-ubuntu-respin)
- [My gist tutorial to install proprietary NVIDIA Drivers](https://gist.github.com/MrZyr0/43f059fbbdcfff7c9757bf919d00f8fe)
- And some of my search

Kudos and all the credits for things not related to my work go to developers and users on those pages!

### What works out-of-the-box
 - ✅ Atheros Wifi
 - ✅ Audio
 - ✅ Audio on HDMI
 - ✅ HDMI ( even on lid closed )
 - ✅ Nvidia/Intel graphic cards switch
 - ✅ Keyboard backlight
 - ✅ Display brightness
 - ✅ Sleep/wake on Intel
 - ✅ Sleep/wake on nVidia
 - ✅ Thunderbolt

### What doesn't work
 - ❌ Goodix Fingerprint sensor (no driver)

<br>

## Post-install script
After install ElementaryOS 5 Hera **whithout install third party software** and setup your network connexion, execute the shell script of the repo.

You can [download it](https://raw.githubusercontent.com/MrZyr0/DELL-XPS-9570-Elementary-Hera/master/post-install-script.sh) and save it on your USB installer key or use it directly with this command, thanks to `curl`:
```bash
sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/MrZyr0/DELL-XPS-9570-Elementary-Hera/master/post-install-script.sh)"
```

If you want touchpad gestures using X11, check https://github.com/bulletmark/libinput-gestures or better https://github.com/iberianpig/fusuma.

## How to switch from one graphic card to the other
Because the Nvidia driver doesn't work perfectly, I recommend you to disable it when you don't need it. It will also save a little bit of battery.
The post-installer add a small script to do it easilly.
Just run one of these command:

**Intel**:
```bash
sudo prime-select intel
```

**Nvidia**:
```bash
sudo prime-select nvidia
```

**Note: A full reboot could be required when switching graphic cards.**

## Troubleshooting

YOu can check the [wiki page](https://github.com/JackHack96/dell-xps-9570-ubuntu-respin/wiki/Troubleshooting) about the original repo.
