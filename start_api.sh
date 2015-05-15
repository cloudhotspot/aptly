#!/bin/bash
if [[ $APTLY_API ]]; then
  exec aptly api serve -listen=":8889" -config=$REPO_CONF
fi