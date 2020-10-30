# DELL XPS 15 9570 Elementary OS 5 Hera post installation

### Table of Contents
1. [Post-install script](#post-install-script)
2. [My Installation](#my-installation)
3. [Switching from one graphic card to the other](#how-to-switch-from-one-graphic-card-to-the-other)
4. [Troubleshooting](#troubleshooting)

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
      _Some read for this: https://developers.goodix.com/en/bbs/detail/2cc68cdf9f824e28b247f626c4a9374b & https://github.com/IDerr/Goodix92_

<br>

## Post-install script usage
After install ElementaryOS 5 Hera **whithout install third party software** and setup your network connexion:

1. Download the appropriate and update driver for the chipset: https://www.nvidia.com/Download/index.aspx

2. Download the repos as archive and extract it

3. Move the driver in the archive folder and rename it `NVIDIA-Linux-driver.run`

4. Run the script with sudo and follow the guide.

The script must be executed 3 times:
1. One can be executed in your terminal
2. The other two must be run without your desktop environment being launched.
   To do this, press **CTRL** + **ALT** + **F1** on the login screen, log in and run the script a second time.
3. The third time, simply clean up your system. This is optional but recommended

#### My installation
For my installation, I didn't add universe and proposed;
I didn't install TLP, codec and "high quality studio".
I didn't disable SPECTRE/Meltdown grub patches and I disable fingerprint and touchscreen.

> In the future, I'll note my stack and take note of all tweaks that I apply
- I need to enable system tray : https://eos-techs.com/2020/05/19/howto-enable-system-tray-on-elementary-os/

For now my installation seems to be stable.

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
