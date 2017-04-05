# Swagger\Client\DataProvidersApi

All URIs are relative to *https://localhost:3000/*

Method | HTTP request | Description
------------- | ------------- | -------------
[**dataProvidersGet**](DataProvidersApi.md#dataProvidersGet) | **GET** /data_providers | Get a list of the Data Providers available to the current user.
[**dataProvidersIdBrowseGet**](DataProvidersApi.md#dataProvidersIdBrowseGet) | **GET** /data_providers/{id}/browse | List the files on a Data Provider.
[**dataProvidersIdDeletePost**](DataProvidersApi.md#dataProvidersIdDeletePost) | **POST** /data_providers/{id}/delete | Deletes unregistered files from a CBRAIN Data provider.
[**dataProvidersIdGet**](DataProvidersApi.md#dataProvidersIdGet) | **GET** /data_providers/{id} | Get information on a particular Data Provider.
[**dataProvidersIdIsAliveGet**](DataProvidersApi.md#dataProvidersIdIsAliveGet) | **GET** /data_providers/{id}/is_alive | Pings a Data Provider to check if it&#39;s running.
[**dataProvidersIdRegisterPost**](DataProvidersApi.md#dataProvidersIdRegisterPost) | **POST** /data_providers/{id}/register | Registers a file as a Userfile in CBRAIN.
[**dataProvidersIdUnregisterPost**](DataProvidersApi.md#dataProvidersIdUnregisterPost) | **POST** /data_providers/{id}/unregister | Unregisters files as Userfile in CBRAIN.


# **dataProvidersGet**
> \Swagger\Client\Model\DataProvider[] dataProvidersGet()

Get a list of the Data Providers available to the current user.

This method returns a list of Data Provider objects that represent servers with disk space accessible for storing Userfiles.

### Example
```php
<?php
require_once(__DIR__ . '/vendor/autoload.php');

$api_instance = new Swagger\Client\Api\DataProvidersApi();

try {
    $result = $api_instance->dataProvidersGet();
    print_r($result);
} catch (Exception $e) {
    echo 'Exception when calling DataProvidersApi->dataProvidersGet: ', $e->getMessage(), PHP_EOL;
}
?>
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**\Swagger\Client\Model\DataProvider[]**](../Model/DataProvider.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/xml

[[Back to top]](#) [[Back to API list]](../../README.md#documentation-for-api-endpoints) [[Back to Model list]](../../README.md#documentation-for-models) [[Back to README]](../../README.md)

# **dataProvidersIdBrowseGet**
> dataProvidersIdBrowseGet($id)

List the files on a Data Provider.

This method allows the inspection of what files are present on a Data Provider specified by the ID parameter. Files that are not yet registered as Userfiles are visible using this method, as well as regularly accessible Userfiles.

### Example
```php
<?php
require_once(__DIR__ . '/vendor/autoload.php');

$api_instance = new Swagger\Client\Api\DataProvidersApi();
$id = 789; // int | The ID of the Data Provider to browse.

try {
    $api_instance->dataProvidersIdBrowseGet($id);
} catch (Exception $e) {
    echo 'Exception when calling DataProvidersApi->dataProvidersIdBrowseGet: ', $e->getMessage(), PHP_EOL;
}
?>
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**| The ID of the Data Provider to browse. |

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/xml

[[Back to top]](#) [[Back to API list]](../../README.md#documentation-for-api-endpoints) [[Back to Model list]](../../README.md#documentation-for-models) [[Back to README]](../../README.md)

# **dataProvidersIdDeletePost**
> dataProvidersIdDeletePost($id, $params)

Deletes unregistered files from a CBRAIN Data provider.

This method allows files that have not been registered from CBRAIN to be deleted. This may be necessary if files were uploaded in error, or if they were unregistered but not immediately deleted.

### Example
```php
<?php
require_once(__DIR__ . '/vendor/autoload.php');

$api_instance = new Swagger\Client\Api\DataProvidersApi();
$id = 789; // int | The ID of the Data Provider to delete files from.
$params = new \Swagger\Client\Model\Params6(); // \Swagger\Client\Model\Params6 | The params

try {
    $api_instance->dataProvidersIdDeletePost($id, $params);
} catch (Exception $e) {
    echo 'Exception when calling DataProvidersApi->dataProvidersIdDeletePost: ', $e->getMessage(), PHP_EOL;
}
?>
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**| The ID of the Data Provider to delete files from. |
 **params** | [**\Swagger\Client\Model\Params6**](../Model/\Swagger\Client\Model\Params6.md)| The params | [optional]

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/xml

[[Back to top]](#) [[Back to API list]](../../README.md#documentation-for-api-endpoints) [[Back to Model list]](../../README.md#documentation-for-models) [[Back to README]](../../README.md)

# **dataProvidersIdGet**
> \Swagger\Client\Model\DataProvider dataProvidersIdGet($id)

Get information on a particular Data Provider.

This method returns a single Data Provider specified by the ID parameter

### Example
```php
<?php
require_once(__DIR__ . '/vendor/autoload.php');

$api_instance = new Swagger\Client\Api\DataProvidersApi();
$id = 789; // int | ID of the Data Provider to get information on.

try {
    $result = $api_instance->dataProvidersIdGet($id);
    print_r($result);
} catch (Exception $e) {
    echo 'Exception when calling DataProvidersApi->dataProvidersIdGet: ', $e->getMessage(), PHP_EOL;
}
?>
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**| ID of the Data Provider to get information on. |

### Return type

[**\Swagger\Client\Model\DataProvider**](../Model/DataProvider.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/xml

[[Back to top]](#) [[Back to API list]](../../README.md#documentation-for-api-endpoints) [[Back to Model list]](../../README.md#documentation-for-models) [[Back to README]](../../README.md)

# **dataProvidersIdIsAliveGet**
> string dataProvidersIdIsAliveGet($id)

Pings a Data Provider to check if it's running.

This method allows the querying of a Data Provider specified by the ID parameter to see if it's running or not.

### Example
```php
<?php
require_once(__DIR__ . '/vendor/autoload.php');

$api_instance = new Swagger\Client\Api\DataProvidersApi();
$id = 789; // int | The ID of the Data Provider to query.

try {
    $result = $api_instance->dataProvidersIdIsAliveGet($id);
    print_r($result);
} catch (Exception $e) {
    echo 'Exception when calling DataProvidersApi->dataProvidersIdIsAliveGet: ', $e->getMessage(), PHP_EOL;
}
?>
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**| The ID of the Data Provider to query. |

### Return type

**string**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/xml

[[Back to top]](#) [[Back to API list]](../../README.md#documentation-for-api-endpoints) [[Back to Model list]](../../README.md#documentation-for-models) [[Back to README]](../../README.md)

# **dataProvidersIdRegisterPost**
> dataProvidersIdRegisterPost($id, $params)

Registers a file as a Userfile in CBRAIN.

This method allows new files to be added to CBRAIN. The files must first be transfered to the Data Provider via SFTP. For more information on SFTP file transfers, consult the CBRAIN Wiki documentation. Once files are present on the Data Provider, this method registers them in CBRAIN by specifying the file type. You can also specify to copy/move the files to another Data Provider after file registration.

### Example
```php
<?php
require_once(__DIR__ . '/vendor/autoload.php');

$api_instance = new Swagger\Client\Api\DataProvidersApi();
$id = 789; // int | The ID of the Data Provider to register files on.
$params = new \Swagger\Client\Model\Params4(); // \Swagger\Client\Model\Params4 | 

try {
    $api_instance->dataProvidersIdRegisterPost($id, $params);
} catch (Exception $e) {
    echo 'Exception when calling DataProvidersApi->dataProvidersIdRegisterPost: ', $e->getMessage(), PHP_EOL;
}
?>
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**| The ID of the Data Provider to register files on. |
 **params** | [**\Swagger\Client\Model\Params4**](../Model/\Swagger\Client\Model\Params4.md)|  |

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/xml

[[Back to top]](#) [[Back to API list]](../../README.md#documentation-for-api-endpoints) [[Back to Model list]](../../README.md#documentation-for-models) [[Back to README]](../../README.md)

# **dataProvidersIdUnregisterPost**
> dataProvidersIdUnregisterPost($id, $params)

Unregisters files as Userfile in CBRAIN.

This method allows files to be unregistered from CBRAIN. This will not delete the files, but removes them from the CBRAIN database, so Tools may no longer be run on them.

### Example
```php
<?php
require_once(__DIR__ . '/vendor/autoload.php');

$api_instance = new Swagger\Client\Api\DataProvidersApi();
$id = 789; // int | The ID of the Data Provider to unregister files from.
$params = new \Swagger\Client\Model\Params5(); // \Swagger\Client\Model\Params5 | The params

try {
    $api_instance->dataProvidersIdUnregisterPost($id, $params);
} catch (Exception $e) {
    echo 'Exception when calling DataProvidersApi->dataProvidersIdUnregisterPost: ', $e->getMessage(), PHP_EOL;
}
?>
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**| The ID of the Data Provider to unregister files from. |
 **params** | [**\Swagger\Client\Model\Params5**](../Model/\Swagger\Client\Model\Params5.md)| The params | [optional]

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/xml

[[Back to top]](#) [[Back to API list]](../../README.md#documentation-for-api-endpoints) [[Back to Model list]](../../README.md#documentation-for-models) [[Back to README]](../../README.md)

