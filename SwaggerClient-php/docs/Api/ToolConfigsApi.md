# Swagger\Client\ToolConfigsApi

All URIs are relative to *https://localhost:3000/*

Method | HTTP request | Description
------------- | ------------- | -------------
[**toolConfigsGet**](ToolConfigsApi.md#toolConfigsGet) | **GET** /tool_configs | Get a list of tool versions installed.
[**toolConfigsIdGet**](ToolConfigsApi.md#toolConfigsIdGet) | **GET** /tool_configs/{id} | Get information about a particular tool configuration


# **toolConfigsGet**
> \Swagger\Client\Model\ToolConfig[] toolConfigsGet()

Get a list of tool versions installed.

This method returns a list of tool config objects.

### Example
```php
<?php
require_once(__DIR__ . '/vendor/autoload.php');

$api_instance = new Swagger\Client\Api\ToolConfigsApi();

try {
    $result = $api_instance->toolConfigsGet();
    print_r($result);
} catch (Exception $e) {
    echo 'Exception when calling ToolConfigsApi->toolConfigsGet: ', $e->getMessage(), PHP_EOL;
}
?>
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**\Swagger\Client\Model\ToolConfig[]**](../Model/ToolConfig.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/xml

[[Back to top]](#) [[Back to API list]](../../README.md#documentation-for-api-endpoints) [[Back to Model list]](../../README.md#documentation-for-models) [[Back to README]](../../README.md)

# **toolConfigsIdGet**
> \Swagger\Client\Model\ToolConfig toolConfigsIdGet($id)

Get information about a particular tool configuration

Returns the information about how a particular configuration of a tool on an execution server.

### Example
```php
<?php
require_once(__DIR__ . '/vendor/autoload.php');

$api_instance = new Swagger\Client\Api\ToolConfigsApi();
$id = "id_example"; // string | the ID of the configuration

try {
    $result = $api_instance->toolConfigsIdGet($id);
    print_r($result);
} catch (Exception $e) {
    echo 'Exception when calling ToolConfigsApi->toolConfigsIdGet: ', $e->getMessage(), PHP_EOL;
}
?>
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **string**| the ID of the configuration |

### Return type

[**\Swagger\Client\Model\ToolConfig**](../Model/ToolConfig.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/xml

[[Back to top]](#) [[Back to API list]](../../README.md#documentation-for-api-endpoints) [[Back to Model list]](../../README.md#documentation-for-models) [[Back to README]](../../README.md)

