#-------------------------- ----------------------------------------------------------#
#Date:16/02/2018 IST
#Feature Details: Apache Nutch Crawling-Parsing-Indexing into Elastic Search
#Team: Synerzip IT
#---------------------------------------------------------------------------------------------------#
#!/bin/sh
SECONDS=0
MAINSTART=$(date +%s);
START=$(date +%s);
echo 'Crawling Started..'

for i in 1 2 3 4 
do
nutch inject urls/seeds.txt
nutch generate -topN 10000
END=$(date +%s);
echo '\nCrawling time-'>>/tmp/perform.log
echo $((END-START)) | awk '{print int($1/60)":"int($1%60)}' >>/tmp/perform.log
START=$(date +%s);
echo 'Crawling Successful.Fetching Started...'
echo '\nFetching time-'>>/tmp/perform.log
nutch fetch -all
END=$(date +%s);
echo $((END-START)) | awk '{print int($1/60)":"int($1%60)}' >>/tmp/perform.log
START=$(date +%s);
echo 'Fetch Successful.Parsing data started...'
nutch parse -all
echo 'Parse Successful.Updating database ...'
nutch updatedb -all
echo 'Done'
END=$(date +%s);

done
echo '\nParsing time-'>>/tmp/perform.log
echo $((END-START)) | awk '{print int($1/60)":"int($1%60)}' >>/tmp/perform.log
START=$(date +%s);
nutch index -all

echo '\nTotal time-'>>/tmp/perform.log
END=$(date +%s);
echo $((END-MAINSTART)) | awk '{print int($1/60)":"int($1%60)}' >>/tmp/perform.log

duration=$SECONDS
echo "$(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."
#done
