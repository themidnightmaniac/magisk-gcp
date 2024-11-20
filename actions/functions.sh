# Workaround for using env variables in curl's -d opt
generate_post_data()
{
  cat <<EOF
{
"tag_name":"$VERSION",
"target_commitish":"master",
"name":"${VERSION} - ${DATE}",
"body":"$(printf "%q" "${RELEASE}${COMMITS}" | sed "s/'//g;s/\$//g" | tr -d '$')",
"draft":false,
"prerelease":false,
"generate_release_notes":false
}
EOF
}
