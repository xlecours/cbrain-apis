# Swagger\Client\UserfilesApi

All URIs are relative to *https://localhost:3000/*

Method | HTTP request | Description
------------- | ------------- | -------------
[**userfilesChangeProviderPost**](UserfilesApi.md#userfilesChangeProviderPost) | **POST** /userfiles/change_provider | Moves the Userfiles from their current Data Provider to a new one.
[**userfilesCompressPost**](UserfilesApi.md#userfilesCompressPost) | **POST** /userfiles/compress | Compresses many Userfiles each into their own GZIP archive.
[**userfilesDeleteFilesPost**](UserfilesApi.md#userfilesDeleteFilesPost) | **POST** /userfiles/delete_files | Delete several files that have been registered as Userfiles
[**userfilesDownloadPost**](UserfilesApi.md#userfilesDownloadPost) | **POST** /userfiles/download | Download several files
[**userfilesGet**](UserfilesApi.md#userfilesGet) | **GET** /userfiles | List of the Userfiles accessible to the current user.
[**userfilesIdContentGet**](UserfilesApi.md#userfilesIdContentGet) | **GET** /userfiles/{id}/content | Get the content of a Userfile
[**userfilesIdDelete**](UserfilesApi.md#userfilesIdDelete) | **DELETE** /userfiles/{id} | Delete a Userfile.
[**userfilesIdGet**](UserfilesApi.md#userfilesIdGet) | **GET** /userfiles/{id} | Get information on a Userfile.
[**userfilesIdPut**](UserfilesApi.md#userfilesIdPut) | **PUT** /userfiles/{id} | Update information on a Userfile.
[**userfilesPost**](UserfilesApi.md#userfilesPost) | **POST** /userfiles | Creates a new Userfile.
[**userfilesSyncMultiplePost**](UserfilesApi.md#userfilesSyncMultiplePost) | **POST** /userfiles/sync_multiple | Syncs Userfiles to their Data Providers&#39; cache.
[**userfilesUncompressPost**](UserfilesApi.md#userfilesUncompressPost) | **POST** /userfiles/uncompress | Uncompresses many Userfiles.


# **userfilesChangeProviderPost**
> userfilesChangeProviderPost($params)

Moves the Userfiles from their current Data Provider to a new one.

### Example
```php
<?php
require_once(__DIR__ . '/vendor/autoload.php');

$api_instance = new Swagger\Client\Api\UserfilesApi();
$params = new \Swagger\Client\Model\Params15(); // \Swagger\Client\Model\Params15 | The params

try {
    $api_instance->userfilesChangeProviderPost($params);
} catch (Exception $e) {
    echo 'Exception when calling UserfilesApi->userfilesChangeProviderPost: ', $e->getMessage(), PHP_EOL;
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

# **userfilesCompressPost**
> userfilesCompressPost($params)

Compresses many Userfiles each into their own GZIP archive.

### Example
```php
<?php
require_once(__DIR__ . '/vendor/autoload.php');

$api_instance = new Swagger\Client\Api\UserfilesApi();
$params = new \Swagger\Client\Model\Params16(); // \Swagger\Client\Model\Params16 | The params

try {
    $api_instance->userfilesCompressPost($params);
} catch (Exception $e) {
    echo 'Exception when calling UserfilesApi->userfilesCompressPost: ', $e->getMessage(), PHP_EOL;
}
?>
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **params** | [**\Swagger\Client\Model\Params16**](../Model/\Swagger\Client\Model\Params16.md)| The params | [optional]

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/xml

[[Back to top]](#) [[Back to API list]](../../README.md#documentation-for-api-endpoints) [[Back to Model list]](../../README.md#documentation-for-models) [[Back to README]](../../README.md)

# **userfilesDeleteFilesPost**
> userfilesDeleteFilesPost($params)

Delete several files that have been registered as Userfiles

### Example
```php
<?php
require_once(__DIR__ . '/vendor/autoload.php');

$api_instance = new Swagger\Client\Api\UserfilesApi();
$params = new \Swagger\Client\Model\Params14(); // \Swagger\Client\Model\Params14 | The params

try {
    $api_instance->userfilesDeleteFilesPost($params);
} catch (Exception $e) {
    echo 'Exception when calling UserfilesApi->userfilesDeleteFilesPost: ', $e->getMessage(), PHP_EOL;
}
?>
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **params** | [**\Swagger\Client\Model\Params14**](../Model/\Swagger\Client\Model\Params14.md)| The params | [optional]

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/xml

[[Back to top]](#) [[Back to API list]](../../README.md#documentation-for-api-endpoints) [[Back to Model list]](../../README.md#documentation-for-models) [[Back to README]](../../README.md)

# **userfilesDownloadPost**
> userfilesDownloadPost($params)

Download several files

This method compresses several Userfiles in .gz format and prepares them to be downloaded.

### Example
```php
<?php
require_once(__DIR__ . '/vendor/autoload.php');

$api_instance = new Swagger\Client\Api\UserfilesApi();
$params = new \Swagger\Client\Model\Params13(); // \Swagger\Client\Model\Params13 | The params

try {
    $api_instance->userfilesDownloadPost($params);
} catch (Exception $e) {
    echo 'Exception when calling UserfilesApi->userfilesDownloadPost: ', $e->getMessage(), PHP_EOL;
}
?>
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **params** | [**\Swagger\Client\Model\Params13**](../Model/\Swagger\Client\Model\Params13.md)| The params | [optional]

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/xml

[[Back to top]](#) [[Back to API list]](../../README.md#documentation-for-api-endpoints) [[Back to Model list]](../../README.md#documentation-for-models) [[Back to README]](../../README.md)

# **userfilesGet**
> \Swagger\Client\Model\Userfile[] userfilesGet()

List of the Userfiles accessible to the current user.

This method returns a list of Userfiles that are available to the current User.

### Example
```php
<?php
require_once(__DIR__ . '/vendor/autoload.php');

$api_instance = new Swagger\Client\Api\UserfilesApi();

try {
    $result = $api_instance->userfilesGet();
    print_r($result);
} catch (Exception $e) {
    echo 'Exception when calling UserfilesApi->userfilesGet: ', $e->getMessage(), PHP_EOL;
}
?>
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**\Swagger\Client\Model\Userfile[]**](../Model/Userfile.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/xml

[[Back to top]](#) [[Back to API list]](../../README.md#documentation-for-api-endpoints) [[Back to Model list]](../../README.md#documentation-for-models) [[Back to README]](../../README.md)

# **userfilesIdContentGet**
> userfilesIdContentGet($id)

Get the content of a Userfile

This method allows you to download Userfiles.

### Example
```php
<?php
require_once(__DIR__ . '/vendor/autoload.php');

$api_instance = new Swagger\Client\Api\UserfilesApi();
$id = 789; // int | The ID number of the Userfile to download

try {
    $api_instance->userfilesIdContentGet($id);
} catch (Exception $e) {
    echo 'Exception when calling UserfilesApi->userfilesIdContentGet: ', $e->getMessage(), PHP_EOL;
}
?>
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**| The ID number of the Userfile to download |

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/xml

[[Back to top]](#) [[Back to API list]](../../README.md#documentation-for-api-endpoints) [[Back to Model list]](../../README.md#documentation-for-models) [[Back to README]](../../README.md)

# **userfilesIdDelete**
> userfilesIdDelete($id, $params)

Delete a Userfile.

This method allows a User to delete a Userfile.

### Example
```php
<?php
require_once(__DIR__ . '/vendor/autoload.php');

$api_instance = new Swagger\Client\Api\UserfilesApi();
$id = 789; // int | The ID number of the Userfile to delete.
$params = new \Swagger\Client\Model\Params12(); // \Swagger\Client\Model\Params12 | The params

try {
    $api_instance->userfilesIdDelete($id, $params);
} catch (Exception $e) {
    echo 'Exception when calling UserfilesApi->userfilesIdDelete: ', $e->getMessage(), PHP_EOL;
}
?>
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**| The ID number of the Userfile to delete. |
 **params** | [**\Swagger\Client\Model\Params12**](../Model/\Swagger\Client\Model\Params12.md)| The params | [optional]

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/xml

[[Back to top]](#) [[Back to API list]](../../README.md#documentation-for-api-endpoints) [[Back to Model list]](../../README.md#documentation-for-models) [[Back to README]](../../README.md)

# **userfilesIdGet**
> \Swagger\Client\Model\Userfile userfilesIdGet($id)

Get information on a Userfile.

This method returns information about a single Userfile, specified by its ID. Information returned includes the ID of the owner, the Group (project) it is a part of, a description, information about where the acutal copy of the file currently is, and what the status is of any synhronization operations that may have been requested.

### Example
```php
<?php
require_once(__DIR__ . '/vendor/autoload.php');

$api_instance = new Swagger\Client\Api\UserfilesApi();
$id = 789; // int | The ID number of the Userfile to get information on.

try {
    $result = $api_instance->userfilesIdGet($id);
    print_r($result);
} catch (Exception $e) {
    echo 'Exception when calling UserfilesApi->userfilesIdGet: ', $e->getMessage(), PHP_EOL;
}
?>
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**| The ID number of the Userfile to get information on. |

### Return type

[**\Swagger\Client\Model\Userfile**](../Model/Userfile.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/xml

[[Back to top]](#) [[Back to API list]](../../README.md#documentation-for-api-endpoints) [[Back to Model list]](../../README.md#documentation-for-models) [[Back to README]](../../README.md)

# **userfilesIdPut**
> userfilesIdPut($id, $params)

Update information on a Userfile.

This method allows a User to update information on a userfile.

### Example
```php
<?php
require_once(__DIR__ . '/vendor/autoload.php');

$api_instance = new Swagger\Client\Api\UserfilesApi();
$id = 789; // int | The ID number of the Userfile to update.
$params = new \Swagger\Client\Model\Params11(); // \Swagger\Client\Model\Params11 | The params

try {
    $api_instance->userfilesIdPut($id, $params);
} catch (Exception $e) {
    echo 'Exception when calling UserfilesApi->userfilesIdPut: ', $e->getMessage(), PHP_EOL;
}
?>
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**| The ID number of the Userfile to update. |
 **params** | [**\Swagger\Client\Model\Params11**](../Model/\Swagger\Client\Model\Params11.md)| The params | [optional]

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/xml

[[Back to top]](#) [[Back to API list]](../../README.md#documentation-for-api-endpoints) [[Back to Model list]](../../README.md#documentation-for-models) [[Back to README]](../../README.md)

# **userfilesPost**
> userfilesPost($upload_file, $data_provider_id, $userfile_group_id, $file_type, $archive, $authenticity_token, $_up_ex_mode)

Creates a new Userfile.

This method creates a new Userfile in CBRAIN, with the current user as the owner of the file.

### Example
```php
<?php
require_once(__DIR__ . '/vendor/autoload.php');

$api_instance = new Swagger\Client\Api\UserfilesApi();
$upload_file = "/path/to/file.txt"; // \SplFileObject | File to upload to CBRAIN
$data_provider_id = 789; // int | The ID of the Data Provider to upload the file to.
$userfile_group_id = 56; // int | ID of the group that will have access to the Userfile
$file_type = "file_type_example"; // string | The type of the file
$archive = "archive_example"; // string | Archive
$authenticity_token = "authenticity_token_example"; // string | The token returned by /session/new
$_up_ex_mode = "_up_ex_mode_example"; // string | usually \"collection\"

try {
    $api_instance->userfilesPost($upload_file, $data_provider_id, $userfile_group_id, $file_type, $archive, $authenticity_token, $_up_ex_mode);
} catch (Exception $e) {
    echo 'Exception when calling UserfilesApi->userfilesPost: ', $e->getMessage(), PHP_EOL;
}
?>
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **upload_file** | **\SplFileObject**| File to upload to CBRAIN | [optional]
 **data_provider_id** | **int**| The ID of the Data Provider to upload the file to. | [optional]
 **userfile_group_id** | **int**| ID of the group that will have access to the Userfile | [optional]
 **file_type** | **string**| The type of the file | [optional]
 **archive** | **string**| Archive | [optional]
 **authenticity_token** | **string**| The token returned by /session/new | [optional]
 **_up_ex_mode** | **string**| usually \&quot;collection\&quot; | [optional]

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: application/json, application/xml

[[Back to top]](#) [[Back to API list]](../../README.md#documentation-for-api-endpoints) [[Back to Model list]](../../README.md#documentation-for-models) [[Back to README]](../../README.md)

# **userfilesSyncMultiplePost**
> userfilesSyncMultiplePost($params)

Syncs Userfiles to their Data Providers' cache.

Synchronizing files to their Data Providers' caches allows you to download, visualize and do processing on them that is not available if not synced. Most operations will sync files automatically.

### Example
```php
<?php
require_once(__DIR__ . '/vendor/autoload.php');

$api_instance = new Swagger\Client\Api\UserfilesApi();
$params = new \Swagger\Client\Model\Params18(); // \Swagger\Client\Model\Params18 | The params

try {
    $api_instance->userfilesSyncMultiplePost($params);
} catch (Exception $e) {
    echo 'Exception when calling UserfilesApi->userfilesSyncMultiplePost: ', $e->getMessage(), PHP_EOL;
}
?>
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **params** | [**\Swagger\Client\Model\Params18**](../Model/\Swagger\Client\Model\Params18.md)| The params | [optional]

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/xml

[[Back to top]](#) [[Back to API list]](../../README.md#documentation-for-api-endpoints) [[Back to Model list]](../../README.md#documentation-for-models) [[Back to README]](../../README.md)

# **userfilesUncompressPost**
> userfilesUncompressPost($params)

Uncompresses many Userfiles.

### Example
```php
<?php
require_once(__DIR__ . '/vendor/autoload.php');

$api_instance = new Swagger\Client\Api\UserfilesApi();
$params = new \Swagger\Client\Model\Params17(); // \Swagger\Client\Model\Params17 | The params

try {
    $api_instance->userfilesUncompressPost($params);
} catch (Exception $e) {
    echo 'Exception when calling UserfilesApi->userfilesUncompressPost: ', $e->getMessage(), PHP_EOL;
}
?>
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **params** | [**\Swagger\Client\Model\Params17**](../Model/\Swagger\Client\Model\Params17.md)| The params | [optional]

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/xml

[[Back to top]](#) [[Back to API list]](../../README.md#documentation-for-api-endpoints) [[Back to Model list]](../../README.md#documentation-for-models) [[Back to README]](../../README.md)

