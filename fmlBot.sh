#!/bin/bash

match=0;

while [ $match -gt -1 ]; do

        i=`curl http://www.fmylife.com/intimacy?page=$match` > /dev/null 2>&1

        fml=`   echo $i                                                         |
                sed 's/<div class=\"post article\"/\n/g'                        |
                sed 's/<\/div>/\n/g'                                            |
                grep -o -E "class=\"fmllink\">.*class=\"fmllink\"> FML<\/a>"    |
                sed 's/class=\"fmllink\">//g'                                   |
                sed 's/<\/a><a href=\"\/intimacy\/.\{8\}\"//g'                  |
                sed 's/\&quot\;/\"/g'                                           |
                sed 's/<\/a>//g'                                                |
                sed 's/  / /g'`

        counter=0;
        while [ $counter -lt 10 ]; do

                tempFml=`echo -e "$fml" | sort --random-sort | head -n 1`;
                search=`cat fmlStore.dat | grep "$tempFml"`;

                if [ -z "$search" ]; then
                        echo $tempFml >> fmlStore.dat;
                        counter=20;
                        match=-1;
			`curl -X POST -H 'Content-type: application/json' --data '{"username": "FMLBot", "icon_url": "http://cdn6.fmylife.com/fmylife/images/logo200.en.jpg", "text":"'"$tempFml"'"}' https://hooks.slack.com/services/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`
                else
                        counter=$((counter+1));
                fi
        done

        if [ $match -gt -1 ]; then
                match=$((match+1));
        fi
done
