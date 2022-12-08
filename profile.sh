alias sv="foreman start -f Procfile.dev"

# print help
function profile_help {
  echo -e " "
  echo -e "\tShortcuts Available"
  echo -e " "
  cat ./profile.sh | grep alias | egrep -v "profile.sh" | awk '{print $2}' | awk -F= '{ print "\t  \033[1;31m" $1 "\033[0m" }'
  echo -e " "
}

# run print help function
profile_help


export ELASTICSEARCH_URL="https://elastic:Lrag0HDsUlPaQfSIUvnM@localhost:9200"
