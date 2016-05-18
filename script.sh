#!/bin/bash
while getopts :u:h:d:n: option
do
        case "${option}"
                in
                        u) URL=${OPTARG};;
			d) DIR=${OPTARG};;
                        h) echo "-u for URL, -d for directory, -n for uploader and id (formatted uploader{uploaderid}"
                                exit 1;;
			n) uploaderandid=${OPTARG};;
                        \?) echo "that's not a flag, you dope. Maybe try -h"
                                exit 1;;

        esac
done
if [[ $URL == "" || $DIR == "" ]] ;
        then
                echo "You need to input a URL and a directory to which to download, numbnuts."
                exit 1
        else
echo "You entered: $URL for the URL"
		if [[ $uploaderandid == "" ]] ;
        then
		uploader="$(youtube-dl -i -J $URL --playlist-items 1 | grep -Po '(?<="uploader": ")[^"]*')"
		uploader_id="$(youtube-dl -i -J $URL --playlist-items 1 | grep -Po '(?<="uploader_id": ")[^"]*')"
		uploaderandid="$uploader{$uploader_id}"
		echo "Uploader: $uploader"
		echo "Uploader ID: $uploader_id"
		echo "Folder Name: $uploaderandid"
        else
		echo "Folder Name: $uploaderandid"
fi
echo "Now downloading all videos from URL "$URL" to the folder "$DIR/$uploaderandid""
cd $DIR && cd "$uploaderandid" || mkdir -p $DIR && cd $DIR && mkdir -p "$uploaderandid" && cd "$uploaderandid"
youtube-dl -iw \
--no-continue $URL \
-f bestvideo+bestaudio --merge-output-format mkv \
-o "[%(upload_date)s] %(title)s" --prefer-ffmpeg --recode-video mp4 \
--add-metadata --download-archive archive.txt \
--postprocessor-args "-c:v libx264 -crf 18 -preset medium -strict experimental -c:a aac -movflags +faststart -loglevel 32"
fi
exit 0
