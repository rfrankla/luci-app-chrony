-- Copyright 2020 Richard Frankland <rfrankla (at) yahoo .dot com>

m = Map("chrony", translate("Time Synchronisation (using Chrony)"),
	translate("Synchronizes the system time using NTP protocol, and Chrony software package. see: ")
	.. "https://chrony.tuxfamily.org/" .. "<br />"
	.. translate("consult documentation for the version installed: ")
	.. "https://chrony.tuxfamily.org/documentation.html" .. "<br />"
        .. luci.sys.exec("/usr/sbin/chronyd -v") .. "<br /><br />"
	.. translate("Current system time: ") .. os.date("%c") .. "<br />"
	)

-- makestep --------------------------------------------------------------------------
mstep = m:section(TypedSection, "makestep", translate("Time Stepping (clock adjustment)"),
	translate("chrony.conf directive 'makestep'"))
mstep.anonymous = true
mstep.addremove = false

threshold = mstep:option(Value, "threshold", translate("threshold"), translate("The threshold in seconds above which stepping will occur."))
threshold.datatype = "and(ufloat,min(0.1))"
threshold.optional = false

limit = mstep:option(Value, "limit", translate("limit"), translate("Limit to this number of clock updates when stepping will occur. (-1 is no limit)"))
limit.datatype = "and(integer, or(min(1), '-1'))"

-- allow --------------------------------------------------------------------------
a = m:section(TypedSection, "allow", translate("Allow time queries (listen) on Interfaces"),
        translate("chrony.conf directive 'allow'"))
a.anonymous = true
a.addremove = true

iface = a:option(Value, "interface", translate("Interface"))
iface.anonymous = true
iface.template    = "cbi/network_netlist"
iface.nocreate    = true


-- pool --------------------------------------------------------------------------
p = m:section(TypedSection, "pool", translate("Pool Time servers"),
	translate("chrony.conf directive 'pool'"))
p.anonymous = true
p.addremove = true

pname = p:option(Value, "hostname", translate("Pool Time Server"))
pname.datatype = "host"
pname.anonymous = true
pname.optional = false
pname.placeholder = "1.openwrt.pool.ntp.org"

pminpoll = p:option(Value, "minpoll", translate("minpoll (1-5)"))
pminpoll.datatype = "and(uinteger,min(1))"
-- if the minpoll value is blank the default is 5 -- see later validation of maxpoll
pminpoll.rmempty = true
pminpoll.placeholder = 5

pmaxpoll = p:option(Value, "maxpoll", translate("maxpoll (1-12)"))
pmaxpoll.datatype = "and(uinteger,min(1))"
pmaxpoll.rmempty = true
pmaxpoll.default = 12
pmaxpoll.placeholder = 10
function pmaxpoll.validate(self, value)
	local min = pminpoll.value
	if min == "" then min = 5 else min = tonumber(min) end
	if min == nil then min = 5 else min = tonumber(min) end
	if value == nil then value = 10 else value = tonumber(value) end
	if value < min then 
		return nil, translate("Must be greater than minpoll (default 5)")
	end
	return value
end

piburst = p:option(Flag, "iburst", translate("iburst (yes/no)"))
piburst.enabled = "yes"
piburst.disabled = "no"
piburst.rmempty = false
piburst.default = "yes"

-- server --------------------------------------------------------------------------
h = m:section(TypedSection, "server", translate("Time server hosts"),
	translate("chrony.conf directive 'server'"))
h.anonymous = true
h.addremove = true

hname = h:option(Value, "hostname", translate("Time Server"))
hname.datatype = "host"
hname.anonymous = true
hname.optional = false
hname.placeholder = "1.openwrt.pool.ntp.org"

hminpoll = h:option(Value, "minpoll", translate("minpoll (1-5)"))
hminpoll.datatype = "and(uinteger,min(1))"
-- if the minpoll value is blank the default is 5 -- see later validation of maxpoll
hminpoll.rmempty = true
hminpoll.placeholder = 5

hmaxpoll = h:option(Value, "maxpoll", translate("maxpoll (1-12)"))
hmaxpoll.datatype = "and(uinteger,min(1))"
hmaxpoll.rmempty = true
hmaxpoll.default = 12
hmaxpoll.placeholder = 10
function hmaxpoll.validate(self, value)
	local min = hminpoll.value
	if min == "" then min = 5 else min = tonumber(min) end
	if min == nil then min = 5 else min = tonumber(min) end
	if value == nil then value = 10 else value = tonumber(value) end
	if value < min then 
		return nil, translate("Must be greater than minpoll (default 5)")
	end
	return value
end

hiburst = h:option(Flag, "iburst", translate("iburst (yes/no)"))
hiburst.enabled = "yes"
hiburst.disabled = "no"
hiburst.rmempty = false
hiburst.default = "yes"

-- peer --------------------------------------------------------------------------
e = m:section(TypedSection, "peer", translate("Peer Time Servers"),
	translate("chrony.conf directive 'peer'"))
e.anonymous = true
e.addremove = true

ename = e:option(Value, "hostname", translate("Name or Address Peer Time Server"))
ename.datatype = "host"
ename.anonymous = true
ename.optional = false
ename.placeholder = "server.time.peer.network"

eminpoll = e:option(Value, "minpoll", translate("minpoll (1-5)"))
eminpoll.datatype = "and(uinteger,min(1))"
-- if the minpoll value is blank the default is 5 -- see later validation of maxpoll
eminpoll.rmempty = true
eminpoll.placeholder = 5

emaxpoll = e:option(Value, "maxpoll", translate("maxpoll (1-12)"))
emaxpoll.datatype = "and(uinteger,min(1))"
emaxpoll.rmempty = true
emaxpoll.default = 12
emaxpoll.placeholder = 10
function emaxpoll.validate(self, value)
	local min = eminpoll.value
	if min == "" then min = 5 else min = tonumber(min) end
	if min == nil then min = 5 else min = tonumber(min) end
	if value == nil then value = 10 else value = tonumber(value) end
	if value < min then 
		return nil, translate("Must be greater than minpoll (default 5)")
	end
	return value
end

eiburst = e:option(Flag, "iburst", translate("iburst (yes/no)"))
eiburst.enabled = "yes"
eiburst.disabled = "no"
eiburst.rmempty = false
eiburst.default = "yes"


return m
