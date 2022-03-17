# SSF Sample Tekton Pipeline

This is a sample tekton based application build pipeline.

> :warning: This pipeline is not intended to be used in production

Follow these instructions to setup this pipeline and run it against your sample
application repository. In this example, we are going to build and deploy
[tekton-tutorial-openshift](https://github.com/IBM/tekton-tutorial-openshift)
application. You can use `minikube` to run your tekton pipeline and deploy this
application.

## Verify your pipeline

Before we start using our pipeline, we should always ensure the pipeline
definitions are trusted. In this example, we have signed all the pipeline and
task definitions, as well as all the images used in the tasks. We have used
[sigstore/cosign](https://github.com/sigstore/cosign) to sign these resources,
as annotated respectively.

```yaml
apiVersion: tekton.dev/v1beta1
kind: Task
metadata:
  annotations:
    cosign.sigstore.dev/imageRef: icr.io/gitsecure/git-clone:v1
```

You can verify these definitions using
[tapstry-pipelines](https://github.com/tap8stry/tapestry-pipelines) tool using
the provided public key.

```bash
# Assuming you have cloned this repo locally and `chdir` to `sample-pipeline`
# directory
% tapestry-pipelines tkn verify -d . -i icr.io/gitsecure -t v1 -key ssf-verify.pub
```

## Starting Demo

```bash
# Only if a cluster is needed.
make setup-minikube

# Setup tekton w/ chains
make setup-tekton-chains tekton-generate-keys setup-kyverno

# Run a new pipeline.
make example-sample-pipeline

# Wait until it completes.
tkn pr logs --last -f

# Export the value of IMAGE_URL from the last taskrun and the taskrun name:
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

Once successfully completed. You should be able to see your application deployed
on the cluster

```bash
% kubectl get all -n prod
NAME                          READY   STATUS    RESTARTS   AGE
pod/picalc-576dd6b788-sszmh   1/1     Running   0          32s

NAME             TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
service/picalc   NodePort   10.107.77.128   <none>        8080:30907/TCP   37s

NAME                     READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/picalc   1/1     1            1           38s

NAME                                DESIRED   CURRENT   READY   AGE
replicaset.apps/picalc-576dd6b788   1         1         1       38s
```