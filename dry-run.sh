#!/bin/bash -l
set -eo pipefail

find . -type d -not -path '**/\.*' -path "./${DOC_DIR_PATTERN}" |
    while read -r doc_dir; do
        echo "==> Verify markdown files into ${doc_dir}"
        pushd "${doc_dir}"
        count=$(find . -type f -name "*.md" | wc -l | tr -d ' ')
        if [[ "${count}" -gt 0 ]]; then
            grep -R -l 'Space:' $(find . -type f -name '*.md' -mmin -30) | xargs -n1 -I{} mark -p "${CONFLUENCE_PASSWORD}" -u "${CONFLUENCE_USERNAME}" -b "${BASE_URL}" --debug --dry-run -f {} > /dev/null
        else
            echo "==> No *.md file found, skipping directory"
        fi
        popd
    done
