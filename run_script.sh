#!/usr/bin/env bash

# PWD это глобальная переменная с активным путем
DIR=${PWD}

# Запуск внешнего скрипта
${DIR}/start.sh Victor

echo ""

DUMP=$( ${DIR}/start.sh Victor )

echo "${DUMP}"
