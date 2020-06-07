#
# Copyright (C) 2020 Richard Frankland <rfrankla (at) yahoo .dot com>
#

include $(TOPDIR)/rules.mk

LUCI_TITLE:=Chrony (NTP) time synchronisation configuration module
LUCI_DEPENDS:=+chrony

# PKG_NAME is taken from the directory name "luci-app-????"
PKG_VERSION:=0.9.0
PKG_RELEASE:=1
MAINTAINER:=Richard Frankland <rfrankla (at) yahoo .dot com>

# this is a temporary fix until the file installed from main chrony package is updated with service_triggers
define Package/luci-app-chrony/postinst
#!/bin/sh
# check the chronyd init script has the function service_triggers()
if [ -f /etc/init.d/chronyd ]
then
	# only add the service_trigger function if it does not exist
	if !(grep -q "^service_triggers()" /etc/init.d/chronyd)
	then
		cat <<EOF >>/etc/init.d/chronyd

service_triggers()
{
        procd_add_reload_trigger "chrony"
}
EOF
		# and restart chronyd if active
		!(ps | grep -v grep | grep -q chronyd) || /etc/init.d/chronyd restart
	fi
fi
endef

#include ../../luci.mk
# the standard location from the top
include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature
