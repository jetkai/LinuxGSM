#!/bin/bash
# LinuxGSM check_config.sh module
# Author: Daniel Gibbs
# Contributors: http://linuxgsm.com/contrib
# Website: https://linuxgsm.com
# Description: Checks if the server config is missing and warns the user if needed.

functionselfname="$(basename "$(readlink -f "${BASH_SOURCE[0]}")")"

if [ -n "${servercfgfullpath}" ] && [ ! -f "${servercfgfullpath}" ]; then
	fn_print_dots ""
	fn_print_warn_nl "Configuration file missing!"
	echo -e "${servercfgfullpath}"
	fn_script_log_warn "Configuration file missing!"
	fn_script_log_warn "${servercfgfullpath}"
	install_config.sh
fi

if [ "${shortname}" == "rust" ] && [ -v rconpassword ] && [ -z "${rconpassword}" ]; then
	fn_print_dots ""
	fn_print_fail_nl "RCON password is not set"
	fn_script_log_warn "RCON password is not set"
elif [ -v rconpassword ] && [ "${rconpassword}" == "CHANGE_ME" ]; then
	fn_print_dots ""
	fn_print_warn_nl "Default RCON Password detected"
	fn_script_log_warn "Default RCON Password detected"
fi

if [ "${shortname}" == "vh" ] && [ -z "${serverpassword}" ]; then
	fn_print_fail_nl "serverpassword is not set"
	fn_script_log_fatal "serverpassword is not set"
elif [ "${shortname}" == "vh" ] && [ "${#serverpassword}" -le "4" ]; then
	fn_print_fail_nl "serverpassword is to short (min 5 chars)"
	fn_script_log_fatal "serverpassword is to short (min 5 chars)"
fi

if [ -f /.dockerenv ]; then
	# Symlink config files to make it easier to find them using docker exec
	if [ ! -f "${rootdir}/common.cfg" ]; then
		ln -s "${configdirserver}/common.cfg" "${rootdir}/common.cfg"
	fi
	if [ ! -f "${rootdir}/_default.cfg" ]; then
		ln -s "${configdirserver}/_default.cfg" "${rootdir}/_default.cfg"
	fi	
	# Will symlink config game server config
	if [ ! -f "${rootdir}/${servercfg}" ]; then
		ln -s "${servercfgfullpath}" "${rootdir}/${servercfg}"
	fi
	# Will symlink config game server config with generic name server.cfg
	if [ ! -f "${rootdir}/server.cfg" ]; then
		ln -s "${servercfgfullpath}" "${rootdir}/server.cfg"
	fi
fi
