#!/bin/bash
dir=mydirectory
cek=$(sed -n '7p' ${dir})
url="https://myurl"

status_code=$(curl --referer "https://myreferer" --write-out %{http_code} --silent --output /dev/null ${cek})

echo "$dir" | grep -oP '(?<=reverse/)[^<]*'| sed 's/\(^\|$\)/*****/g'
if [[ "$status_code" -ne 200 ]] || [ -z "$url" ] ; then
  echo "Site status changed to $status_code"  
  echo -e "generate new playlist........"
  source=$(curl -s --referer "https://myreferer/"  "${url}" | grep -oP '(?<=sourceUrl: )[^,<]*' | sed "s/'//g")
    sleep 1
    echo "NEW URL....."
    echo -e ${source}
    old=$(sed -n '/EXT-X-STREAM-INF/{n;p;}'  ${dir})
    sleep 1
    echo "Last Url Code $status_code"
    echo -e ${old}
    sleep 2
    echo -e 'write to m3u'
    sed -i "7s|^.*$||" ${dir}
    sleep 2
    sed -i "7s|^.*|${source//&/\\&}|" ${dir}
    echo -e 'OK'  
else
  echo "Playlist Active"
  exit 0
fi
