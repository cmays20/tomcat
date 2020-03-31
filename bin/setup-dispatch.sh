#!/bin/sh

if [[ -z "${GITHUB_USERNAME}" ]]; then
  echo "ENV:GITHUB_USERNAME is not set, exiting."
  exit 1
fi

if [[ -z "${GITHUB_TOKEN}" ]]; then
  echo "ENV:GITHUB_TOKEN is not set, exiting."
  exit 1
fi

kubectl -n dispatch get serviceaccount dispatch-sa
if [ $? -eq 1 ]; then
    dispatch serviceaccount create dispatch-sa --namespace dispatch
fi
kubectl -n dispatch get secret dispatch-sa-basic-auth
if [ $? -eq 1 ]; then
    dispatch login github --user ${GITHUB_USERNAME} --token ${GITHUB_TOKEN} --service-account dispatch-sa --namespace dispatch
fi
docker login
kubectl -n dispatch get secret dispatch-sa-docker-auth
if [ $? -eq 1 ]; then
    dispatch login docker --service-account dispatch-sa --namespace dispatch
fi

# Create CI Repository
#     This step creates the webhook in the Developers GitHub repository
#     This may also be done in the Dispatch UI!
dispatch ci repository create --service-account dispatch-sa --namespace dispatch
