#!/usr/bin/env bash

set -eux

INPUT=$PWD/release
OUTPUT=$PWD/dev_release

cp -r $PWD/blobs $INPUT/blobs
trap "rm -rf $INPUT/blobs" EXIT

RELEASE_TGZ=$PWD/release.tgz

pushd $INPUT >/dev/null
  bosh create-release --force --tarball=$RELEASE_TGZ
popd >/dev/null

## Pull out the release manifest for metadata
tar -xzf $RELEASE_TGZ release.MF

version=$(bosh int release.MF --path /version)
name=$(bosh int release.MF --path /name)
filename=${name}-${version}.tgz

echo -n $version > $OUTPUT/version
echo -n $name > $OUTPUT/name
echo -n $filename > $OUTPUT/filename

mv $RELEASE_TGZ $filename
