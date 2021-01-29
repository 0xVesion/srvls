#!/usr/bin/env bash
nodemon -e dart -x "clear ; dartfmt -w . ; dart run bin/*.dart"