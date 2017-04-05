# CbrainTask

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **int** | Unique identifier for the Task. | [optional] 
**batch_id** | **int** | ID of the batch this task was launched as part of. Batches of tasks consist of the same task, with the same parameters, being run on many different input files. | [optional] 
**cluster_jobid** | **string** | ID of the task on the cluster associated with this task. | [optional] 
**cluster_workdir** | **string** | Path on the cluster to the working directory. | [optional] 
**params** | **string** | Parameters used as inputs to the scientific calculation associated with the task. | [optional] 
**status** | **string** | Current status of the task. | [optional] 
**created_at** | **string** | Date created. | [optional] 
**updated_at** | **string** | Last updated. | [optional] 
**user_id** | **float** | ID of the User who created the Task. | [optional] 
**bourreau_id** | **float** | ID of the Bourreau the Task was launched on. | [optional] 
**prerequisites** | **string** | List of prerequisites. | [optional] 
**share_wd_tid** | **float** | share_wd_tid | [optional] 
**run_number** | **float** | The number of attempts that it has taken to run the task. | [optional] 
**group_id** | **float** | ID of the group that this task is being run in. | [optional] 
**tool_config_id** | **float** | ID number that specifies which Tool Config to use. The Tool Config specifies environment variables and other system-specific scripts necessary for the Task to be run in the target environment. | [optional] 
**level** | **float** | level | [optional] 
**rank** | **float** | rank | [optional] 
**results_data_provider_id** | **float** | ID of the Data Provider that contains the Userfile that represents the results of the task. | [optional] 
**workdir_archived** | **string** | Boolean variable that indicates whether the working directory of the task is available on the processing server or has been archived and is no longer accessible. | [optional] 
**workdir_archive_userfile_id** | **float** | ID of the userfile created as part of the archival process, if the task&#39;s working directory has been archived. | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


