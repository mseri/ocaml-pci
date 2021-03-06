#!/bin/sh
set -e
# Make sure we're not echoing any sensitive data
set +x

eval `opam config env`
./configure --enable-docs
make doc

if [ -z "$TRAVIS" -o "$TRAVIS_PULL_REQUEST" != "false" ]; then
  echo "This is not a push Travis-ci build, doing nothing..."
  exit 0
else
  echo "Updating docs on Github pages..."
fi

DOCDIR=.gh-pages
if [ -n "$KEEP" ]; then trap "rm -rf $DOCDIR" EXIT; fi
rm -rf $DOCDIR

git clone --quiet --branch=gh-pages https://${GH_TOKEN}@github.com/simonjbeaumont/ocaml-pci $DOCDIR > /dev/null

cp _build/pci.docdir/* $DOCDIR

git -C $DOCDIR config user.email "travis@travis-ci.org"
git -C $DOCDIR config user.name "Travis"
git -C $DOCDIR commit --allow-empty -am "Travis build $TRAVIS_BUILD_NUMBER pushed docs to gh-pages"
git -C $DOCDIR push origin gh-pages > /dev/null
