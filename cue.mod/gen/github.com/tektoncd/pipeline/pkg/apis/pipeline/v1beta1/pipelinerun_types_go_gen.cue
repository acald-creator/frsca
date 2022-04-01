// Code generated by cue get go. DO NOT EDIT.

//cue:generate cue get go github.com/tektoncd/pipeline/pkg/apis/pipeline/v1beta1

package v1beta1

import (
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"github.com/tektoncd/pipeline/pkg/apis/pipeline/pod"
	duckv1beta1 "knative.dev/pkg/apis/duck/v1beta1"
	runv1alpha1 "github.com/tektoncd/pipeline/pkg/apis/run/v1alpha1"
)

// PipelineRun represents a single execution of a Pipeline. PipelineRuns are how
// the graph of Tasks declared in a Pipeline are executed; they specify inputs
// to Pipelines such as parameter values and capture operational aspects of the
// Tasks execution such as service account and tolerations. Creating a
// PipelineRun creates TaskRuns for Tasks in the referenced Pipeline.
//
// +k8s:openapi-gen=true
#PipelineRun: {
	metav1.#TypeMeta

	// +optional
	metadata?: metav1.#ObjectMeta @go(ObjectMeta)

	// +optional
	spec?: #PipelineRunSpec @go(Spec)

	// +optional
	status?: #PipelineRunStatus @go(Status)
}

// PipelineRunSpec defines the desired state of PipelineRun
#PipelineRunSpec: {
	// +optional
	pipelineRef?: null | #PipelineRef @go(PipelineRef,*PipelineRef)

	// +optional
	pipelineSpec?: null | #PipelineSpec @go(PipelineSpec,*PipelineSpec)

	// Resources is a list of bindings specifying which actual instances of
	// PipelineResources to use for the resources the Pipeline has declared
	// it needs.
	resources?: [...#PipelineResourceBinding] @go(Resources,[]PipelineResourceBinding)

	// Params is a list of parameter names and values.
	params?: [...#Param] @go(Params,[]Param)

	// +optional
	serviceAccountName?: string @go(ServiceAccountName)

	// Deprecated: use taskRunSpecs.ServiceAccountName instead
	// +optional
	serviceAccountNames?: [...#PipelineRunSpecServiceAccountName] @go(ServiceAccountNames,[]PipelineRunSpecServiceAccountName)

	// Used for cancelling a pipelinerun (and maybe more later on)
	// +optional
	status?: #PipelineRunSpecStatus @go(Status)

	// This is an alpha field. You must set the "enable-api-fields" feature flag to "alpha"
	// for this field to be supported.
	//
	// Time after which the Pipeline times out.
	// Currently three keys are accepted in the map
	// pipeline, tasks and finally
	// with Timeouts.pipeline >= Timeouts.tasks + Timeouts.finally
	// +optional
	timeouts?: null | #TimeoutFields @go(Timeouts,*TimeoutFields)

	// Time after which the Pipeline times out. Defaults to never.
	// Refer to Go's ParseDuration documentation for expected format: https://golang.org/pkg/time/#ParseDuration
	// +optional
	timeout?: null | metav1.#Duration @go(Timeout,*metav1.Duration)

	// PodTemplate holds pod specific configuration
	podTemplate?: null | pod.#Template @go(PodTemplate,*github.com/tektoncd/pipeline/pkg/apis/pipeline/pod.Template)

	// Workspaces holds a set of workspace bindings that must match names
	// with those declared in the pipeline.
	// +optional
	workspaces?: [...#WorkspaceBinding] @go(Workspaces,[]WorkspaceBinding)

	// TaskRunSpecs holds a set of runtime specs
	// +optional
	taskRunSpecs?: [...#PipelineTaskRunSpec] @go(TaskRunSpecs,[]PipelineTaskRunSpec)
}

// TimeoutFields allows granular specification of pipeline, task, and finally timeouts
#TimeoutFields: {
	// Pipeline sets the maximum allowed duration for execution of the entire pipeline. The sum of individual timeouts for tasks and finally must not exceed this value.
	pipeline?: null | metav1.#Duration @go(Pipeline,*metav1.Duration)

	// Tasks sets the maximum allowed duration of this pipeline's tasks
	tasks?: null | metav1.#Duration @go(Tasks,*metav1.Duration)

	// Finally sets the maximum allowed duration of this pipeline's finally
	finally?: null | metav1.#Duration @go(Finally,*metav1.Duration)
}

// PipelineRunSpecStatus defines the pipelinerun spec status the user can provide
#PipelineRunSpecStatus: string

// PipelineRunSpecStatusCancelledDeprecated Deprecated: indicates that the user wants to cancel the task,
// if not already cancelled or terminated (replaced by "Cancelled")
#PipelineRunSpecStatusCancelledDeprecated: "PipelineRunCancelled"

// PipelineRunSpecStatusCancelled indicates that the user wants to cancel the task,
// if not already cancelled or terminated
#PipelineRunSpecStatusCancelled: "Cancelled"

// PipelineRunSpecStatusCancelledRunFinally indicates that the user wants to cancel the pipeline run,
// if not already cancelled or terminated, but ensure finally is run normally
#PipelineRunSpecStatusCancelledRunFinally: "CancelledRunFinally"

// PipelineRunSpecStatusStoppedRunFinally indicates that the user wants to stop the pipeline run,
// wait for already running tasks to be completed and run finally
// if not already cancelled or terminated
#PipelineRunSpecStatusStoppedRunFinally: "StoppedRunFinally"

// PipelineRunSpecStatusPending indicates that the user wants to postpone starting a PipelineRun
// until some condition is met
#PipelineRunSpecStatusPending: "PipelineRunPending"

// PipelineRef can be used to refer to a specific instance of a Pipeline.
// Copied from CrossVersionObjectReference: https://github.com/kubernetes/kubernetes/blob/169df7434155cbbc22f1532cba8e0a9588e29ad8/pkg/apis/autoscaling/types.go#L64
#PipelineRef: {
	// Name of the referent; More info: http://kubernetes.io/docs/user-guide/identifiers#names
	name?: string @go(Name)

	// API version of the referent
	// +optional
	apiVersion?: string @go(APIVersion)

	// Bundle url reference to a Tekton Bundle.
	// +optional
	bundle?: string @go(Bundle)
}

// PipelineRunStatus defines the observed state of PipelineRun
#PipelineRunStatus: {
	duckv1beta1.#Status

	#PipelineRunStatusFields
}

// PipelineRunReason represents a reason for the pipeline run "Succeeded" condition
#PipelineRunReason: string // #enumPipelineRunReason

#enumPipelineRunReason:
	#PipelineRunReasonStarted |
	#PipelineRunReasonRunning |
	#PipelineRunReasonSuccessful |
	#PipelineRunReasonCompleted |
	#PipelineRunReasonFailed |
	#PipelineRunReasonCancelled |
	#PipelineRunReasonPending |
	#PipelineRunReasonTimedOut |
	#PipelineRunReasonStopping |
	#PipelineRunReasonCancelledRunningFinally |
	#PipelineRunReasonStoppedRunningFinally

// PipelineRunReasonStarted is the reason set when the PipelineRun has just started
#PipelineRunReasonStarted: #PipelineRunReason & "Started"

// PipelineRunReasonRunning is the reason set when the PipelineRun is running
#PipelineRunReasonRunning: #PipelineRunReason & "Running"

// PipelineRunReasonSuccessful is the reason set when the PipelineRun completed successfully
#PipelineRunReasonSuccessful: #PipelineRunReason & "Succeeded"

// PipelineRunReasonCompleted is the reason set when the PipelineRun completed successfully with one or more skipped Tasks
#PipelineRunReasonCompleted: #PipelineRunReason & "Completed"

// PipelineRunReasonFailed is the reason set when the PipelineRun completed with a failure
#PipelineRunReasonFailed: #PipelineRunReason & "Failed"

// PipelineRunReasonCancelled is the reason set when the PipelineRun cancelled by the user
// This reason may be found with a corev1.ConditionFalse status, if the cancellation was processed successfully
// This reason may be found with a corev1.ConditionUnknown status, if the cancellation is being processed or failed
#PipelineRunReasonCancelled: #PipelineRunReason & "Cancelled"

// PipelineRunReasonPending is the reason set when the PipelineRun is in the pending state
#PipelineRunReasonPending: #PipelineRunReason & "PipelineRunPending"

// PipelineRunReasonTimedOut is the reason set when the PipelineRun has timed out
#PipelineRunReasonTimedOut: #PipelineRunReason & "PipelineRunTimeout"

// PipelineRunReasonStopping indicates that no new Tasks will be scheduled by the controller, and the
// pipeline will stop once all running tasks complete their work
#PipelineRunReasonStopping: #PipelineRunReason & "PipelineRunStopping"

// PipelineRunReasonCancelledRunningFinally indicates that pipeline has been gracefully cancelled
// and no new Tasks will be scheduled by the controller, but final tasks are now running
#PipelineRunReasonCancelledRunningFinally: #PipelineRunReason & "CancelledRunningFinally"

// PipelineRunReasonStoppedRunningFinally indicates that pipeline has been gracefully stopped
// and no new Tasks will be scheduled by the controller, but final tasks are now running
#PipelineRunReasonStoppedRunningFinally: #PipelineRunReason & "StoppedRunningFinally"

// PipelineRunStatusFields holds the fields of PipelineRunStatus' status.
// This is defined separately and inlined so that other types can readily
// consume these fields via duck typing.
#PipelineRunStatusFields: {
	// StartTime is the time the PipelineRun is actually started.
	// +optional
	startTime?: null | metav1.#Time @go(StartTime,*metav1.Time)

	// CompletionTime is the time the PipelineRun completed.
	// +optional
	completionTime?: null | metav1.#Time @go(CompletionTime,*metav1.Time)

	// map of PipelineRunTaskRunStatus with the taskRun name as the key
	// +optional
	taskRuns?: {[string]: null | #PipelineRunTaskRunStatus} @go(TaskRuns,map[string]*PipelineRunTaskRunStatus)

	// map of PipelineRunRunStatus with the run name as the key
	// +optional
	runs?: {[string]: null | #PipelineRunRunStatus} @go(Runs,map[string]*PipelineRunRunStatus)

	// PipelineResults are the list of results written out by the pipeline task's containers
	// +optional
	pipelineResults?: [...#PipelineRunResult] @go(PipelineResults,[]PipelineRunResult)

	// PipelineRunSpec contains the exact spec used to instantiate the run
	pipelineSpec?: null | #PipelineSpec @go(PipelineSpec,*PipelineSpec)

	// list of tasks that were skipped due to when expressions evaluating to false
	// +optional
	skippedTasks?: [...#SkippedTask] @go(SkippedTasks,[]SkippedTask)
}

// SkippedTask is used to describe the Tasks that were skipped due to their When Expressions
// evaluating to False. This is a struct because we are looking into including more details
// about the When Expressions that caused this Task to be skipped.
#SkippedTask: {
	// Name is the Pipeline Task name
	name: string @go(Name)

	// WhenExpressions is the list of checks guarding the execution of the PipelineTask
	// +optional
	whenExpressions?: [...#WhenExpression] @go(WhenExpressions,[]WhenExpression)
}

// PipelineRunResult used to describe the results of a pipeline
#PipelineRunResult: {
	// Name is the result's name as declared by the Pipeline
	name: string @go(Name)

	// Value is the result returned from the execution of this PipelineRun
	value: string @go(Value)
}

// PipelineRunTaskRunStatus contains the name of the PipelineTask for this TaskRun and the TaskRun's Status
#PipelineRunTaskRunStatus: {
	// PipelineTaskName is the name of the PipelineTask.
	pipelineTaskName?: string @go(PipelineTaskName)

	// Status is the TaskRunStatus for the corresponding TaskRun
	// +optional
	status?: null | #TaskRunStatus @go(Status,*TaskRunStatus)

	// ConditionChecks maps the name of a condition check to its Status
	// +optional
	conditionChecks?: {[string]: null | #PipelineRunConditionCheckStatus} @go(ConditionChecks,map[string]*PipelineRunConditionCheckStatus)

	// WhenExpressions is the list of checks guarding the execution of the PipelineTask
	// +optional
	whenExpressions?: [...#WhenExpression] @go(WhenExpressions,[]WhenExpression)
}

// PipelineRunRunStatus contains the name of the PipelineTask for this Run and the Run's Status
#PipelineRunRunStatus: {
	// PipelineTaskName is the name of the PipelineTask.
	pipelineTaskName?: string @go(PipelineTaskName)

	// Status is the RunStatus for the corresponding Run
	// +optional
	status?: null | runv1alpha1.#RunStatus @go(Status,*runv1alpha1.RunStatus)

	// WhenExpressions is the list of checks guarding the execution of the PipelineTask
	// +optional
	whenExpressions?: [...#WhenExpression] @go(WhenExpressions,[]WhenExpression)
}

// PipelineRunConditionCheckStatus returns the condition check status
#PipelineRunConditionCheckStatus: {
	// ConditionName is the name of the Condition
	conditionName?: string @go(ConditionName)

	// Status is the ConditionCheckStatus for the corresponding ConditionCheck
	// +optional
	status?: null | #ConditionCheckStatus @go(Status,*ConditionCheckStatus)
}

// PipelineRunSpecServiceAccountName can be used to configure specific
// ServiceAccountName for a concrete Task
#PipelineRunSpecServiceAccountName: {
	taskName?:           string @go(TaskName)
	serviceAccountName?: string @go(ServiceAccountName)
}

// PipelineRunList contains a list of PipelineRun
#PipelineRunList: {
	metav1.#TypeMeta

	// +optional
	metadata?: metav1.#ListMeta @go(ListMeta)
	items?: [...#PipelineRun] @go(Items,[]PipelineRun)
}

// PipelineTaskRun reports the results of running a step in the Task. Each
// task has the potential to succeed or fail (based on the exit code)
// and produces logs.
#PipelineTaskRun: {
	name?: string @go(Name)
}

// PipelineTaskRunSpec  can be used to configure specific
// specs for a concrete Task
#PipelineTaskRunSpec: {
	pipelineTaskName?:       string               @go(PipelineTaskName)
	taskServiceAccountName?: string               @go(TaskServiceAccountName)
	taskPodTemplate?:        null | pod.#Template @go(TaskPodTemplate,*github.com/tektoncd/pipeline/pkg/apis/pipeline/pod.Template)
}