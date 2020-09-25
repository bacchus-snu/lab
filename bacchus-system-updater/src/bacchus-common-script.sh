#!/bin/bash

function load_config() {
	local config_file="${1}"

	if [ -r "${config_file}" ]; then
		if is_config_secure "${config_file}"; then
			source "${config_file}"
		else
			die "Refused to source config file. Please set owner to root and mode to 600"
		fi
	else
		die "Config file does not exist"
	fi
}

function is_config_secure() {
	local config_file="${1}"
	local owner=$(stat --format '%u' "${config_file}") || die "Getting config file information failed"
	local mode=$(stat --format '%a' "${config_file}") || die "Getting config file information failed"
	
	if [ "${#mode}" -eq "3" ]; then
		local group_flags="${mode:1:1}"
		local other_flags="${mode:2:1}"
		
		if [ "${owner}" -eq "0" ] && [ "${group_flags}" -eq "0" ] && [ "${other_flags}" -eq "0" ]; then
			return 0
		else
			return 1
		fi
	else
		die "Parsing config file mode failed: ${mode}"
	fi
}

function error() {
        echo "$@" 1>&2
}

function die() {
        error "$@"
        exit 1
}
