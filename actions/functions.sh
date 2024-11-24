#!/bin/bash
# Workaround for using env variables in curl's -d opt
generate_post_data()
{
  # All commits for the given tag
  COMMITS="$(printf "\n\n%s" "**Commits**: https://github.com/themidnightmaniac/magisk-gcp/commits/${VERSION}")"
  cat <<EOF
{
"tag_name":"$VERSION",
"target_commitish":"master",
"name":"${VERSION} - $(date +'%Y-%m-%d')",
"body":"$(printf "%q" "${RELEASE}${COMMITS}" | sed "s/'//g;s/\$//g" | tr -d '$')",
"draft":false,
"prerelease":false,
"generate_release_notes":false
}
EOF
}
cleanup()
{
  log "Cleaning up...";
  for item in "$@"; do
    if [ -f "$item" ]; then rm -rf "$item"; log "Removed $item!";
    else log "$item Not found!"; fi
  done;
  log "Done!";
  exit 0;
}
log()
{
  printf "%s - %s\n" "$(date +"%H:%M:%S")" "$1";
}
