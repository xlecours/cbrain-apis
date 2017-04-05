# Swagger\Client\BourreauApi

All URIs are relative to *https://localhost:3000/*

Method | HTTP request | Description
------------- | ------------- | -------------
[**bourreauxGet**](BourreauApi.md#bourreauxGet) | **GET** /bourreaux | Get a list of the Bourreaux available to be used by the current user.
[**bourreauxIdGet**](BourreauApi.md#bourreauxIdGet) | **GET** /bourreaux/{id} | Get information about a Bourreau.


# **bourreauxGet**
> \Swagger\Client\Model\Bourreau[] bourreauxGet()

Get a list of the Bourreaux available to be used by the current user.

This method returns a list of Bourreau objects.

### Example
```php
<?php
require_once(__DIR__ . '/vendor/autoload.php');

$api_instance = new Swagger\Client\Api\BourreauApi();

try {
    $result = $api_instance->bourreauxGet();
    print_r($result);
} catch (Exception $e) {
    echo 'Exception when calling BourreauApi->bourreauxGet: ', $e->getMessage(), PHP_EOL;
}
?>
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**\Swagger\Client\Model\Bourreau[]**](../Model/Bourreau.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/xml

[[Back to top]](#) [[Back to API list]](../../README.md#documentation-for-api-endpoints) [[Back to Model list]](../../README.md#documentation-for-models) [[Back to README]](../../README.md)

# **bourreauxIdGet**
> \Swagger\Client\Model\Bourreau bourreauxIdGet($id)

Get information about a Bourreau.

This method returns a single Bourreau object based on the ID parameter.

### Example
```php
<?php
require_once(__DIR__ . '/vendor/autoload.php');

$api_instance = new Swagger\Client\Api\BourreauApi();
$id = 789; // int | ID of the Bourreau to get information on.

try {
    $result = $api_instance->bourreauxIdGet($id);
    print_r($result);
} catch (Exception $e) {
    echo 'Exception when calling BourreauApi->bourreauxIdGet: ', $e->getMessage(), PHP_EOL;
}
?>
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**| ID of the Bourreau to get information on. |

### Return type

[**\Swagger\Client\Model\Bourreau**](../Model/Bourreau.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/xml

[[Back to top]](#) [[Back to API list]](../../README.md#documentation-for-api-endpoints) [[Back to Model list]](../../README.md#documentation-for-models) [[Back to README]](../../README.md)

