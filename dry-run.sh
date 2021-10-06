#!/bin/bash -l
set -eo pipefail

find . -type d -not -path '**/\.*' -path "./${DOC_DIR_PATTERN}" |
    while read -r doc_dir; do
        source_dir=${GITHUB_SERVER_URL}/${GITHUB_REPOSITORY}/blob/${GITHUB_REF}/${doc_dir:2}
        echo "==> Verify markdown files into ${source_dir}"
        pushd "${doc_dir}" 
        grep -R -l 'Space:' *.md | 
            while read -r md_file; do
                source_link=${source_dir}/${md_file}
                echo "==> Verify markdown file ${source_link}"
                sed -e "s|SOURCE_LINK|${source_link}|" header.md > /tmp/header.md
                sed -e "/Title/r /tmp/header.md" ${md_file} > ${md_file}
                mark -p "${CONFLUENCE_PASSWORD}" -u "${CONFLUENCE_USERNAME}" -b "${BASE_URL}" --debug --dry-run -f ${md_file} > /dev/null
            done
        popd
    done
