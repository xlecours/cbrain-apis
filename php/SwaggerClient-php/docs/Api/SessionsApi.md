# Swagger\Client\SessionsApi

All URIs are relative to *https://localhost:3000/*

Method | HTTP request | Description
------------- | ------------- | -------------
[**sessionDelete**](SessionsApi.md#sessionDelete) | **DELETE** /session | Destroy the session
[**sessionGet**](SessionsApi.md#sessionGet) | **GET** /session | Get session information
[**sessionNewGet**](SessionsApi.md#sessionNewGet) | **GET** /session/new | New session initiator
[**sessionPost**](SessionsApi.md#sessionPost) | **POST** /session | Create a new session


# **sessionDelete**
> sessionDelete()

Destroy the session

This destroys the current session, effectively terminating the API's access to the service.

### Example
```php
<?php
require_once(__DIR__ . '/vendor/autoload.php');

$api_instance = new Swagger\Client\Api\SessionsApi();

try {
    $api_instance->sessionDelete();
} catch (Exception $e) {
    echo 'Exception when calling SessionsApi->sessionDelete: ', $e->getMessage(), PHP_EOL;
}
?>
```

### Parameters
This endpoint does not need any parameter.

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/xml

[[Back to top]](#) [[Back to API list]](../../README.md#documentation-for-api-endpoints) [[Back to Model list]](../../README.md#documentation-for-models) [[Back to README]](../../README.md)

# **sessionGet**
> \Swagger\Client\Model\InlineResponse2001 sessionGet()

Get session information

This returns information about the current session.

### Example
```php
<?php
require_once(__DIR__ . '/vendor/autoload.php');

$api_instance = new Swagger\Client\Api\SessionsApi();

try {
    $result = $api_instance->sessionGet();
    print_r($result);
} catch (Exception $e) {
    echo 'Exception when calling SessionsApi->sessionGet: ', $e->getMessage(), PHP_EOL;
}
?>
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**\Swagger\Client\Model\InlineResponse2001**](../Model/InlineResponse2001.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/xml

[[Back to top]](#) [[Back to API list]](../../README.md#documentation-for-api-endpoints) [[Back to Model list]](../../README.md#documentation-for-models) [[Back to README]](../../README.md)

# **sessionNewGet**
> \Swagger\Client\Model\InlineResponse200 sessionNewGet()

New session initiator

This returns an object with the information necessary to create a new session.

### Example
```php
<?php
require_once(__DIR__ . '/vendor/autoload.php');

$api_instance = new Swagger\Client\Api\SessionsApi();

try {
    $result = $api_instance->sessionNewGet();
    print_r($result);
} catch (Exception $e) {
    echo 'Exception when calling SessionsApi->sessionNewGet: ', $e->getMessage(), PHP_EOL;
}
?>
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**\Swagger\Client\Model\InlineResponse200**](../Model/InlineResponse200.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/xml

[[Back to top]](#) [[Back to API list]](../../README.md#documentation-for-api-endpoints) [[Back to Model list]](../../README.md#documentation-for-models) [[Back to README]](../../README.md)

# **sessionPost**
> \Swagger\Client\Model\InlineResponse2002 sessionPost($login, $password, $authenticity_token)

Create a new session

This is the main entry point to create a CBRAIN session. Note that if a user is currently logged in, a new session will not be available to be created, and the current session will be re-used.

### Example
```php
<?php
require_once(__DIR__ . '/vendor/autoload.php');

$api_instance = new Swagger\Client\Api\SessionsApi();
$login = "login_example"; // string | The username of the User trying to connect.
$password = "password_example"; // string | The CBRAIN User's password
$authenticity_token = "authenticity_token_example"; // string | The token returned by /session/new

try {
    $result = $api_instance->sessionPost($login, $password, $authenticity_token);
    print_r($result);
} catch (Exception $e) {
    echo 'Exception when calling SessionsApi->sessionPost: ', $e->getMessage(), PHP_EOL;
}
?>
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **login** | **string**| The username of the User trying to connect. | [optional]
 **password** | **string**| The CBRAIN User&#39;s password | [optional]
 **authenticity_token** | **string**| The token returned by /session/new | [optional]

### Return type

[**\Swagger\Client\Model\InlineResponse2002**](../Model/InlineResponse2002.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: application/json, application/xml

[[Back to top]](#) [[Back to API list]](../../README.md#documentation-for-api-endpoints) [[Back to Model list]](../../README.md#documentation-for-models) [[Back to README]](../../README.md)

