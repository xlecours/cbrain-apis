# Swagger\Client\TasksApi

All URIs are relative to *https://localhost:3000/*

Method | HTTP request | Description
------------- | ------------- | -------------
[**tasksGet**](TasksApi.md#tasksGet) | **GET** /tasks | Get the list of Tasks.
[**tasksIdDelete**](TasksApi.md#tasksIdDelete) | **DELETE** /tasks/{id} | Deletes a Task
[**tasksIdGet**](TasksApi.md#tasksIdGet) | **GET** /tasks/{id} | Get information on a Task.
[**tasksIdPut**](TasksApi.md#tasksIdPut) | **PUT** /tasks/{id} | Update information on a Task.
[**tasksPost**](TasksApi.md#tasksPost) | **POST** /tasks | Create a new Task.


# **tasksGet**
> \Swagger\Client\Model\CbrainTask[] tasksGet()

Get the list of Tasks.

This method returns the list of Tasks accessible to the current user.

### Example
```php
<?php
require_once(__DIR__ . '/vendor/autoload.php');

$api_instance = new Swagger\Client\Api\TasksApi();

try {
    $result = $api_instance->tasksGet();
    print_r($result);
} catch (Exception $e) {
    echo 'Exception when calling TasksApi->tasksGet: ', $e->getMessage(), PHP_EOL;
}
?>
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**\Swagger\Client\Model\CbrainTask[]**](../Model/CbrainTask.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/xml

[[Back to top]](#) [[Back to API list]](../../README.md#documentation-for-api-endpoints) [[Back to Model list]](../../README.md#documentation-for-models) [[Back to README]](../../README.md)

# **tasksIdDelete**
> tasksIdDelete($id, $params)

Deletes a Task

Deletes a Task from CBRAIN.

### Example
```php
<?php
require_once(__DIR__ . '/vendor/autoload.php');

$api_instance = new Swagger\Client\Api\TasksApi();
$id = 789; // int | The ID number of the Task to delete.
$params = new \Swagger\Client\Model\Params21(); // \Swagger\Client\Model\Params21 | The params

try {
    $api_instance->tasksIdDelete($id, $params);
} catch (Exception $e) {
    echo 'Exception when calling TasksApi->tasksIdDelete: ', $e->getMessage(), PHP_EOL;
}
?>
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**| The ID number of the Task to delete. |
 **params** | [**\Swagger\Client\Model\Params21**](../Model/\Swagger\Client\Model\Params21.md)| The params | [optional]

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/xml

[[Back to top]](#) [[Back to API list]](../../README.md#documentation-for-api-endpoints) [[Back to Model list]](../../README.md#documentation-for-models) [[Back to README]](../../README.md)

# **tasksIdGet**
> tasksIdGet($id)

Get information on a Task.

This method returns information on a Task, including its status, Task restartability and information on where the results are kept.

### Example
```php
<?php
require_once(__DIR__ . '/vendor/autoload.php');

$api_instance = new Swagger\Client\Api\TasksApi();
$id = 789; // int | The ID number of the Userfile to delete.

try {
    $api_instance->tasksIdGet($id);
} catch (Exception $e) {
    echo 'Exception when calling TasksApi->tasksIdGet: ', $e->getMessage(), PHP_EOL;
}
?>
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**| The ID number of the Userfile to delete. |

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/xml

[[Back to top]](#) [[Back to API list]](../../README.md#documentation-for-api-endpoints) [[Back to Model list]](../../README.md#documentation-for-models) [[Back to README]](../../README.md)

# **tasksIdPut**
> tasksIdPut($id, $params)

Update information on a Task.

This method updates information about a Task in CBRAIN.

### Example
```php
<?php
require_once(__DIR__ . '/vendor/autoload.php');

$api_instance = new Swagger\Client\Api\TasksApi();
$id = 789; // int | The ID number of the Userfile to update.
$params = new \Swagger\Client\Model\Params20(); // \Swagger\Client\Model\Params20 | The params

try {
    $api_instance->tasksIdPut($id, $params);
} catch (Exception $e) {
    echo 'Exception when calling TasksApi->tasksIdPut: ', $e->getMessage(), PHP_EOL;
}
?>
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**| The ID number of the Userfile to update. |
 **params** | [**\Swagger\Client\Model\Params20**](../Model/\Swagger\Client\Model\Params20.md)| The params | [optional]

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/xml

[[Back to top]](#) [[Back to API list]](../../README.md#documentation-for-api-endpoints) [[Back to Model list]](../../README.md#documentation-for-models) [[Back to README]](../../README.md)

# **tasksPost**
> tasksPost($params)

Create a new Task.

This method allows the creation of a new Task.

### Example
```php
<?php
require_once(__DIR__ . '/vendor/autoload.php');

$api_instance = new Swagger\Client\Api\TasksApi();
$params = new \Swagger\Client\Model\Params19(); // \Swagger\Client\Model\Params19 | The params.

try {
    $api_instance->tasksPost($params);
} catch (Exception $e) {
    echo 'Exception when calling TasksApi->tasksPost: ', $e->getMessage(), PHP_EOL;
}
?>
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **params** | [**\Swagger\Client\Model\Params19**](../Model/\Swagger\Client\Model\Params19.md)| The params. | [optional]

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/xml

[[Back to top]](#) [[Back to API list]](../../README.md#documentation-for-api-endpoints) [[Back to Model list]](../../README.md#documentation-for-models) [[Back to README]](../../README.md)

