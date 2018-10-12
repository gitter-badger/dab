#!/bin/sh
# Description: Run the fetch subcommand on all dependant repos in the group
# Usage: <GROUP_NAME>
# vim: ft=sh ts=4 sw=4 sts=4 noet
set -euf

# shellcheck disable=SC1091
. ./lib/config.sh
# shellcheck disable=SC1091
. ./lib/update.sh
# shellcheck disable=SC1091
. ./lib/dab.sh

[ -n "${1:-}" ] || fatality 'must provide a group name to add too'
group_name="$1"
repos="$(config_get "group/$group_name/repos")"
tools="$(config_get "group/$group_name/tools")"

if [ -z "$repos" ] && [ -z "$tools" ]; then
	fatality "group $group_name does not have any dependencies to update"
fi

for repo in $repos; do
	maybe_selfupdate_repo "$repo"
done

for tool in $tools; do
	dab tools "$tool" update
done