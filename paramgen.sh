#!/bin/bash

set -e
set -o pipefail

cat select-bi-params.sql | ./duckdb ldbc.duckdb
