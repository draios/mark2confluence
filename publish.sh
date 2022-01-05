#!/bin/bash -l
set -eo pipefail

HEADER_TPL="---\n\n**WARNING**: This page is automatically generated from [this source code](SOURCE_LINK)\n\n---"

find . -type d -not -path '**/\.*' -path "./${DOC_DIR_PATTERN}" |
    while read -r doc_dir; do
        source_dir=${GITHUB_SERVER_URL}/${GITHUB_REPOSITORY}/blob/${GITHUB_REF_NAME}/${doc_dir:2}
        echo "==> Upload markdown files into ${source_dir}"
        pushd "${doc_dir}"
        #grep -R -l 'Space:' *.md | xargs -n1 -I{} mark -p "${CONFLUENCE_PASSWORD}" -u "${CONFLUENCE_USERNAME}" -b "${BASE_URL}" --debug -f {} > /dev/null
        grep -R -l 'Space:' *.md | 
            while read -r md_file; do
                source_link=${source_dir}/${md_file}
                echo "==> Verify markdown file ${source_link}"
                header=${HEADER_TPL/SOURCE_LINK/$source_link}
                echo "${header}\n$(<${md_file})" > /tmp/${md_file}
                cat /tmp/${md_file}
                mark -p "${CONFLUENCE_PASSWORD}" -u "${CONFLUENCE_USERNAME}" -b "${BASE_URL}" --debug -f /tmp/${md_file} > /dev/null
            done
        popd
    done
