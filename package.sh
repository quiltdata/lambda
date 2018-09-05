#!/bin/bash

mkdir tmp411
git clone ${GIT_REPO}
python3 -m pip install REPO/DIR -t tmp411

# Untested optimization to reduce deployment size
# See https://github.com/ralienpp/simplipy/blob/master/README.md
# echo DELETING *.py `find tmp411 -name "*.py" -type f`
# find tmp411 -name "*.py" -type f -delete

# remove any old .zips
rm -f /io/lambda.zip

# grab existing products
cp -r /io/* tmp411

# zip without any containing folder (or it won't work)
cd tmp411
zip -r /io/lambda.zip *

