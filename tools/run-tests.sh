#!/bin/bash
set -ev

test -z $2 && echo "Usage: ${0} FORMULA_NAME OS_ID" && exit 1
export FORMULA_NAME=$1
export OS_ID=$2


function docker-run-pytest() {
    docker run --rm \
        -v "$@":/opt/tests \
        --env=STAGE=TEST \
        -h "salt-testing-${OS_ID}" \
        --name "salt-testing-${OS_ID}" \
        -it ${FORMULA_NAME}:"salt-testing-${OS_ID}" \
        pytest -sv /opt/tests
}

for i in $(find $PWD/tests/pytests/* -maxdepth 0 -type d); do
    docker-run-pytest $i;
done
