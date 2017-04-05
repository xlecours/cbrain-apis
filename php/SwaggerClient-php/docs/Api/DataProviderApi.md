# Swagger\Client\DataProviderApi

All URIs are relative to *https://localhost:3000/*

Method | HTTP request | Description
------------- | ------------- | -------------
[**userfilesChangeProviderPost**](DataProviderApi.md#userfilesChangeProviderPost) | **POST** /userfiles/change_provider | Moves the Userfiles from their current Data Provider to a new one.


# **userfilesChangeProviderPost**
> userfilesChangeProviderPost($params)

Moves the Userfiles from their current Data Provider to a new one.

### Example
```php
<?php
require_once(__DIR__ . '/vendor/autoload.php');

$api_instance = new Swagger\Client\Api\DataProviderApi();
$params = new \Swagger\Client\Model\Params15(); // \Swagger\Client\Model\Params15 | The params

try {
    $api_instance->userfilesChangeProviderPost($params);
} catch (Exception $e) {
    echo 'Exception when calling DataProviderApi->userfilesChangeProviderPost: ', $e->getMessage(), PHP_EOL;
}
?>
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **params** | [**\Swagger\Client\Model\Params15**](../Model/\Swagger\Client\Model\Params15.md)| The params | [optional]

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/xml

[[Back to top]](#) [[Back to API list]](../../README.md#documentation-for-api-endpoints) [[Back to Model list]](../../README.md#documentation-for-models) [[Back to README]](../../README.md)

