jekyll build
mkdir src
mv ./* ./src
mv src/_site/* .

git add -A
git commit -m "new upload"
git push

mv !(upload.sh) src/_site/  # move all except upload.sh
mv src/* .
/bin/rm -r ./src
