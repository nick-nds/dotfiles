#!/bin/sh

curl https://api.quotable.io/random\?tags=inspirational\|science\|technology -H "Accept: application/json" | jq '.content'
