# DataProvider

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **float** | Unique ID for the Data Provider. | [optional] 
**name** | **string** | Name of the Data Provider. | [optional] 
**type** | **string** | Type of Data Provider, which usually indicates whether it is a local Data Provider, has a flat internal directory structure, or is meant for file uploading to CBRAIN. | [optional] 
**user_id** | **float** | Creator and owner of the Data Provider. | [optional] 
**group_id** | **float** | ID of the group that has access to this Data Provider. | [optional] 
**online** | **string** | Boolean variable that indicates whether the system hosting the Data Provider is accessible. | [optional] 
**read_only** | **string** | Boolean variable that indicates whether the Data Provider can be written to. | [optional] 
**description** | **string** | Description of the Data Provider. | [optional] 
**time_of_death** | **string** | The time, in the time zone of the system that hosts the Data Provider, that the Data Provider last successfully transmitted. | [optional] 
**not_syncable** | **string** | Boolean variable that indicates that the data residing on the Data Provider is not available to be transferred to an execution server&#39;s cache. | [optional] 
**time_zone** | **string** | Time zone of the system that hosts the Data Provider. | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


