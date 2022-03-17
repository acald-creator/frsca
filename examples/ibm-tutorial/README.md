# IBM Tutorial Demo

## Demo

```bash
# Only if a cluster is needed.
make setup-minikube

# Setup tekton w/ chains
make setup-tekton-chains tekton-generate-keys setup-kyverno

#### Begin local minikube registry
##
## Use this section if you want to use the minikube registry for
## publishing OCI artifacts.
##
## In a separate terminal, port forward the registry: defaults to <host-ip>:8888
#  make registry-proxy
##
## Set the registry for use in buildpacks.sh
#  export REGISTRY=<host-ip>:8888
##
#### End local minikube registry

# Run a new pipeline.
make example-ibm-tutorial
# Or re-run the last one.
# tkn pipeline start build-and-deploy-pipeline -L

# Wait until it completes.
tkn pr logs --last -f

# Ensure it has been signed.
tkn tr describe --last -o jsonpath='{.metadata.annotations.chains\.tekton\.dev/signed}'
# Should output "true"

# Export the value of IMAGE_URL from the last pipeline run and the associated taskrun name:
export IMAGE_URL=$(tkn pr describe --last -o jsonpath='{..taskResults}' | jq -r '.[] | select(.name | match("IMAGE_URL$")) | .value')
export TASK_RUN=$(tkn pr describe --last -o json | jq -r '.status.taskRuns | keys[] as $k | {"k": $k, "v": .[$k]} | select(.v.status.taskResults[]?.name | match("IMAGE_URL$")) | .k')

# Double check that the attestation and the signature were uploaded to the OCI.
crane ls "${IMAGE_URL%:*}"

# Verify the image and the attestation.
cosign verify --key k8s://tekton-chains/signing-secrets "${IMAGE_URL}"
cosign verify-attestation --key k8s://tekton-chains/signing-secrets "${IMAGE_URL}"

# Verify the signature and attestation with tkn.
tkn chain signature "${TASK_RUN}"
tkn chain payload "${TASK_RUN}"
```

## Links

- [Build and deploy a Docker image on Kubernetes using Tekton Pipelines](https://developer.ibm.com/devpractices/devops/tutorials/build-and-deploy-a-docker-image-on-kubernetes-using-tekton-pipelines/#create-a-task-to-clone-the-git-repository)