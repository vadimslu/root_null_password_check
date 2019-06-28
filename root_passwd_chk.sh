#!/bin/bash
###This bash script will scan all the local images for null password CVE-2019-5021####
echo "All following images will be scanned now"
docker_img=$(docker images --format "table {{.ID}}")
for container in $docker_img; do
         image_id=$(docker create $container)
         docker cp $image_id:/etc/shadow -> /tmp/tmpshadow
         echo "Following $container will be scanned now for null root password"
         passwd_check=$(cat /tmp/tmpshadow)
            if [[ $passwd_check = *"root:::0:::::"* ]]
               then
                   echo "Following $container was identified for potential null root password" >> /tmp/null_passwd.txt
                           docker images | grep $container >> /tmp/fullname.txt
                           echo "====================" >> /tmp/fullname.txt
               else
                   echo "NO null password was detected in following $container"
          fi
         docker rm $image_id
done
