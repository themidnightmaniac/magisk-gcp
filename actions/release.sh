#!/bin/bash

. ./env.env
. ./actions/functions.sh

mkdir temp

# Define the required variables and some workarounds
VERSION="$(cat version)"
FILE="temp/magisk-gcp-${VERSION}.zip"
FILENAME="$(basename $FILE)"
RELEASE="$(cat RELEASE.MD)"
DATE="$(date +'%Y-%m-%d')"
COMMITS="$(printf "\n\n%s" "**Commits**: https://github.com/themidnightmaniac/magisk-gcp/commits/${VERSION}")"

# Exit if tag already exists locally
if [ "$(git tag "$VERSION")" ]; then printf "Tag Already Exists! Exiting...\n" && exit 1;
else
  printf "Pushing new tag...\n";
	for remote in $(git remote); do git push "$remote" master; done;
fi

# Add release text to the changelog
printf "Adding release info to changelog...\n"
CHANGELOG="$(printf "%s\n\n" "$RELEASE" && tail -n +3 CHANGELOG.MD)"
echo "$CHANGELOG" > CHANGELOG.MD

# Zip the release
printf "Creating zip file...\n"
zip -r9 "$FILE" ./* -x "*.zip" -x "*.env" -x "actions/*" -x "*.MD" -x ".gitattributes" -x ".gitignore" -x ".git/*" -x "LICENSE" 1>/dev/null

# Create the release and capture the response into a variable
RESPONSE1="$(curl -L -s \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $GITHUB_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "https://api.github.com/repos/themidnightmaniac/test/releases" \
  --data "$(generate_post_data)")"

# Extract the RELEASE_ID from the JSON response using jq
RELEASE_ID=$(echo "$RESPONSE1" | jq -r '.id')

# Throw an error if no .id is found in the response
if [ -z "$RELEASE_ID" ]; then printf "Failed to retrieve release ID. Exiting...\n"; exit 1; fi;

# TODO: Check if uploading the release zip was a success
RESPONSE2="$(curl -L \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $GITHUB_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  -H "Content-Type: application/octet-stream" \
  "https://uploads.github.com/repos/themidnightmaniac/test/releases/$RELEASE_ID/assets?name=$FILENAME" \
  --data-binary "@${FILE}")"

# Clean up
printf "Cleaning up...\n"
rm -rf "temp"

