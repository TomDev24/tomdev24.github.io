jekyll build
mkdir src
mv ./* ./src
mv src/_site/* .

git add -A
git commit -m "new upload"
git push

mv ./* src/_site/
mv src/_site/upload.sh .
mv src/* .
/bin/rm -r ./src
