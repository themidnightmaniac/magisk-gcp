#!/bin/bash

#|==============================================================|
#| Generic GitHub releases tool for magisk modules              |
#| you can change the variables below for your specific usecase |
#| will work out of the box in most cases					    |
#| still needs some tweaking tho							    |
#| NEEDS GITHUB_TOKEN ENV VAR SET WITH ENOUGH PERMISSIONS	    |
#|==============================================================|

# shellcheck source=./env.env
source ./env.env

# shellcheck source=./actions/functions.sh
source ./actions/functions.sh

# Define the required variables and some workarounds
VERSION="$(cat version)"
FILE="magisk-gcp-${VERSION}.zip"
RELEASE="$(cat RELEASE.MD)"
REPO="themidnightmaniac/magisk-gcp"

trap "cleanup "$FILE"" SIGINT SIGTERM EXIT

if [ -f "$FILE" ]; then log "$FILE Already exists! Exiting..." && exit 1; fi

# Create tag for the new release and exit if tag already exists locally
if ! git tag "$VERSION" 2> /dev/null; then
  log "Tag Already Exists! Exiting..." && exit 1;
else
  log "Pushing new tag...";
  for remote in $(git remote); do git push "$remote" master 2> /dev/null; done;
fi

# Add release text to the changelog
log "Adding release info to changelog..."
CHANGELOG="$(printf "%s\n\n" "$RELEASE" && tail -n +3 CHANGELOG.MD)"
echo "$CHANGELOG" > CHANGELOG.MD

# Zip the release
log "Creating zip file..."
zip -r9 "$FILE" ./* -x "*.zip" -x "*.env" -x "actions/*" -x "*.MD" -x ".gitattributes" -x ".gitignore" -x ".git/*" -x "LICENSE" -x "temp/*" 1>/dev/null

# Create the release and capture the response into a variable
log "Creating release on GitHub..."
RESPONSE1="$(curl -L -s \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $GITHUB_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "https://api.github.com/repos/$REPO/releases" \
  --data "$(generate_post_data)")"

# Extract the RELEASE_ID from the JSON response using jq
RELEASE_ID=$(echo "$RESPONSE1" | jq -r '.id')

# Throw an error if no .id is found in the response
if [ -z "$RELEASE_ID" ]; then log "Failed to retrieve release ID. Exiting..."; exit 1; fi;

# Upload asset to GitHub
log "Uploading $FILE to GitHub..."
RESPONSE2="$(curl -L -s \
  -w "%{http_code}" \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $GITHUB_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  -H "Content-Type: application/octet-stream" \
  "https://uploads.github.com/repos/$REPO/releases/$RELEASE_ID/assets?name=$FILE" \
  --data-binary "@${FILE}")"

