-- Copyright 2020 Richard Frankland <rfrankla (at) yahoo .dot com>

module("luci.controller.chrony", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/chrony") then
		return
	end
	
	local page

	page = entry({"admin", "system", "chrony"}, cbi("chrony/chrony"), _("Time NTP setup (Chrony)"), 50)
	page.dependent = true

	page = entry({"admin", "system", "chronyc"}, template("chrony/chronyc"), _("Time monitor (Chrony)"), 51)
	page.dependent = true

	page = entry({"admin", "system", "chronyc_cmd"}, post("chronyc_cmd"), nil)
	page.leaf = true

end

-- Note: the args are plain, because the are so simple, and fixed format.
-- For general use they should be encoded first, then luci.http.urldecode() here.
function chronyc_cmd(args)
	luci.http.prepare_content("text/plain")

	local stdout_h = io.popen("/usr/bin/chronyc %s 2>&1" % args)
	if stdout_h then
		while true do
			local ln = stdout_h:read("*l")
			if not ln then
				break
			end
			luci.http.write(ln)
			luci.http.write("\n")
		end
		stdout_h:close()
	end
	return
end

