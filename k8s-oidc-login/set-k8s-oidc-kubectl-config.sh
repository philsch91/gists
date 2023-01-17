#!/bin/bash
# set-k8s-oidc-kubectl-config.sh
# v0.0.1

function print_debug() {
  arg1=$1
  
  if [ -n "${SET_K8S_OIDC_KUBECTL_CONFIG_DEBUG}" ]; then
    echo "${arg1}"
  fi

  return
}

OUTPUT=$(kubectl oidc-login 2>&1 >/dev/null)
RC=$?
print_debug "RC: $RC"

if [ $RC -ne 0 ] && [ $RC -ne 1 ]; then
  echo "kubelogin not correctly installed"
  echo "1. Download kubelogin from https://github.com/int128/kubelogin"
  echo "2. Create a symlink kubectl-oidc_login pointing to the kubelogin binary"
  echo "3. Add the directory containing the symlink to the PATH variable"
  exit 1
fi

if [ "$#" -ne 5 ]; then
  echo "Usage: $(basename $0) OIDC-CLIENT-ID OIDC-CLIENT-SECRET CLUSTER-NAME CLUSTER-URL PATH-TO-CLUSTER-CERT"
  exit 2
fi

if [ "$1" = "" ]; then
  echo "Please provide an OIDC client ID"
  exit 2
fi

if [ "$2" = "" ]; then
  echo "Please provide an OIDC client secret"
  exit 2
fi

if [ "$3" = "" ]; then
  echo "Please provide a cluster name"
  exit 2
fi

if [ "$4" = "" ]; then
  echo "Please provide a cluster URL"
  exit 2
fi

if [ "$5" = "" ]; then
  echo "Please provide the file path to the cluster CA"
  exit 2
fi

OIDC_CLIENT_ID="$1"
OIDC_CLIENT_SECRET="$2"
CLUSTER_NAME="$3"
CLUSTER_URL="$4"
CLUSTER_CA="$5"

OUTPUT=$(kubectl oidc-login setup \
	--oidc-issuer-url https://saml.company.com/oauth/ \
	--oidc-client-id ${OIDC_CLIENT_ID} \
	--oidc-client-secret ${OIDC_CLIENT_SECRET} \
	--oidc-extra-scope groups,email 2>&1 >/dev/null)

RC=$?
print_debug "$OUTPUT"
print_debug "RC: $RC"

CREDENTIALS_CONFIG_ENTRY_NAME="${OIDC_CLIENT_ID}-credentials"

OUTPUT=$(kubectl config set-credentials ${CREDENTIALS_CONFIG_ENTRY_NAME} \
	--exec-api-version=client.authentication.k8s.io/v1beta1 \
	--exec-command=kubectl \
	--exec-arg=oidc-login \
	--exec-arg=get-token \
	--exec-arg=--oidc-issuer-url=https://saml.company.com/oauth/ \
	--exec-arg=--oidc-client-id=${OIDC_CLIENT_ID} \
	--exec-arg=--oidc-client-secret=${OIDC_CLIENT_SECRET} \
	--exec-arg=--oidc-extra-scope=groups \
	--exec-arg=--oidc-extra-scope=email)

RC=$?
print_debug "$OUTPUT"
print_debug "RC: $RC"

CLUSTER_CONFIG_ENTRY_NAME="${CLUSTER_NAME}-cluster"

OUTPUT=$(kubectl config set-cluster ${CLUSTER_CONFIG_ENTRY_NAME} --server=${CLUSTER_URL} --embed-certs --certificate-authority=${CLUSTER_CA})
RC=$?
print_debug "$OUTPUT"
print_debug "RC: $RC"

CONTEXT_CONFIG_ENTRY_NAME="${CLUSTER_NAME}-${OIDC_CLIENT_ID}-context"

OUTPUT=$(kubectl config set-context ${CONTEXT_CONFIG_ENTRY_NAME} --cluster=${CLUSTER_CONFIG_ENTRY_NAME} --user=${CREDENTIALS_CONFIG_ENTRY_NAME})
RC=$?
print_debug "$OUTPUT"
print_debug "RC: $RC"

echo ""
echo "Use new context via the following command:"
echo "kubectl config use-context ${CONTEXT_CONFIG_ENTRY_NAME}"

exit 0
