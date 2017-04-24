# ensure sources.list is identical on all platforms

rm -f /etc/apt/sources.list

cat <<EOF >> /etc/apt/sources.list
deb http://http.debian.net/debian jessie main
deb-src http://http.debian.net/debian jessie main
deb http://security.debian.org/ jessie/updates main
deb-src http://security.debian.org/ jessie/updates main
deb http://http.debian.net/debian jessie-updates main
deb-src http://http.debian.net/debian jessie-updates main
EOF
