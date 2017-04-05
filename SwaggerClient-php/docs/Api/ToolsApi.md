# Swagger\Client\ToolsApi

All URIs are relative to *https://localhost:3000/*

Method | HTTP request | Description
------------- | ------------- | -------------
[**toolsGet**](ToolsApi.md#toolsGet) | **GET** /tools | Get the list of Tools.


# **toolsGet**
> \Swagger\Client\Model\Tool[] toolsGet()

Get the list of Tools.

This method returns a list of all of the Tools that exist in CBRAIN. Tools encapsulate a scientific program designed to extract information from an input Userfile.

### Example
```php
<?php
require_once(__DIR__ . '/vendor/autoload.php');

$api_instance = new Swagger\Client\Api\ToolsApi();

try {
    $result = $api_instance->toolsGet();
    print_r($result);
} catch (Exception $e) {
    echo 'Exception when calling ToolsApi->toolsGet: ', $e->getMessage(), PHP_EOL;
}
?>
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**\Swagger\Client\Model\Tool[]**](../Model/Tool.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/xml

[[Back to top]](#) [[Back to API list]](../../README.md#documentation-for-api-endpoints) [[Back to Model list]](../../README.md#documentation-for-models) [[Back to README]](../../README.md)

