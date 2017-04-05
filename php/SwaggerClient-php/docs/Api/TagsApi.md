# Swagger\Client\TagsApi

All URIs are relative to *https://localhost:3000/*

Method | HTTP request | Description
------------- | ------------- | -------------
[**tagsGet**](TagsApi.md#tagsGet) | **GET** /tags | Get a list of the tags currently in CBRAIN.
[**tagsIdDelete**](TagsApi.md#tagsIdDelete) | **DELETE** /tags/{id} | Delete a tag.
[**tagsIdGet**](TagsApi.md#tagsIdGet) | **GET** /tags/{id} | Get one tag.
[**tagsIdPut**](TagsApi.md#tagsIdPut) | **PUT** /tags/{id} | Update a tag.
[**tagsPost**](TagsApi.md#tagsPost) | **POST** /tags | Create a tag.


# **tagsGet**
> \Swagger\Client\Model\Tag[] tagsGet()

Get a list of the tags currently in CBRAIN.

This method returns a list of tag objects.

### Example
```php
<?php
require_once(__DIR__ . '/vendor/autoload.php');

$api_instance = new Swagger\Client\Api\TagsApi();

try {
    $result = $api_instance->tagsGet();
    print_r($result);
} catch (Exception $e) {
    echo 'Exception when calling TagsApi->tagsGet: ', $e->getMessage(), PHP_EOL;
}
?>
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**\Swagger\Client\Model\Tag[]**](../Model/Tag.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/xml

[[Back to top]](#) [[Back to API list]](../../README.md#documentation-for-api-endpoints) [[Back to Model list]](../../README.md#documentation-for-models) [[Back to README]](../../README.md)

# **tagsIdDelete**
> tagsIdDelete($id, $params)

Delete a tag.

Delete the tag specified by the ID parameter.

### Example
```php
<?php
require_once(__DIR__ . '/vendor/autoload.php');

$api_instance = new Swagger\Client\Api\TagsApi();
$id = 789; // int | ID of the tag to delete.
$params = new \Swagger\Client\Model\Params3(); // \Swagger\Client\Model\Params3 | 

try {
    $api_instance->tagsIdDelete($id, $params);
} catch (Exception $e) {
    echo 'Exception when calling TagsApi->tagsIdDelete: ', $e->getMessage(), PHP_EOL;
}
?>
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**| ID of the tag to delete. |
 **params** | [**\Swagger\Client\Model\Params3**](../Model/\Swagger\Client\Model\Params3.md)|  | [optional]

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/xml

[[Back to top]](#) [[Back to API list]](../../README.md#documentation-for-api-endpoints) [[Back to Model list]](../../README.md#documentation-for-models) [[Back to README]](../../README.md)

# **tagsIdGet**
> \Swagger\Client\Model\Tag tagsIdGet($id)

Get one tag.

Returns a single tag with the ID specified.

### Example
```php
<?php
require_once(__DIR__ . '/vendor/autoload.php');

$api_instance = new Swagger\Client\Api\TagsApi();
$id = 789; // int | The ID of the tag to get.

try {
    $result = $api_instance->tagsIdGet($id);
    print_r($result);
} catch (Exception $e) {
    echo 'Exception when calling TagsApi->tagsIdGet: ', $e->getMessage(), PHP_EOL;
}
?>
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**| The ID of the tag to get. |

### Return type

[**\Swagger\Client\Model\Tag**](../Model/Tag.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/xml

[[Back to top]](#) [[Back to API list]](../../README.md#documentation-for-api-endpoints) [[Back to Model list]](../../README.md#documentation-for-models) [[Back to README]](../../README.md)

# **tagsIdPut**
> tagsIdPut($id, $params)

Update a tag.

Update the tag specified by the ID parameter.

### Example
```php
<?php
require_once(__DIR__ . '/vendor/autoload.php');

$api_instance = new Swagger\Client\Api\TagsApi();
$id = 789; // int | ID of the tag to update.
$params = new \Swagger\Client\Model\Params2(); // \Swagger\Client\Model\Params2 | The params

try {
    $api_instance->tagsIdPut($id, $params);
} catch (Exception $e) {
    echo 'Exception when calling TagsApi->tagsIdPut: ', $e->getMessage(), PHP_EOL;
}
?>
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**| ID of the tag to update. |
 **params** | [**\Swagger\Client\Model\Params2**](../Model/\Swagger\Client\Model\Params2.md)| The params | [optional]

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/xml

[[Back to top]](#) [[Back to API list]](../../README.md#documentation-for-api-endpoints) [[Back to Model list]](../../README.md#documentation-for-models) [[Back to README]](../../README.md)

# **tagsPost**
> \Swagger\Client\Model\Tag tagsPost($params)

Create a tag.

Create a new tag in CBRAIN.

### Example
```php
<?php
require_once(__DIR__ . '/vendor/autoload.php');

$api_instance = new Swagger\Client\Api\TagsApi();
$params = new \Swagger\Client\Model\Params1(); // \Swagger\Client\Model\Params1 | The params

try {
    $result = $api_instance->tagsPost($params);
    print_r($result);
} catch (Exception $e) {
    echo 'Exception when calling TagsApi->tagsPost: ', $e->getMessage(), PHP_EOL;
}
?>
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **params** | [**\Swagger\Client\Model\Params1**](../Model/\Swagger\Client\Model\Params1.md)| The params | [optional]

### Return type

[**\Swagger\Client\Model\Tag**](../Model/Tag.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/xml

[[Back to top]](#) [[Back to API list]](../../README.md#documentation-for-api-endpoints) [[Back to Model list]](../../README.md#documentation-for-models) [[Back to README]](../../README.md)

