#!/bin/bash -l
set -eo pipefail

HEADER_TPL="---\n\n**WARNING**: This page is automatically generated from [this source code]({{ .source_link}})\n\n---"
HEADER_INCLUDE="<!-- Include: ./header.md\n\tsource_link: \"SOURCE_LINK\" -->"

find . -type d -not -path '**/\.*' -path "./${DOC_DIR_PATTERN}" |
    while read -r doc_dir; do
        source_dir=${GITHUB_SERVER_URL}/${GITHUB_REPOSITORY}/blob/${GITHUB_REF_NAME}/${doc_dir:2}
        echo "==> Upload markdown files into ${source_dir}"
        pushd "${doc_dir}"
        grep -R -l 'Space:' *.md | 
            while read -r md_file; do
                echo ${HEADER_TPL} > header.md
                cat header.md
                source_link=${source_dir}/${md_file}
                echo "==> Verify markdown file ${source_link}"
                header=${HEADER_INCLUDE/SOURCE_LINK/$source_link}
                awk -v f="$header" '/Title/{print; print f; next}1' ${md_file} > ${md_file}
                cat ${md_file}
                mark -p "${CONFLUENCE_PASSWORD}" -u "${CONFLUENCE_USERNAME}" -b "${BASE_URL}" --debug -f ${md_file} > /dev/null
            done
        popd
    done
