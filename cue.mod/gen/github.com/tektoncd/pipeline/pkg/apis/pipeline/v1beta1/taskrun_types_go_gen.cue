// Code generated by cue get go. DO NOT EDIT.

//cue:generate cue get go github.com/tektoncd/pipeline/pkg/apis/pipeline/v1beta1

package v1beta1

import (
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"github.com/tektoncd/pipeline/pkg/apis/pipeline/pod"
	corev1 "k8s.io/api/core/v1"
	duckv1 "knative.dev/pkg/apis/duck/v1"
	"github.com/tektoncd/pipeline/pkg/result"
)

// TaskRunSpec defines the desired state of TaskRun
#TaskRunSpec: {
	// +optional
	debug?: null | #TaskRunDebug @go(Debug,*TaskRunDebug)

	// +optional
	// +listType=atomic
	params?: #Params @go(Params)

	// Deprecated: Unused, preserved only for backwards compatibility
	// +optional
	resources?: null | #TaskRunResources @go(Resources,*TaskRunResources)

	// +optional
	serviceAccountName?: string @go(ServiceAccountName)

	// no more than one of the TaskRef and TaskSpec may be specified.
	// +optional
	taskRef?: null | #TaskRef @go(TaskRef,*TaskRef)

	// Specifying PipelineSpec can be disabled by setting
	// `disable-inline-spec` feature flag..
	// +optional
	taskSpec?: null | #TaskSpec @go(TaskSpec,*TaskSpec)

	// Used for cancelling a TaskRun (and maybe more later on)
	// +optional
	status?: #TaskRunSpecStatus @go(Status)

	// Status message for cancellation.
	// +optional
	statusMessage?: #TaskRunSpecStatusMessage @go(StatusMessage)

	// Retries represents how many times this TaskRun should be retried in the event of Task failure.
	// +optional
	retries?: int @go(Retries)

	// Time after which one retry attempt times out. Defaults to 1 hour.
	// Refer Go's ParseDuration documentation for expected format: https://golang.org/pkg/time/#ParseDuration
	// +optional
	timeout?: null | metav1.#Duration @go(Timeout,*metav1.Duration)

	// PodTemplate holds pod specific configuration
	podTemplate?: null | pod.#Template @go(PodTemplate,*pod.PodTemplate)

	// Workspaces is a list of WorkspaceBindings from volumes to workspaces.
	// +optional
	// +listType=atomic
	workspaces?: [...#WorkspaceBinding] @go(Workspaces,[]WorkspaceBinding)

	// Overrides to apply to Steps in this TaskRun.
	// If a field is specified in both a Step and a StepOverride,
	// the value from the StepOverride will be used.
	// This field is only supported when the alpha feature gate is enabled.
	// +optional
	// +listType=atomic
	stepOverrides?: [...#TaskRunStepOverride] @go(StepOverrides,[]TaskRunStepOverride)

	// Overrides to apply to Sidecars in this TaskRun.
	// If a field is specified in both a Sidecar and a SidecarOverride,
	// the value from the SidecarOverride will be used.
	// This field is only supported when the alpha feature gate is enabled.
	// +optional
	// +listType=atomic
	sidecarOverrides?: [...#TaskRunSidecarOverride] @go(SidecarOverrides,[]TaskRunSidecarOverride)

	// Compute resources to use for this TaskRun
	computeResources?: null | corev1.#ResourceRequirements @go(ComputeResources,*corev1.ResourceRequirements)
}

// TaskRunSpecStatus defines the TaskRun spec status the user can provide
#TaskRunSpecStatus: string

// TaskRunSpecStatusCancelled indicates that the user wants to cancel the task,
// if not already cancelled or terminated
#TaskRunSpecStatusCancelled: "TaskRunCancelled"

// TaskRunSpecStatusMessage defines human readable status messages for the TaskRun.
#TaskRunSpecStatusMessage: string // #enumTaskRunSpecStatusMessage

#enumTaskRunSpecStatusMessage:
	#TaskRunCancelledByPipelineMsg |
	#TaskRunCancelledByPipelineTimeoutMsg

// TaskRunCancelledByPipelineMsg indicates that the PipelineRun of which this
// TaskRun was a part of has been cancelled.
#TaskRunCancelledByPipelineMsg: #TaskRunSpecStatusMessage & "TaskRun cancelled as the PipelineRun it belongs to has been cancelled."

// TaskRunCancelledByPipelineTimeoutMsg indicates that the TaskRun was cancelled because the PipelineRun running it timed out.
#TaskRunCancelledByPipelineTimeoutMsg: #TaskRunSpecStatusMessage & "TaskRun cancelled as the PipelineRun it belongs to has timed out."

// EnabledOnFailureBreakpoint is the value for TaskRunDebug.Breakpoints.OnFailure that means the breakpoint onFailure is enabled
#EnabledOnFailureBreakpoint: "enabled"

// TaskRunDebug defines the breakpoint config for a particular TaskRun
#TaskRunDebug: {
	// +optional
	breakpoints?: null | #TaskBreakpoints @go(Breakpoints,*TaskBreakpoints)
}

// TaskBreakpoints defines the breakpoint config for a particular Task
#TaskBreakpoints: {
	// if enabled, pause TaskRun on failure of a step
	// failed step will not exit
	// +optional
	onFailure?: string @go(OnFailure)

	// +optional
	// +listType=atomic
	beforeSteps?: [...string] @go(BeforeSteps,[]string)
}

// TaskRunStatus defines the observed state of TaskRun
#TaskRunStatus: {
	duckv1.#Status

	#TaskRunStatusFields
}

// TaskRunConditionType is an enum used to store TaskRun custom
// conditions such as one used in spire results verification
#TaskRunConditionType: string // #enumTaskRunConditionType

#enumTaskRunConditionType:
	#TaskRunConditionResultsVerified

// TaskRunConditionResultsVerified is a Condition Type that indicates that the results were verified by spire
#TaskRunConditionResultsVerified: #TaskRunConditionType & "SignedResultsVerified"

// TaskRunReason is an enum used to store all TaskRun reason for
// the Succeeded condition that are controlled by the TaskRun itself. Failure
// reasons that emerge from underlying resources are not included here
#TaskRunReason: string // #enumTaskRunReason

#enumTaskRunReason:
	#TaskRunReasonStarted |
	#TaskRunReasonRunning |
	#TaskRunReasonSuccessful |
	#TaskRunReasonFailed |
	#TaskRunReasonToBeRetried |
	#TaskRunReasonCancelled |
	#TaskRunReasonTimedOut |
	#TaskRunReasonImagePullFailed |
	#TaskRunReasonResultsVerified |
	#TaskRunReasonsResultsVerificationFailed |
	#AwaitingTaskRunResults |
	#TaskRunReasonResultLargerThanAllowedLimit

// TaskRunReasonStarted is the reason set when the TaskRun has just started
#TaskRunReasonStarted: #TaskRunReason & "Started"

// TaskRunReasonRunning is the reason set when the TaskRun is running
#TaskRunReasonRunning: #TaskRunReason & "Running"

// TaskRunReasonSuccessful is the reason set when the TaskRun completed successfully
#TaskRunReasonSuccessful: #TaskRunReason & "Succeeded"

// TaskRunReasonFailed is the reason set when the TaskRun completed with a failure
#TaskRunReasonFailed: #TaskRunReason & "Failed"

// TaskRunReasonToBeRetried is the reason set when the last TaskRun execution failed, and will be retried
#TaskRunReasonToBeRetried: #TaskRunReason & "ToBeRetried"

// TaskRunReasonCancelled is the reason set when the TaskRun is cancelled by the user
#TaskRunReasonCancelled: #TaskRunReason & "TaskRunCancelled"

// TaskRunReasonTimedOut is the reason set when one TaskRun execution has timed out
#TaskRunReasonTimedOut: #TaskRunReason & "TaskRunTimeout"

// TaskRunReasonResolvingTaskRef indicates that the TaskRun is waiting for
// its taskRef to be asynchronously resolved.
#TaskRunReasonResolvingTaskRef: "ResolvingTaskRef"

// TaskRunReasonImagePullFailed is the reason set when the step of a task fails due to image not being pulled
#TaskRunReasonImagePullFailed: #TaskRunReason & "TaskRunImagePullFailed"

// TaskRunReasonResultsVerified is the reason set when the TaskRun results are verified by spire
#TaskRunReasonResultsVerified: #TaskRunReason & "TaskRunResultsVerified"

// TaskRunReasonsResultsVerificationFailed is the reason set when the TaskRun results are failed to verify by spire
#TaskRunReasonsResultsVerificationFailed: #TaskRunReason & "TaskRunResultsVerificationFailed"

// AwaitingTaskRunResults is the reason set when waiting upon `TaskRun` results and signatures to verify
#AwaitingTaskRunResults: #TaskRunReason & "AwaitingTaskRunResults"

// TaskRunReasonResultLargerThanAllowedLimit is the reason set when one of the results exceeds its maximum allowed limit of 1 KB
#TaskRunReasonResultLargerThanAllowedLimit: #TaskRunReason & "TaskRunResultLargerThanAllowedLimit"

// TaskRunReasonStopSidecarFailed indicates that the sidecar is not properly stopped.
#TaskRunReasonStopSidecarFailed: "TaskRunStopSidecarFailed"

// TaskRunStatusFields holds the fields of TaskRun's status.  This is defined
// separately and inlined so that other types can readily consume these fields
// via duck typing.
#TaskRunStatusFields: {
	// PodName is the name of the pod responsible for executing this task's steps.
	podName: string @go(PodName)

	// StartTime is the time the build is actually started.
	startTime?: null | metav1.#Time @go(StartTime,*metav1.Time)

	// CompletionTime is the time the build completed.
	completionTime?: null | metav1.#Time @go(CompletionTime,*metav1.Time)

	// Steps describes the state of each build step container.
	// +optional
	// +listType=atomic
	steps?: [...#StepState] @go(Steps,[]StepState)

	// CloudEvents describe the state of each cloud event requested via a
	// CloudEventResource.
	//
	// Deprecated: Removed in v0.44.0.
	//
	// +optional
	// +listType=atomic
	cloudEvents?: [...#CloudEventDelivery] @go(CloudEvents,[]CloudEventDelivery)

	// RetriesStatus contains the history of TaskRunStatus in case of a retry in order to keep record of failures.
	// All TaskRunStatus stored in RetriesStatus will have no date within the RetriesStatus as is redundant.
	// +optional
	// +listType=atomic
	retriesStatus?: [...#TaskRunStatus] @go(RetriesStatus,[]TaskRunStatus)

	// Results from Resources built during the TaskRun.
	// This is tomb-stoned along with the removal of pipelineResources
	// Deprecated: this field is not populated and is preserved only for backwards compatibility
	// +optional
	// +listType=atomic
	resourcesResult?: [...result.#RunResult] @go(ResourcesResult,[]PipelineResourceResult)

	// TaskRunResults are the list of results written out by the task's containers
	// +optional
	// +listType=atomic
	taskResults?: [...#TaskRunResult] @go(TaskRunResults,[]TaskRunResult)

	// The list has one entry per sidecar in the manifest. Each entry is
	// represents the imageid of the corresponding sidecar.
	// +listType=atomic
	sidecars?: [...#SidecarState] @go(Sidecars,[]SidecarState)

	// TaskSpec contains the Spec from the dereferenced Task definition used to instantiate this TaskRun.
	taskSpec?: null | #TaskSpec @go(TaskSpec,*TaskSpec)

	// Provenance contains some key authenticated metadata about how a software artifact was built (what sources, what inputs/outputs, etc.).
	// +optional
	provenance?: null | #Provenance @go(Provenance,*Provenance)

	// SpanContext contains tracing span context fields
	spanContext?: {[string]: string} @go(SpanContext,map[string]string)
}

// TaskRunStepOverride is used to override the values of a Step in the corresponding Task.
#TaskRunStepOverride: {
	// The name of the Step to override.
	name: string @go(Name)

	// The resource requirements to apply to the Step.
	resources: corev1.#ResourceRequirements @go(Resources)
}

// TaskRunSidecarOverride is used to override the values of a Sidecar in the corresponding Task.
#TaskRunSidecarOverride: {
	// The name of the Sidecar to override.
	name: string @go(Name)

	// The resource requirements to apply to the Sidecar.
	resources: corev1.#ResourceRequirements @go(Resources)
}

// StepState reports the results of running a step in a Task.
#StepState: {
	corev1.#ContainerState
	name?:      string @go(Name)
	container?: string @go(ContainerName)
	imageID?:   string @go(ImageID)
	results?: [...#TaskRunResult] @go(Results,[]TaskRunStepResult)
	provenance?: null | #Provenance @go(Provenance,*Provenance)
	inputs?: [...#Artifact] @go(Inputs,[]TaskRunStepArtifact)
	outputs?: [...#Artifact] @go(Outputs,[]TaskRunStepArtifact)
}

// SidecarState reports the results of running a sidecar in a Task.
#SidecarState: {
	corev1.#ContainerState
	name?:      string @go(Name)
	container?: string @go(ContainerName)
	imageID?:   string @go(ImageID)
}

// CloudEventDelivery is the target of a cloud event along with the state of
// delivery.
#CloudEventDelivery: {
	// Target points to an addressable
	target?: string                   @go(Target)
	status?: #CloudEventDeliveryState @go(Status)
}

// CloudEventCondition is a string that represents the condition of the event.
#CloudEventCondition: string // #enumCloudEventCondition

#enumCloudEventCondition:
	#CloudEventConditionUnknown |
	#CloudEventConditionSent |
	#CloudEventConditionFailed

// CloudEventConditionUnknown means that the condition for the event to be
// triggered was not met yet, or we don't know the state yet.
#CloudEventConditionUnknown: #CloudEventCondition & "Unknown"

// CloudEventConditionSent means that the event was sent successfully
#CloudEventConditionSent: #CloudEventCondition & "Sent"

// CloudEventConditionFailed means that there was one or more attempts to
// send the event, and none was successful so far.
#CloudEventConditionFailed: #CloudEventCondition & "Failed"

// CloudEventDeliveryState reports the state of a cloud event to be sent.
#CloudEventDeliveryState: {
	// Current status
	condition?: #CloudEventCondition @go(Condition)

	// SentAt is the time at which the last attempt to send the event was made
	// +optional
	sentAt?: null | metav1.#Time @go(SentAt,*metav1.Time)

	// Error is the text of error (if any)
	message: string @go(Error)

	// RetryCount is the number of attempts of sending the cloud event
	retryCount: int32 @go(RetryCount)
}

// TaskRun represents a single execution of a Task. TaskRuns are how the steps
// specified in a Task are executed; they specify the parameters and resources
// used to run the steps in a Task.
//
// Deprecated: Please use v1.TaskRun instead.
#TaskRun: {
	metav1.#TypeMeta

	// +optional
	metadata?: metav1.#ObjectMeta @go(ObjectMeta)

	// +optional
	spec?: #TaskRunSpec @go(Spec)

	// +optional
	status?: #TaskRunStatus @go(Status)
}

// TaskRunList contains a list of TaskRun
#TaskRunList: {
	metav1.#TypeMeta

	// +optional
	metadata?: metav1.#ListMeta @go(ListMeta)
	items: [...#TaskRun] @go(Items,[]TaskRun)
}
