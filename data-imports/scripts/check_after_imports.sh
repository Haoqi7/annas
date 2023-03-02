#!/bin/bash

set -Eeuxo pipefail

mariadb -u root -ppassword allthethings --show-warnings -vv < /scripts/helpers/check_after_imports.sql
