#!/bin/bash
set -e
echo "$DOCKERHUB_PAT" | docker login -u "$_DOCKERHUB_USER" --password-stdin
