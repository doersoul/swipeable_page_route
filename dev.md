## init
dart pub global activate melos

export $PATH:...

melos exec -- flutter pub upgrade --major-versions

## sync master
git remote add upstream https://github.com/JonasWanke/swipeable_page_route.git

git fetch upstream

git merge upstream/master

20250527 1bec1ee
