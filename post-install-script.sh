#!/bin/bash

# Define colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\e[96m'
INVERT='\e[7m'
NC='\033[0m\e[0m' # Reset style

release=$(lsb_release -c -s)

# Check OS
if [ "$release" != "hera" ]
then
    >&2 echo -e "${RED}This script is made for Elementary OS 5 (Hera) !${NC}"
    exit 1
fi

# Check if the script is running as root
if [ "$EUID" -ne 0 ]
then
    >&2 echo -e "${RED}Please run the script with sudo !${NC}"
    exit 2
fi


echo "You need to restart before install nvidia's properitary driver."
read -p "Which run start ? (1 - 2 or 3) => " RUN

if [ $RUN = '1' ]
then
    echo -e "\n${INVERT}[STEP 1] - Update system${NC}"
    sudo cp *.bin /lib/firmware/i915/
    sudo apt update -y
    sudo apt full-upgrade -y


    echo -e "\n${INVERT}[STEP 2] - Add universe and proposed${NC}"
    echo -e "\n${BLUE}Do you wish to add universe ? ?${NC}"
    select yn in "Yes" "No"; do
        case $yn in
            Yes ) sudo apt install software-properties-common -y
                  sudo add-apt-repository universe -y
                  sudo apt full-upgrade -y; break;;
            No ) break;;
        esac
    done


    echo -e "\n${INVERT}[STEP 3] - Install power management tools${NC}"
    sudo apt install thermald -y
    echo -e "\n${BLUE}Do you wish to install TLP ? ?${NC}"
    select yn in "Yes" "No"; do
        case $yn in
            Yes ) sudo add-apt-repository -y ppa:linrunner/tlp
                  sudo apt update -y
                  sudo apt install tlp -y
                  sudo sed -i '/RESTORE_DEVICE_STATE_ON_STARTUP/s/=.*/=1/' /etc/tlp.conf
                  sudo systemctl restart tlp
                  echo -e "\n${BLUE}Do you wish to install a GUI for TLP ?${NC}"
                  select yn in "Yes" "No"; do
                      case $yn in
                          Yes ) sudo add-apt-repository -y ppa:linuxuprising/apps
                                sudo apt update -y
                                sudo apt install tlpui -y; break;;
                          No ) break;;
                      esac
                  done; break;;
            No ) break;;
        esac
    done


    echo -e "\n${INVERT}[STEP 4] - Remove nvidia drivers${NC}"
    sudo nvidia-uninstall
    sudo apt remove --purge nvidia* -y
    sudo apt remove --purge libnvidia* -y
    sudo apt autoremove --purge -y
    sudo apt autoclean -y
    sudo rm -Rf /var/cache/app-info


    echo -e "\n${INVERT}[STEP 5] - Blacklist drivers${NC}"
    if [ -f "/etc/modprobe.d/blacklist-nvidia-nouveau.conf" ]
    then
        sudo rm /etc/modprobe.d/blacklist-nvidia-nouveau.conf
    fi
    sudo bash -c "echo blacklist vga16fb >> /etc/modprobe.d/blacklist-nvidia-nouveau.conf"
    sudo bash -c "echo blacklist rivafb >> /etc/modprobe.d/blacklist-nvidia-nouveau.conf"
    sudo bash -c "echo blacklist rivatv >> /etc/modprobe.d/blacklist-nvidia-nouveau.conf"
    sudo bash -c "echo blacklist nvidiafb >> /etc/modprobe.d/blacklist-nvidia-nouveau.conf"
    sudo bash -c "echo blacklist nouveau >> /etc/modprobe.d/blacklist-nvidia-nouveau.conf"
    sudo bash -c "echo blacklist lbm-nouveau >> /etc/modprobe.d/blacklist-nvidia-nouveau.conf"
    sudo bash -c "echo options nouveau modeset=0 >> /etc/modprobe.d/blacklist-nvidia-nouveau.conf"
    sudo bash -c "echo alias nouveau off >> /etc/modprobe.d/blacklist-nvidia-nouveau.conf"
    sudo bash -c "echo alias lbm-nouveau off >> /etc/modprobe.d/blacklist-nvidia-nouveau.conf"


    echo -e "\n${INVERT}[STEP 6] - Disable Nouveau Kernel${NC}"
    sudo bash -c "echo options nouveau modeset=0 | sudo tee -a /etc/modprobe.d/nouveau-kms.conf"
    sudo update-initramfs -u


    echo -e "\n${INVERT}[STEP 7] - Restart${NC}"
    echo -e "${GREEN}Restart the computer and run the script again on RUN 2 from prompt of login screen.${NC}"
    echo "(Press CTRL + ALT + F1 before login)"
fi



if [ $RUN = '2' ]
then
    echo -e "\n${INVERT}[STEP 1] - Stop lightdm${NC}"
    sudo service lightdm stop


    echo -e "\n${INVERT}[STEP 2] - Enter in runlevel 3${NC}"
    sudo init 3


    echo -e "\n${INVERT}[STEP 4] - Install required dependencies${NC}"
    sudo apt install pkg-config libglvnd-core-dev libglvnd-dev libglvnd0 dkms fakeroot build-essential linux-headers-generic -y


    echo -e "\n${INVERT}[STEP 4] - Run Nvidia's script${NC}"
    sudo chmod +x NVIDIA-Linux-driver.run
    sudo ./NVIDIA-Linux-driver.run --dkms
    sudo apt install nvidia-prime

    # Create simple script for launching programs on the NVIDIA GPU
    sudo echo '__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME="nvidia" __VK_LAYER_NV_optimus="NVIDIA_only" exec "$@"' >> /usr/local/bin/prime
    sudo chmod +x /usr/local/bin/prime

    # Create xorg.conf.d directory (If it doesn't already exist) and copy PRIME configuration file
    sudo mkdir -p /etc/X11/xorg.conf.d/
    sudo wget https://raw.githubusercontent.com/MrZyr0/dell-xps-9570-ubuntu-respin/master/10-prime-offload.conf -O /etc/X11/xorg.conf.d/10-prime-offload.conf

    # Enable modesetting on the NVIDIA Driver (Enables use of offloading and PRIME Sync)
    sudo echo "options nvidia-drm modeset=1" >> /etc/modprobe.d/nvidia-drm.conf


    echo -e "\n${INVERT}[MISC]${NC}"

    # Install codecs
    echo -e "${BLUE}Do you wish to install video codecs for encoding and playing videos?${NC}"
    select yn in "Yes" "No"; do
        case $yn in
            Yes ) sudo apt -y install ubuntu-restricted-extras va-driver-all vainfo libva2 gstreamer1.0-libav gstreamer1.0-vaapi; break;;
            No ) break;;
        esac
    done

    # Enable high quality audio
    echo -e "${BLUE}Do you wish to enable high quality audio? (may impact battery life)${NC}"
    select yn in "Yes" "No"; do
        case $yn in
            Yes ) sudo echo "# This file is part of PulseAudio.
#
# PulseAudio is free software; you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# PulseAudio is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with PulseAudio; if not, see <http://www.gnu.org/licenses/>.
## Configuration file for the PulseAudio daemon. See pulse-daemon.conf(5) for
## more information. Default values are commented out.  Use either ; or # for
## commenting.
daemonize = no
; fail = yes
; allow-module-loading = yes
; allow-exit = yes
; use-pid-file = yes
; system-instance = no
; local-server-type = user
; enable-shm = yes
; enable-memfd = yes
; shm-size-bytes = 0 # setting this 0 will use the system-default, usually 64 MiB
; lock-memory = no
; cpu-limit = no
high-priority = yes
nice-level = -11
realtime-scheduling = yes
realtime-priority = 9
; exit-idle-time = 20
; scache-idle-time = 20
; dl-search-path = (depends on architecture)
; load-default-script-file = yes
; default-script-file = /etc/pulse/default.pa
; log-target = auto
; log-level = notice
; log-meta = no
; log-time = no
; log-backtrace = 0
resample-method = soxr-vhq
avoid-resampling = true
; enable-remixing = yes
; remixing-use-all-sink-channels = yes
enable-lfe-remixing = no
; lfe-crossover-freq = 0
flat-volumes = no
; rlimit-fsize = -1
; rlimit-data = -1
; rlimit-stack = -1
; rlimit-core = -1
; rlimit-as = -1
; rlimit-rss = -1
; rlimit-nproc = -1
; rlimit-nofile = 256
; rlimit-memlock = -1
; rlimit-locks = -1
; rlimit-sigpending = -1
; rlimit-msgqueue = -1
; rlimit-nice = 31
rlimit-rtprio = 9
; rlimit-rttime = 200000
default-sample-format = float32le
default-sample-rate = 48000
alternate-sample-rate = 44100
default-sample-channels = 2
default-channel-map = front-left,front-right
default-fragments = 2
default-fragment-size-msec = 125
; enable-deferred-volume = yes
deferred-volume-safety-margin-usec = 1
; deferred-volume-extra-delay-usec = 0" > /etc/pulse/daemon.conf
    sudo add-apt-repository ppa:eh5/pulseaudio-a2dp
    sudo apt-get update
    sudo apt-get install libavcodec58 libldac pulseaudio-modules-bt; break;;
            No ) break;;
        esac
    done

    # Intel microcode
    sudo apt -y install intel-microcode iucode-tool

    # Enable power saving tweaks for Intel chip
    if [[ $(uname -r) == *"4.15"* ]]; then
        sudo echo "options i915 enable_fbc=1 enable_guc_loading=1 enable_guc_submission=1 disable_power_well=0 fastboot=1" > /etc/modprobe.d/i915.conf
    else
        sudo echo "options i915 enable_fbc=1 enable_guc=3 disable_power_well=0 fastboot=1" > /etc/modprobe.d/i915.conf
    fi

    # Let users check fan speed with lm-sensors
    sudo echo "options dell-smm-hwmon restricted=0 force=1" > /etc/modprobe.d/dell-smm-hwmon.conf
    if < /etc/modules grep "dell-smm-hwmon" &>/dev/null; then
        sudo echo "dell-smm-hwmon is already in /etc/modules!"
    else
        sudo echo "dell-smm-hwmon" >> /etc/modules
    fi
    sudo update-initramfs -u

    # Tweak grub defaults
    GRUB_OPTIONS_VAR_NAME="GRUB_CMDLINE_LINUX_DEFAULT"
    GRUB_OPTIONS="quiet splash acpi_rev_override=1 acpi_osi=Linux nouveau.modeset=0 pcie_aspm=force drm.vblankoffdelay=1 scsi_mod.use_blk_mq=1 nouveau.runpm=0 mem_sleep_default=deep nvidia-drm.modeset=1"
    echo -e "${BLUE}Do you wish to disable SPECTRE/Meltdown patches for performance?${NC}"
    select yn in "Yes" "No"; do
        case $yn in
            Yes )
                if [[ $(uname -r) == *"4.15"* ]]; then
                    GRUB_OPTIONS+="noibrs noibpb nopti nospectre_v2 nospectre_v1 l1tf=off nospec_store_bypass_disable no_stf_barrier mds=off mitigations=off"
                else
                    GRUB_OPTIONS+="mitigations=off"
                fi
                break;;
            No ) break;;
        esac
    done
    GRUB_OPTIONS_VAR="$GRUB_OPTIONS_VAR_NAME=\"$GRUB_OPTIONS\""

    if < /etc/default/grub grep "$GRUB_OPTIONS_VAR" &>/dev/null; then
        echo -e "${GREEN}Grub is already tweaked!${NC}"
    else
        sudo sed -i "s/^$GRUB_OPTIONS_VAR_NAME=.*/$GRUB_OPTIONS_VAR_NAME=\"$GRUB_OPTIONS\"/g" /etc/default/grub
        sudo update-grub
    fi

    # Ask for disabling fingerprint reader
    echo -e "${BLUE}Do you wish to disable the fingerprint reader to save power (no linux driver is available for this device)?${NC}"
    select yn in "Yes" "No"; do
        case $yn in
            Yes ) sudo echo "# Disable fingerprint reader
            SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"27c6\", ATTRS{idProduct}==\"5395\", ATTR{authorized}=\"0\"" > /etc/udev/rules.d/fingerprint.rules; break;;
            No ) break;;
        esac
    done


    # Ask for disabling touchscreen
    echo -e "${BLUE}Do you wish to disable the touchscreen to save power ?${NC}"
    select yn in "Yes" "No"; do
        case $yn in
            Yes ) sudo echo "# Disable touchscreen
blacklist wacom" > /etc/modprobe.d/hid_multitouch.conf; break;;
            No ) break;;
        esac
    done
    # Create simple script to manage it easily
    sudo echo '#!/bin/bash
# Define colors
RED="\033[0;31m"
GREEN="\033[0;32m"
BLUE="\e[96m"
INVERT="\e[7m"
NC="\033[0m\e[0m" # No Color

# Check if the script is running as root
if [ "$EUID" -ne 0 ]
then
>&2 echo -e "${RED}Please run the script as root !${NC}"
exit 2
fi
if [ -f "/etc/modprobe.d/hid_multitouch.conf" ]
then
sudo rm /etc/modprobe.d/hid_multitouch.conf
echo "${RED}Touchscreen disabled.${NC}"
echo "Reboot the computer"
else
sudo echo "# Disable touchscreen
blacklist hid_multitouch" > /etc/modprobe.d/hid_multitouch.conf
echo -e "${GREEN}Touchscreen disabled.${NC}"
echo "Reboot the computer"
fi' >> /usr/local/bin/touchscreen-toggler

    sudo chmod +x /usr/local/bin/touchscreen-toggler

    echo "touchscreen-toggler script installed. Run it to turn on/off the touchscreen when you need it."

    echo -e "${GREEN}DONE !${NC}"
    echo -e "${RED}Now reboot the computer. If DE didn't show up, press CTRL + ALT + F7.${NC}"
fi



if [ $RUN = "3" ]
then
    echo -e "\n${INVERT}FINAL - Cleaning${NC}"
    sudo apt update -y
    sudo apt full-upgrade -y
    sudo apt autoremove --purge -y
    sudo apt autoclean -y
    sudo prime-select intel
    echo -e "${GREEN}Reboot your computer and that's it :)${NC}"
fi
