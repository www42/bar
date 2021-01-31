# -------------
# New blog post
# -------------

# Be sure you are in the right directory
cd 

# Create post file and (empty) image directory
# Populate post file with front matter

postdate="2021-01-28"
postname="$postdate-github-pages"

postfile="_posts/$postname.md"
touch $postfile

postimgpath=assets/images/$postname
mkdir -p $postimgpath

echo '---'                                                       >  $postfile
echo 'layout:     post'                                          >> $postfile
echo 'title:      "GitHub Pages - Getting started"'              >> $postfile
echo 'date:       2021-01-28 17:30:00 +0100'                     >> $postfile
echo 'categories: Git GitHub'                                    >> $postfile
echo "image:      /$postimgpath/foo.png"                         >> $postfile
echo '---'                                                       >> $postfile

cat $postfile