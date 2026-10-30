#!/usr/bin/env bash

set -uo pipefail

failed=()
# Load webhook from env file if not already in the environment
if [[ -z "${SLACK_WEBHOOK_URL:-}" ]]; then
	for f in "$HOME/.config/healthcheck/env" /etc/healthcheck/env; do
		[[ -r "$f" ]] && { set -a; source "$f"; set +a; break; }
	done
fi
: "${SLACK_WEBHOOK_URL:?SLACK_WEBHOOK_URL is not set}"

for svc in nginx docker kubelet; do
	systemctl is-active --quiet "$svc" || failed+=("$svc")
done

if (( ${#failed[@]} )); then
	curl -s -X POST -H 'Content-Type: application/json' \
		-d "{\"text\":\":red_circle: $(hostname) : down : ${failed[*]}\"}" "$SLACK_WEBHOOK_URL"
	exit 1
fi



