# heroes

Heroes marvel for collectors only

Infos: https://www.notion.so/plum/Plum-iOS-Test-Task-5088e241ff974fe2863ecbed149337b3

git@github.com:edoardoc/heroes.git

curl --referer developer.marvel.com  http://gateway.marvel.com:80/v1/public/characters?apikey=8c20814552fcd4f513adb7f15c67a39b | jq


curl --referer developer.marvel.com  "http://gateway.marvel.com:80/v1/public/characters?apikey=8c20814552fcd4f513adb7f15c67a39b&limit=5&offset=50" |jq
