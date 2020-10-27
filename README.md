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

## Post-install script usage
After install ElementaryOS 5 Hera **whithout install third party software** and setup your network connexion:

1. Download the appropriate and update driver for the chipset: https://www.nvidia.com/Download/index.aspx

2. Download the repos as archive and extract it

3. Copy move the driver in the archive folder

4. Run the script with sudo and follow the guide.

The script must be executed 3 times:
1. One can be executed in your terminal
2. The other two must be run without your desktop environment being launched.
   To do this, press **CTRL** + **ALT** + **F1** on the login screen, log in and run the script a second time.
3. The third time, simply clean up your system. This is optional but recommended

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

You can check the [wiki page](https://github.com/JackHack96/dell-xps-9570-ubuntu-respin/wiki/Troubleshooting) about the original repo.
