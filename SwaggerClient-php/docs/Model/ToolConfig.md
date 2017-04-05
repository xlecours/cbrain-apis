# ToolConfig

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **float** | Unique numerical ID for the ToolConfig. | [optional] 
**version_name** | **string** | the version name of the tool&#39;s configuration | [optional] 
**description** | **string** | a description of the configuration | [optional] 
**tool_id** | **float** | the ID of the tool associated with this configuration | [optional] 
**bourreau_id** | **float** | The ID of the execution server where this tool configuration is available. | [optional] 
**env_array** | **string[]** | additional environment variables | [optional] 
**script_prologue** | **string** | A piece of bash script configured by the administrator to run before the tool is launched. | [optional] 
**group_id** | **float** | the ID of the project controlling access to this ToolConfig | [optional] 
**ncpus** | **float** | A hint at how many CPUs the CBRAIN task will allocate to run this tool configuration | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


