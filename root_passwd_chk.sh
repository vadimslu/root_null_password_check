#!/bin/bash
###This bash script will scan all the local images for null password CVE-2019-5021####
echo "All following images will be scanned now"
#docker_img=$(docker images --format "table {{.ID}}")
#  echo $docker_img
for container in `docker images --format "table {{.ID}}"`; do
         image_id=$(docker create $container)
         docker cp $image_id:/etc/shadow -> /tmp/tmpshadow
         echo "this $container is checked"
         passwd_check=$(cat /tmp/tmpshadow)
            if [[ $passwd_check = *"root:::0:::::"* ]]
               then
                   echo "failure"
                   echo "This $container is effected" >> /tmp/null_passwd.txt
               else
                   echo "no nill password is detected in this $container"
          fi
         docker rm $image_id
done
