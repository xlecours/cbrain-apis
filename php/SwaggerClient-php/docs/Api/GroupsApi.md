# Swagger\Client\GroupsApi

All URIs are relative to *https://localhost:3000/*

Method | HTTP request | Description
------------- | ------------- | -------------
[**groupsGet**](GroupsApi.md#groupsGet) | **GET** /groups | Get a list of the Groups (projects) available to the current user.
[**groupsIdDelete**](GroupsApi.md#groupsIdDelete) | **DELETE** /groups/{id} | Deletes a Group (project).
[**groupsIdGet**](GroupsApi.md#groupsIdGet) | **GET** /groups/{id} | Get information on a Group (project).
[**groupsIdPut**](GroupsApi.md#groupsIdPut) | **PUT** /groups/{id} | Update the properties of a Group (project).
[**groupsPost**](GroupsApi.md#groupsPost) | **POST** /groups | Creates a new Group.
[**groupsSwitchPost**](GroupsApi.md#groupsSwitchPost) | **POST** /groups/switch | Switches the active group.


# **groupsGet**
> \Swagger\Client\Model\Group[] groupsGet()

Get a list of the Groups (projects) available to the current user.

This method returns a list of all of the groups that the current user has access to.

### Example
```php
<?php
require_once(__DIR__ . '/vendor/autoload.php');

$api_instance = new Swagger\Client\Api\GroupsApi();

try {
    $result = $api_instance->groupsGet();
    print_r($result);
} catch (Exception $e) {
    echo 'Exception when calling GroupsApi->groupsGet: ', $e->getMessage(), PHP_EOL;
}
?>
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**\Swagger\Client\Model\Group[]**](../Model/Group.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/xml

[[Back to top]](#) [[Back to API list]](../../README.md#documentation-for-api-endpoints) [[Back to Model list]](../../README.md#documentation-for-models) [[Back to README]](../../README.md)

# **groupsIdDelete**
> groupsIdDelete($id, $params)

Deletes a Group (project).

This method allows the removal of Groups (projects) that are no longer necessary. Groups that have Userfiles associated with them may not be deleted.

### Example
```php
<?php
require_once(__DIR__ . '/vendor/autoload.php');

$api_instance = new Swagger\Client\Api\GroupsApi();
$id = 789; // int | ID of the Group to delete.
$params = new \Swagger\Client\Model\Params10(); // \Swagger\Client\Model\Params10 | The params.

try {
    $api_instance->groupsIdDelete($id, $params);
} catch (Exception $e) {
    echo 'Exception when calling GroupsApi->groupsIdDelete: ', $e->getMessage(), PHP_EOL;
}
?>
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**| ID of the Group to delete. |
 **params** | [**\Swagger\Client\Model\Params10**](../Model/\Swagger\Client\Model\Params10.md)| The params. | [optional]

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/xml

[[Back to top]](#) [[Back to API list]](../../README.md#documentation-for-api-endpoints) [[Back to Model list]](../../README.md#documentation-for-models) [[Back to README]](../../README.md)

# **groupsIdGet**
> \Swagger\Client\Model\Group groupsIdGet($id)

Get information on a Group (project).

This method returns information on a single Group (project), specified by the ID parameter. Information returned includes the list of Users who are members of the group, the ID of the Site the Group is part of, and whether or not the group is visible to Regular Users.

### Example
```php
<?php
require_once(__DIR__ . '/vendor/autoload.php');

$api_instance = new Swagger\Client\Api\GroupsApi();
$id = 789; // int | ID of the Group to get information on.

try {
    $result = $api_instance->groupsIdGet($id);
    print_r($result);
} catch (Exception $e) {
    echo 'Exception when calling GroupsApi->groupsIdGet: ', $e->getMessage(), PHP_EOL;
}
?>
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**| ID of the Group to get information on. |

### Return type

[**\Swagger\Client\Model\Group**](../Model/Group.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/xml

[[Back to top]](#) [[Back to API list]](../../README.md#documentation-for-api-endpoints) [[Back to Model list]](../../README.md#documentation-for-models) [[Back to README]](../../README.md)

# **groupsIdPut**
> groupsIdPut($id, $params)

Update the properties of a Group (project).

This method allows the properties of a Group (project) to be updated. This includes the User membership, the ID of the site the Group belongs to, and the visibility status of the group to Regular Users.

### Example
```php
<?php
require_once(__DIR__ . '/vendor/autoload.php');

$api_instance = new Swagger\Client\Api\GroupsApi();
$id = 789; // int | ID of the Group to be updated.
$params = new \Swagger\Client\Model\Params9(); // \Swagger\Client\Model\Params9 | The params

try {
    $api_instance->groupsIdPut($id, $params);
} catch (Exception $e) {
    echo 'Exception when calling GroupsApi->groupsIdPut: ', $e->getMessage(), PHP_EOL;
}
?>
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**| ID of the Group to be updated. |
 **params** | [**\Swagger\Client\Model\Params9**](../Model/\Swagger\Client\Model\Params9.md)| The params | [optional]

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/xml

[[Back to top]](#) [[Back to API list]](../../README.md#documentation-for-api-endpoints) [[Back to Model list]](../../README.md#documentation-for-models) [[Back to README]](../../README.md)

# **groupsPost**
> groupsPost($params)

Creates a new Group.

This method creates a new Group, which allows users to organize their files and tasks.

### Example
```php
<?php
require_once(__DIR__ . '/vendor/autoload.php');

$api_instance = new Swagger\Client\Api\GroupsApi();
$params = new \Swagger\Client\Model\Params7(); // \Swagger\Client\Model\Params7 | The params

try {
    $api_instance->groupsPost($params);
} catch (Exception $e) {
    echo 'Exception when calling GroupsApi->groupsPost: ', $e->getMessage(), PHP_EOL;
}
?>
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **params** | [**\Swagger\Client\Model\Params7**](../Model/\Swagger\Client\Model\Params7.md)| The params | [optional]

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/xml

[[Back to top]](#) [[Back to API list]](../../README.md#documentation-for-api-endpoints) [[Back to Model list]](../../README.md#documentation-for-models) [[Back to README]](../../README.md)

# **groupsSwitchPost**
> groupsSwitchPost($params)

Switches the active group.

This method switches the active Group to a new one. This is useful if the analysis that the user is performing is for different projects, and involves separate Userfiles and Tasks.

### Example
```php
<?php
require_once(__DIR__ . '/vendor/autoload.php');

$api_instance = new Swagger\Client\Api\GroupsApi();
$params = new \Swagger\Client\Model\Params8(); // \Swagger\Client\Model\Params8 | The params.

try {
    $api_instance->groupsSwitchPost($params);
} catch (Exception $e) {
    echo 'Exception when calling GroupsApi->groupsSwitchPost: ', $e->getMessage(), PHP_EOL;
}
?>
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **params** | [**\Swagger\Client\Model\Params8**](../Model/\Swagger\Client\Model\Params8.md)| The params. | [optional]

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/xml

[[Back to top]](#) [[Back to API list]](../../README.md#documentation-for-api-endpoints) [[Back to Model list]](../../README.md#documentation-for-models) [[Back to README]](../../README.md)

