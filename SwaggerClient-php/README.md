# SwaggerClient-php
Interface to control CBRAIN operations

This PHP package is automatically generated by the [Swagger Codegen](https://github.com/swagger-api/swagger-codegen) project:

- API version: 4.5.1
- Build package: io.swagger.codegen.languages.PhpClientCodegen

## Requirements

PHP 5.4.0 and later

## Installation & Usage
### Composer

To install the bindings via [Composer](http://getcomposer.org/), add the following to `composer.json`:

```
{
  "repositories": [
    {
      "type": "git",
      "url": "https://github.com//.git"
    }
  ],
  "require": {
    "/": "*@dev"
  }
}
```

Then run `composer install`

### Manual Installation

Download the files and include `autoload.php`:

```php
    require_once('/path/to/SwaggerClient-php/autoload.php');
```

## Tests

To run the unit tests:

```
composer install
./vendor/bin/phpunit
```

## Getting Started

Please follow the [installation procedure](#installation--usage) and then run the following:

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

## Documentation for API Endpoints

All URIs are relative to *https://localhost:3000/*

Class | Method | HTTP request | Description
------------ | ------------- | ------------- | -------------
*BourreauApi* | [**bourreauxGet**](docs/Api/BourreauApi.md#bourreauxget) | **GET** /bourreaux | Get a list of the Bourreaux available to be used by the current user.
*BourreauApi* | [**bourreauxIdGet**](docs/Api/BourreauApi.md#bourreauxidget) | **GET** /bourreaux/{id} | Get information about a Bourreau.
*DataProviderApi* | [**userfilesChangeProviderPost**](docs/Api/DataProviderApi.md#userfileschangeproviderpost) | **POST** /userfiles/change_provider | Moves the Userfiles from their current Data Provider to a new one.
*DataProvidersApi* | [**dataProvidersGet**](docs/Api/DataProvidersApi.md#dataprovidersget) | **GET** /data_providers | Get a list of the Data Providers available to the current user.
*DataProvidersApi* | [**dataProvidersIdBrowseGet**](docs/Api/DataProvidersApi.md#dataprovidersidbrowseget) | **GET** /data_providers/{id}/browse | List the files on a Data Provider.
*DataProvidersApi* | [**dataProvidersIdDeletePost**](docs/Api/DataProvidersApi.md#dataprovidersiddeletepost) | **POST** /data_providers/{id}/delete | Deletes unregistered files from a CBRAIN Data provider.
*DataProvidersApi* | [**dataProvidersIdGet**](docs/Api/DataProvidersApi.md#dataprovidersidget) | **GET** /data_providers/{id} | Get information on a particular Data Provider.
*DataProvidersApi* | [**dataProvidersIdIsAliveGet**](docs/Api/DataProvidersApi.md#dataprovidersidisaliveget) | **GET** /data_providers/{id}/is_alive | Pings a Data Provider to check if it&#39;s running.
*DataProvidersApi* | [**dataProvidersIdRegisterPost**](docs/Api/DataProvidersApi.md#dataprovidersidregisterpost) | **POST** /data_providers/{id}/register | Registers a file as a Userfile in CBRAIN.
*DataProvidersApi* | [**dataProvidersIdUnregisterPost**](docs/Api/DataProvidersApi.md#dataprovidersidunregisterpost) | **POST** /data_providers/{id}/unregister | Unregisters files as Userfile in CBRAIN.
*GroupsApi* | [**groupsGet**](docs/Api/GroupsApi.md#groupsget) | **GET** /groups | Get a list of the Groups (projects) available to the current user.
*GroupsApi* | [**groupsIdDelete**](docs/Api/GroupsApi.md#groupsiddelete) | **DELETE** /groups/{id} | Deletes a Group (project).
*GroupsApi* | [**groupsIdGet**](docs/Api/GroupsApi.md#groupsidget) | **GET** /groups/{id} | Get information on a Group (project).
*GroupsApi* | [**groupsIdPut**](docs/Api/GroupsApi.md#groupsidput) | **PUT** /groups/{id} | Update the properties of a Group (project).
*GroupsApi* | [**groupsPost**](docs/Api/GroupsApi.md#groupspost) | **POST** /groups | Creates a new Group.
*GroupsApi* | [**groupsSwitchPost**](docs/Api/GroupsApi.md#groupsswitchpost) | **POST** /groups/switch | Switches the active group.
*SessionsApi* | [**sessionDelete**](docs/Api/SessionsApi.md#sessiondelete) | **DELETE** /session | Destroy the session
*SessionsApi* | [**sessionGet**](docs/Api/SessionsApi.md#sessionget) | **GET** /session | Get session information
*SessionsApi* | [**sessionNewGet**](docs/Api/SessionsApi.md#sessionnewget) | **GET** /session/new | New session initiator
*SessionsApi* | [**sessionPost**](docs/Api/SessionsApi.md#sessionpost) | **POST** /session | Create a new session
*TagsApi* | [**tagsGet**](docs/Api/TagsApi.md#tagsget) | **GET** /tags | Get a list of the tags currently in CBRAIN.
*TagsApi* | [**tagsIdDelete**](docs/Api/TagsApi.md#tagsiddelete) | **DELETE** /tags/{id} | Delete a tag.
*TagsApi* | [**tagsIdGet**](docs/Api/TagsApi.md#tagsidget) | **GET** /tags/{id} | Get one tag.
*TagsApi* | [**tagsIdPut**](docs/Api/TagsApi.md#tagsidput) | **PUT** /tags/{id} | Update a tag.
*TagsApi* | [**tagsPost**](docs/Api/TagsApi.md#tagspost) | **POST** /tags | Create a tag.
*TasksApi* | [**tasksGet**](docs/Api/TasksApi.md#tasksget) | **GET** /tasks | Get the list of Tasks.
*TasksApi* | [**tasksIdDelete**](docs/Api/TasksApi.md#tasksiddelete) | **DELETE** /tasks/{id} | Deletes a Task
*TasksApi* | [**tasksIdGet**](docs/Api/TasksApi.md#tasksidget) | **GET** /tasks/{id} | Get information on a Task.
*TasksApi* | [**tasksIdPut**](docs/Api/TasksApi.md#tasksidput) | **PUT** /tasks/{id} | Update information on a Task.
*TasksApi* | [**tasksPost**](docs/Api/TasksApi.md#taskspost) | **POST** /tasks | Create a new Task.
*ToolConfigsApi* | [**toolConfigsGet**](docs/Api/ToolConfigsApi.md#toolconfigsget) | **GET** /tool_configs | Get a list of tool versions installed.
*ToolConfigsApi* | [**toolConfigsIdGet**](docs/Api/ToolConfigsApi.md#toolconfigsidget) | **GET** /tool_configs/{id} | Get information about a particular tool configuration
*ToolsApi* | [**toolsGet**](docs/Api/ToolsApi.md#toolsget) | **GET** /tools | Get the list of Tools.
*UserfilesApi* | [**userfilesChangeProviderPost**](docs/Api/UserfilesApi.md#userfileschangeproviderpost) | **POST** /userfiles/change_provider | Moves the Userfiles from their current Data Provider to a new one.
*UserfilesApi* | [**userfilesCompressPost**](docs/Api/UserfilesApi.md#userfilescompresspost) | **POST** /userfiles/compress | Compresses many Userfiles each into their own GZIP archive.
*UserfilesApi* | [**userfilesDeleteFilesPost**](docs/Api/UserfilesApi.md#userfilesdeletefilespost) | **POST** /userfiles/delete_files | Delete several files that have been registered as Userfiles
*UserfilesApi* | [**userfilesDownloadPost**](docs/Api/UserfilesApi.md#userfilesdownloadpost) | **POST** /userfiles/download | Download several files
*UserfilesApi* | [**userfilesGet**](docs/Api/UserfilesApi.md#userfilesget) | **GET** /userfiles | List of the Userfiles accessible to the current user.
*UserfilesApi* | [**userfilesIdContentGet**](docs/Api/UserfilesApi.md#userfilesidcontentget) | **GET** /userfiles/{id}/content | Get the content of a Userfile
*UserfilesApi* | [**userfilesIdDelete**](docs/Api/UserfilesApi.md#userfilesiddelete) | **DELETE** /userfiles/{id} | Delete a Userfile.
*UserfilesApi* | [**userfilesIdGet**](docs/Api/UserfilesApi.md#userfilesidget) | **GET** /userfiles/{id} | Get information on a Userfile.
*UserfilesApi* | [**userfilesIdPut**](docs/Api/UserfilesApi.md#userfilesidput) | **PUT** /userfiles/{id} | Update information on a Userfile.
*UserfilesApi* | [**userfilesPost**](docs/Api/UserfilesApi.md#userfilespost) | **POST** /userfiles | Creates a new Userfile.
*UserfilesApi* | [**userfilesSyncMultiplePost**](docs/Api/UserfilesApi.md#userfilessyncmultiplepost) | **POST** /userfiles/sync_multiple | Syncs Userfiles to their Data Providers&#39; cache.
*UserfilesApi* | [**userfilesUncompressPost**](docs/Api/UserfilesApi.md#userfilesuncompresspost) | **POST** /userfiles/uncompress | Uncompresses many Userfiles.
*UsersApi* | [**usersGet**](docs/Api/UsersApi.md#usersget) | **GET** /users | Returns all of the users in CBRAIN.
*UsersApi* | [**usersIdGet**](docs/Api/UsersApi.md#usersidget) | **GET** /users/{id} | Returns information about a user
*UsersApi* | [**usersPost**](docs/Api/UsersApi.md#userspost) | **POST** /users | Create a new user in CBRAIN.


## Documentation For Models

 - [Bourreau](docs/Model/Bourreau.md)
 - [CbrainTask](docs/Model/CbrainTask.md)
 - [DataProvider](docs/Model/DataProvider.md)
 - [Group](docs/Model/Group.md)
 - [InlineResponse200](docs/Model/InlineResponse200.md)
 - [InlineResponse2001](docs/Model/InlineResponse2001.md)
 - [InlineResponse2002](docs/Model/InlineResponse2002.md)
 - [Params](docs/Model/Params.md)
 - [Params1](docs/Model/Params1.md)
 - [Params10](docs/Model/Params10.md)
 - [Params11](docs/Model/Params11.md)
 - [Params12](docs/Model/Params12.md)
 - [Params13](docs/Model/Params13.md)
 - [Params14](docs/Model/Params14.md)
 - [Params15](docs/Model/Params15.md)
 - [Params16](docs/Model/Params16.md)
 - [Params17](docs/Model/Params17.md)
 - [Params18](docs/Model/Params18.md)
 - [Params19](docs/Model/Params19.md)
 - [Params2](docs/Model/Params2.md)
 - [Params20](docs/Model/Params20.md)
 - [Params21](docs/Model/Params21.md)
 - [Params3](docs/Model/Params3.md)
 - [Params4](docs/Model/Params4.md)
 - [Params5](docs/Model/Params5.md)
 - [Params6](docs/Model/Params6.md)
 - [Params7](docs/Model/Params7.md)
 - [Params8](docs/Model/Params8.md)
 - [Params9](docs/Model/Params9.md)
 - [Tag](docs/Model/Tag.md)
 - [Tool](docs/Model/Tool.md)
 - [ToolConfig](docs/Model/ToolConfig.md)
 - [User](docs/Model/User.md)
 - [Userfile](docs/Model/Userfile.md)


## Documentation For Authorization

 All endpoints do not require authorization.


## Author



