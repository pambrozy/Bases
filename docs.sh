#!/bin/bash

export DOCC_JSON_PRETTYPRINT="YES"

swift package --allow-writing-to-directory ./docs \
    generate-documentation --target Bases \
    --disable-indexing \
    --transform-for-static-hosting \
    --hosting-base-path Bases \
    --output-path ./docs
