luci-app-chrony
===============

LuCI app for openwrt-chrony
---------------------------

This is a LuCI front-end for the OpenWRT "chrony" package. 
It manages the UCI config file, and will signal the chronyd daemon to  
restart when changes are applied in the router's web user interface. 
Additionally, a few of the CLI commands of the monitor program, chronyc,
are available in a separate view.

This is my first attempt at creating a LuCI interface, and a package, 
hence the 0.9 version. This is beta, until I hear it is not.

Using this source
-----------------
This may be used as a separate feed for building a separate package or  
for a module included in a flash image (...squashfs-sysupgrade.bin)

I may push the package file itself since it is PKGARCH:=all

Making a local feed for your build system
-----------------------------------------
 1. Create new, or use existing, local feed location outside your clone
of the main openwrt build.  
    $ mkdir rfrankla-feed  
    $ cd rfrankla-feed  
 2. Clone this repo into this location  
    $ git clone http://
 3. cd to the location of your openwrt build system. 
    Add this local feed to your build system. Edit feeds.conf and add the line  
  
src-link rfrankla-feed \<full-path-to\>/rfrankla-feed  

or feed directly from this repo
-------------------------------
(this should be possible, not tested).

 3. cd to the location of your openwrt build system.
    Add this remote feed to your build system. Edit feeds.conf and add the line

src-git rfrankla-feeds https://

Activating the Feed into your build system
------------------------------------------
 4. Update and install the feed
./scripts/feeds update rfrankla-feed
./scripts/feeds install -a -p rfrankla-feed

Proceed as normal with building
-------------------------------
 5. open the configuration menu  
 $ make menuconfig  
 LuCI --->  
    3. Applications --->  
        luci-app-chrony ......  
        
for additional help see:  
https://gitlab.com/silverk/luci-app-hello-world  
https://openwrt.org/docs/guide-developer/helloworld/start  




