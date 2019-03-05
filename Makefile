#!/usr/bin/env make

$(shell mkdir -p .dev_builds .final_builds)

.PHONY: *

dev-release:
	@bosh create-release --force --tarball=.dev_builds/release.tgz
	@tar -xzf .dev_builds/release.tgz -C .dev_builds release.MF
	@bosh int .dev_builds/release.MF --path /version > .dev_builds/version
	@cp .dev_builds/release.tgz .dev_builds/jumpbox-utils-$$(cat .dev_builds/version).tgz

final-release:
	@bosh create-release --final --tarball=.final_builds/release.tgz
	@tar -xzf .final_builds/release.tgz -C .final_builds release.MF
	@bosh int .final_builds/release.MF --path /version > .final_builds/version
	@cp .final_builds/release.tgz .final_builds/jumpbox-utils-$$(cat .final_builds/version).tgz

blobs:
	for i in .blobs/*/*; do bosh add-blob $$i $${i#*/}; done
