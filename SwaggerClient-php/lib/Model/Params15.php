<?php
/**
 * Params15
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
 * Params15 Class Doc Comment
 *
 * @category    Class
 * @package     Swagger\Client
 * @author      Swagger Codegen team
 * @link        https://github.com/swagger-api/swagger-codegen
 */
class Params15 implements ArrayAccess
{
    const DISCRIMINATOR = null;

    /**
      * The original name of the model.
      * @var string
      */
    protected static $swaggerModelName = 'params_15';

    /**
      * Array of property to type mappings. Used for (de)serialization
      * @var string[]
      */
    protected static $swaggerTypes = [
        'data_provider_id_for_mv_cp' => 'int',
        'crush_destination' => 'bool',
        'file_ids' => 'int[]'
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
        'data_provider_id_for_mv_cp' => 'data_provider_id_for_mv_cp',
        'crush_destination' => 'crush_destination',
        'file_ids' => 'file_ids'
    ];


    /**
     * Array of attributes to setter functions (for deserialization of responses)
     * @var string[]
     */
    protected static $setters = [
        'data_provider_id_for_mv_cp' => 'setDataProviderIdForMvCp',
        'crush_destination' => 'setCrushDestination',
        'file_ids' => 'setFileIds'
    ];


    /**
     * Array of attributes to getter functions (for serialization of requests)
     * @var string[]
     */
    protected static $getters = [
        'data_provider_id_for_mv_cp' => 'getDataProviderIdForMvCp',
        'crush_destination' => 'getCrushDestination',
        'file_ids' => 'getFileIds'
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
        $this->container['data_provider_id_for_mv_cp'] = isset($data['data_provider_id_for_mv_cp']) ? $data['data_provider_id_for_mv_cp'] : null;
        $this->container['crush_destination'] = isset($data['crush_destination']) ? $data['crush_destination'] : null;
        $this->container['file_ids'] = isset($data['file_ids']) ? $data['file_ids'] : null;
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
     * Gets data_provider_id_for_mv_cp
     * @return int
     */
    public function getDataProviderIdForMvCp()
    {
        return $this->container['data_provider_id_for_mv_cp'];
    }

    /**
     * Sets data_provider_id_for_mv_cp
     * @param int $data_provider_id_for_mv_cp The ID of the Data Provider to move or copy the files to.
     * @return $this
     */
    public function setDataProviderIdForMvCp($data_provider_id_for_mv_cp)
    {
        $this->container['data_provider_id_for_mv_cp'] = $data_provider_id_for_mv_cp;

        return $this;
    }

    /**
     * Gets crush_destination
     * @return bool
     */
    public function getCrushDestination()
    {
        return $this->container['crush_destination'];
    }

    /**
     * Sets crush_destination
     * @param bool $crush_destination Specifies whether to overwrite files on the destination Data Provider if a file already exists there with the same name.
     * @return $this
     */
    public function setCrushDestination($crush_destination)
    {
        $this->container['crush_destination'] = $crush_destination;

        return $this;
    }

    /**
     * Gets file_ids
     * @return int[]
     */
    public function getFileIds()
    {
        return $this->container['file_ids'];
    }

    /**
     * Sets file_ids
     * @param int[] $file_ids The ID's of the Userfiles to be moved or copied to a new Data Provider.
     * @return $this
     */
    public function setFileIds($file_ids)
    {
        $this->container['file_ids'] = $file_ids;

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

