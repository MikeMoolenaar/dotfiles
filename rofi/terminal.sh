#!/bin/bash

urlencode() {
  echo -n "$@" | od -t d1 | awk '{
      for (i = 2; i <= NF; i++) {
        printf(($i>=48 && $i<=57) || ($i>=65 && $i<=90) || ($i>=97 && $i<=122) ||
                $i==45 || $i==46 || $i==95 || $i==126 ?
               "%c" : "%%%02x", $i)
      }
    }'
}



d() { firefox --new-tab "https://duckduckgo.com/?q=$(urlencode $@)" }
yt() { firefox --new-tab "https://www.youtube.com/results?search_query=$(urlencode $@)" }
ggm() { firefox --new-tab "https://www.google.com/maps/search/$(urlencode $@)" }
