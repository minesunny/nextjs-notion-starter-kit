#!/bin/bash
NEXT_NOTION_DIR=$1
DOCKER_USERNAME=$2
NEW_TAG=$3
echo  "start to init next-notion env,or stop old next-notion env"
echo "[$NEXT_NOTION_DIR]"
if [ ! -d "$NEXT_NOTION_DIR" ]; then
  mkdir -p "$NEXT_NOTION_DIR" && cd "$_" > /dev/null 2>&1 || exit 1
  echo "create dir $NEXT_NOTION_DIR"
else
  echo "dir [$NEXT_NOTION_DIR] exist"
fi

if docker images | grep -q next-notion; then
  docker-compose -f "$NEXT_NOTION_DIR/docker-compose.yml" down
  oldTag=$(docker images | grep next-notion | awk '{print $3}')
  echo "$oldTag" | xargs docker rmi -f
  echo "clean old next-notion tags:[$oldTag]"
else
  echo "does not exist old tags,does not need to clean"
fi



echo "start to update next-notion to new tag [$NEW_TAG]"
if grep -q "tag" "$NEXT_NOTION_DIR/docker-compose.yml"; then
  sed -i "s/tag/$NEW_TAG/g" "$NEXT_NOTION_DIR/docker-compose.yml"
  echo "successful update next-notion to new tag [$NEW_TAG]"

fi
if grep -q "repository" "$NEXT_NOTION_DIR/docker-compose.yml"; then
  sed -i "s/repository/$DOCKER_USERNAME/g" "$NEXT_NOTION_DIR/docker-compose.yml"
fi

echo "start to up containers......"
echo "the docker-compose is $(< "$NEXT_NOTION_DIR/docker-compose.yml")"
docker-compose -f "$NEXT_NOTION_DIR/docker-compose.yml" up -d
echo "successful to start up containers"