# User

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **float** | Unique numerical ID for the user. | [optional] 
**login** | **string** | UNIX-style username. | [optional] 
**password** | **string** | Password field | [optional] 
**password_confirmation** | **string** | Password field | [optional] 
**full_name** | **string** | Full name of the user. | [optional] 
**email** | **string** | email address of the user. | [optional] 
**type** | **string** | Class of the user, one of CoreAdmin, AdminUser, SiteManager or NormalUser. | [optional] 
**site_id** | **float** | ID of the site affiliation for the user. Can be nil. | [optional] 
**last_connected_at** | **string** | time of last connection by the user. | [optional] 
**account_locked** | **string** | Whether or not the account is locked. | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


