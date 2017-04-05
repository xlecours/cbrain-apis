<?php
/**
 * ToolConfig
 *
 * PHP version 5
 *
 * @category Class
 * @package  Swagger\Client
 * @author   Swaagger Codegen team
 * @link     https://github.com/swagger-api/swagger-codegen
 */

/**
 * CBRAIN API
 *
 * Interface to control CBRAIN operations
 *
 * OpenAPI spec version: 4.5.1
 * 
 * Generated by: https://github.com/swagger-api/swagger-codegen.git
 *
 */

/**
 * NOTE: This class is auto generated by the swagger code generator program.
 * https://github.com/swagger-api/swagger-codegen
 * Do not edit the class manually.
 */

namespace Swagger\Client\Model;

use \ArrayAccess;

/**
 * ToolConfig Class Doc Comment
 *
 * @category    Class
 * @package     Swagger\Client
 * @author      Swagger Codegen team
 * @link        https://github.com/swagger-api/swagger-codegen
 */
class ToolConfig implements ArrayAccess
{
    const DISCRIMINATOR = null;

    /**
      * The original name of the model.
      * @var string
      */
    protected static $swaggerModelName = 'ToolConfig';

    /**
      * Array of property to type mappings. Used for (de)serialization
      * @var string[]
      */
    protected static $swaggerTypes = [
        'id' => 'float',
        'version_name' => 'string',
        'description' => 'string',
        'tool_id' => 'float',
        'bourreau_id' => 'float',
        'env_array' => 'string[]',
        'script_prologue' => 'string',
        'group_id' => 'float',
        'ncpus' => 'float'
    ];

    public static function swaggerTypes()
    {
        return self::$swaggerTypes;
    }

    /**
     * Array of attributes where the key is the local name, and the value is the original name
     * @var string[]
     */
    protected static $attributeMap = [
        'id' => 'id',
        'version_name' => 'version_name',
        'description' => 'description',
        'tool_id' => 'tool_id',
        'bourreau_id' => 'bourreau_id',
        'env_array' => 'env_array',
        'script_prologue' => 'script_prologue',
        'group_id' => 'group_id',
        'ncpus' => 'ncpus'
    ];


    /**
     * Array of attributes to setter functions (for deserialization of responses)
     * @var string[]
     */
    protected static $setters = [
        'id' => 'setId',
        'version_name' => 'setVersionName',
        'description' => 'setDescription',
        'tool_id' => 'setToolId',
        'bourreau_id' => 'setBourreauId',
        'env_array' => 'setEnvArray',
        'script_prologue' => 'setScriptPrologue',
        'group_id' => 'setGroupId',
        'ncpus' => 'setNcpus'
    ];


    /**
     * Array of attributes to getter functions (for serialization of requests)
     * @var string[]
     */
    protected static $getters = [
        'id' => 'getId',
        'version_name' => 'getVersionName',
        'description' => 'getDescription',
        'tool_id' => 'getToolId',
        'bourreau_id' => 'getBourreauId',
        'env_array' => 'getEnvArray',
        'script_prologue' => 'getScriptPrologue',
        'group_id' => 'getGroupId',
        'ncpus' => 'getNcpus'
    ];

    public static function attributeMap()
    {
        return self::$attributeMap;
    }

    public static function setters()
    {
        return self::$setters;
    }

    public static function getters()
    {
        return self::$getters;
    }

    

    

    /**
     * Associative array for storing property values
     * @var mixed[]
     */
    protected $container = [];

    /**
     * Constructor
     * @param mixed[] $data Associated array of property values initializing the model
     */
    public function __construct(array $data = null)
    {
        $this->container['id'] = isset($data['id']) ? $data['id'] : null;
        $this->container['version_name'] = isset($data['version_name']) ? $data['version_name'] : null;
        $this->container['description'] = isset($data['description']) ? $data['description'] : null;
        $this->container['tool_id'] = isset($data['tool_id']) ? $data['tool_id'] : null;
        $this->container['bourreau_id'] = isset($data['bourreau_id']) ? $data['bourreau_id'] : null;
        $this->container['env_array'] = isset($data['env_array']) ? $data['env_array'] : null;
        $this->container['script_prologue'] = isset($data['script_prologue']) ? $data['script_prologue'] : null;
        $this->container['group_id'] = isset($data['group_id']) ? $data['group_id'] : null;
        $this->container['ncpus'] = isset($data['ncpus']) ? $data['ncpus'] : null;
    }

    /**
     * show all the invalid properties with reasons.
     *
     * @return array invalid properties with reasons
     */
    public function listInvalidProperties()
    {
        $invalid_properties = [];

        return $invalid_properties;
    }

    /**
     * validate all the properties in the model
     * return true if all passed
     *
     * @return bool True if all properties are valid
     */
    public function valid()
    {

        return true;
    }


    /**
     * Gets id
     * @return float
     */
    public function getId()
    {
        return $this->container['id'];
    }

    /**
     * Sets id
     * @param float $id Unique numerical ID for the ToolConfig.
     * @return $this
     */
    public function setId($id)
    {
        $this->container['id'] = $id;

        return $this;
    }

    /**
     * Gets version_name
     * @return string
     */
    public function getVersionName()
    {
        return $this->container['version_name'];
    }

    /**
     * Sets version_name
     * @param string $version_name the version name of the tool's configuration
     * @return $this
     */
    public function setVersionName($version_name)
    {
        $this->container['version_name'] = $version_name;

        return $this;
    }

    /**
     * Gets description
     * @return string
     */
    public function getDescription()
    {
        return $this->container['description'];
    }

    /**
     * Sets description
     * @param string $description a description of the configuration
     * @return $this
     */
    public function setDescription($description)
    {
        $this->container['description'] = $description;

        return $this;
    }

    /**
     * Gets tool_id
     * @return float
     */
    public function getToolId()
    {
        return $this->container['tool_id'];
    }

    /**
     * Sets tool_id
     * @param float $tool_id the ID of the tool associated with this configuration
     * @return $this
     */
    public function setToolId($tool_id)
    {
        $this->container['tool_id'] = $tool_id;

        return $this;
    }

    /**
     * Gets bourreau_id
     * @return float
     */
    public function getBourreauId()
    {
        return $this->container['bourreau_id'];
    }

    /**
     * Sets bourreau_id
     * @param float $bourreau_id The ID of the execution server where this tool configuration is available.
     * @return $this
     */
    public function setBourreauId($bourreau_id)
    {
        $this->container['bourreau_id'] = $bourreau_id;

        return $this;
    }

    /**
     * Gets env_array
     * @return string[]
     */
    public function getEnvArray()
    {
        return $this->container['env_array'];
    }

    /**
     * Sets env_array
     * @param string[] $env_array additional environment variables
     * @return $this
     */
    public function setEnvArray($env_array)
    {
        $this->container['env_array'] = $env_array;

        return $this;
    }

    /**
     * Gets script_prologue
     * @return string
     */
    public function getScriptPrologue()
    {
        return $this->container['script_prologue'];
    }

    /**
     * Sets script_prologue
     * @param string $script_prologue A piece of bash script configured by the administrator to run before the tool is launched.
     * @return $this
     */
    public function setScriptPrologue($script_prologue)
    {
        $this->container['script_prologue'] = $script_prologue;

        return $this;
    }

    /**
     * Gets group_id
     * @return float
     */
    public function getGroupId()
    {
        return $this->container['group_id'];
    }

    /**
     * Sets group_id
     * @param float $group_id the ID of the project controlling access to this ToolConfig
     * @return $this
     */
    public function setGroupId($group_id)
    {
        $this->container['group_id'] = $group_id;

        return $this;
    }

    /**
     * Gets ncpus
     * @return float
     */
    public function getNcpus()
    {
        return $this->container['ncpus'];
    }

    /**
     * Sets ncpus
     * @param float $ncpus A hint at how many CPUs the CBRAIN task will allocate to run this tool configuration
     * @return $this
     */
    public function setNcpus($ncpus)
    {
        $this->container['ncpus'] = $ncpus;

        return $this;
    }
    /**
     * Returns true if offset exists. False otherwise.
     * @param  integer $offset Offset
     * @return boolean
     */
    public function offsetExists($offset)
    {
        return isset($this->container[$offset]);
    }

    /**
     * Gets offset.
     * @param  integer $offset Offset
     * @return mixed
     */
    public function offsetGet($offset)
    {
        return isset($this->container[$offset]) ? $this->container[$offset] : null;
    }

    /**
     * Sets value based on offset.
     * @param  integer $offset Offset
     * @param  mixed   $value  Value to be set
     * @return void
     */
    public function offsetSet($offset, $value)
    {
        if (is_null($offset)) {
            $this->container[] = $value;
        } else {
            $this->container[$offset] = $value;
        }
    }

    /**
     * Unsets offset.
     * @param  integer $offset Offset
     * @return void
     */
    public function offsetUnset($offset)
    {
        unset($this->container[$offset]);
    }

    /**
     * Gets the string presentation of the object
     * @return string
     */
    public function __toString()
    {
        if (defined('JSON_PRETTY_PRINT')) { // use JSON pretty print
            return json_encode(\Swagger\Client\ObjectSerializer::sanitizeForSerialization($this), JSON_PRETTY_PRINT);
        }

        return json_encode(\Swagger\Client\ObjectSerializer::sanitizeForSerialization($this));
    }
}

