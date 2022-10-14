class_name SQLite_Documented
## Wrapper for SQLite class
##
## Makes documentation accessable. Can be used instead of gdsqlite.gdns
# Removed functionality: verbose_mode - Deprecated

var SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")

var db

const QUIET = 0

const NORMAL = 1

const VERBOSE = 2

const VERY_VERBOSE = 3

## Path to the database, [br]
## should be set before opening the database with `open_db()`. [br]
## If no database with this name exists, a new one at the supplied path will be created. [br]
## Both `res://` and `user://` keywords can be used to define the path.
var path : String setget set_path, get_path

func set_path(value : String) -> void:
	db.path = value

func get_path() -> String:
	return db.path


## Contains the zErrMsg returned by the SQLite query in human-readable form. [br]
## An empty string corresponds with the case in which the query executed succesfully.
var error_message : String setget set_error_message, get_error_message

func set_error_message(message: String) -> void:
	db.error_message = message
	
func get_error_message() -> String:
	return db.error_message
	pass


## Default extension that is automatically appended to the `path`-variable whenever **no** extension is detected/given.
## If database files without extension are desired, this variable has to be set to ""  to skip this automatic procedure entirely.
var default_extension :String setget set_default_extension, get_default_extension

func set_default_extension(extension : String) -> void:
	db.default_extension = extension

func get_default_extension() -> String:
	return db.default_extension


## Enables or disables the availability of [foreign keys](https://www.sqlite.org/foreignkeys.html) in the SQLite database.
var foreign_keys : bool setget set_foreign_keys, get_foreign_keys

func set_foreign_keys(value : bool) -> void:
	db.foreign_keys = value

func get_foreign_keys() -> bool:
	return db.foreign_keys
#- **read_only** (Boolean, default=false)
#
## Enabling this property opens the database in read-only modus & allows databases to be packaged inside of the PCK. [br]
## To make this possible, a custom [VFS](https://www.sqlite.org/vfs.html) is employed which internally takes care of all the file handling using the Godot API. [br]
## ***NOTE:** Godot opens files in a mode that is not shareable i.e. the database file cannot be open in any other program. [br]
## Attempting to open a read-only database that is locked by another program fails and returns `ERR_FILE_CANT_OPEN` (`12`). [br]
## However, multiple simultaneous read-only database connections are allowed.
var read_only : bool setget set_read_only, get_read_only

func set_read_only(value : bool) -> void:
	db.read_only = value
	
func get_read_only() -> bool:
	return db.read_only


## Contains the results from the latest query **by value**; 
## This property is safe to use when looping successive queries as it does not get overwritten by any future queries.
var query_result : Array setget set_query_result, get_query_result

func set_query_result(value : Array) -> void:
	db.query_result = value

func get_query_result() -> Array:
	return db.query_result


## Contains the results from the latest query **by reference** and is, as a direct result, cleared and repopulated after every new query.
var query_result_by_reference : Array setget set_query_result_by_reference, get_query_result_by_reference

func set_query_result_by_reference(value : Array) -> void:
	db.query_result_by_reference = value

func get_query_result_by_reference() -> Array:
	return db.query_result_by_reference


## Exposes both the `sqlite3_last_insert_rowid()`- and `sqlite3_set_last_insert_rowid()`-methods to Godot as described [here](https://www.sqlite.org/c3ref/last_insert_rowid.html) and [here](https://www.sqlite.org/c3ref/set_last_insert_rowid.html) respectively.
var last_insert_rowid : int setget set_last_insert_rowid, get_last_insert_rowid

func set_last_insert_rowid(value : int) -> void:
	db.last_insert_rowid = value
	
func get_last_insert_rowid() -> int:
	return db.last_insert_rowid


##    The verbosity_level determines the amount of logging to the Godot console that is handy for debugging your (possibly faulty) SQLite queries.
##
##   | Level            | Description                                 |
##   |----------------- | ------------------------------------------- |
##   | QUIET (0)        | Don't print anything to the console         |
##   | NORMAL (1)       | Print essential information to the console  |
##   | VERBOSE (2)      | Print additional information to the console |
##   | VERY_VERBOSE (3) | Same as VERBOSE                             |
##
##   ***NOTE:** VERBOSE and higher levels might considerably slow down your queries due to excessive logging.*
var verbosity_level : int setget set_verbosity_level, get_verbosity_level

func set_verbosity_level(var value) -> void:
	db.verbosity_level = value

func get_verbosity_level() -> int:
	return db.verbosity_level


func open_db() -> bool:
	return db.open_db()
	
	
func close_db() -> bool:
	return db.close_db()
	
	
## Passes a query as-is to the database
func query(query_string : String) -> bool:
	return db.query_string(query_string)
#- Boolean success = **query_with_bindings(** String query_string, Array param_bindings **)**

##    Binds the parameters contained in the `param_bindings`-variable to the query. Using this function stops any possible attempts at SQL data injection as the parameters are sanitized. More information regarding parameter bindings can be found [here](https://www.sqlite.org/c3ref/bind_blob.html).
##
##    **Example usage**:
##
##    ```gdscript
##    var query_string : String = "SELECT ? FROM company WHERE age < ?;"
##    var param_bindings : Array = ["name", 24]
##    var success = db.query_with_bindings(query_string, param_bindings)
##    # Executes following query: 
##    # SELECT name FROM company WHERE age < 24;
##    ```
##
##    Using bindings is optional, except for PoolByteArray (= raw binary data) which has to binded to allow the insertion and selection of BLOB data in the database.
##
##    ***NOTE**: Binding column names is not possible due to SQLite restrictions. If dynamic column names are required, insert the column name directly into the `query_string`-variable itself (see https://github.com/2shady4u/godot-sqlite/issues/41).* 
func query_with_bindings(query_string : String, param_bindings : Array) -> bool:
	return db.query_with_bindings(query_string, param_bindings)

#- Boolean success = **create_table(** String table_name, Dictionary table_dictionary **)**
## Creates a table if it does not already exist [br]
## [br]
##  Each key/value pair of the `table_dictionary`-variable defines a column of the table. Each key defines the name of a column in the database, while the value is a dictionary that contains further column specifications. [br]
## [br]
##    **Required fields**: [br]
# [br]
#    - **"data_type"**: type of the column variable, following values are valid\*:
#
#        | value       | SQLite         | Godot          | [br]
#        |:-----------:|:--------------:|:--------------:| [br]
#        | int         | INTEGER        | TYPE_INT       | [br]
#        | real        | REAL           | TYPE_REAL      | [br]
#        | text        | TEXT           | TYPE_STRING    | [br]
#        | char(?)\*\* | CHAR(?)\*\*    | TYPE_STRING    | [br]
#        | blob        | BLOB           | TYPE_RAW_ARRAY | [br]
#
#        \* *Data types not found in this table throw an error and end up finalizing the current SQLite statement.*  
#        \*\* *with the question mark being replaced by the maximum amount of characters*
#
#    **Optional fields**:
#
#    - **"not_null"** *(default = false)*: Is the NULL value an invalid value for this column?
#
#    - **"default"**: The default value of the column if not explicitly given.
#
#    - **"primary_key"** *(default = false)*: Is this the primary key of this table?  
#    Evidently, only a single column can be set as the primary key.
#
#    - **"auto_increment"** *(default = false)*: Automatically increment this column when no explicit value is given. This auto-generated value will be one more (+1) than the largest value currently in use.
#
#        ***NOTE**: Auto-incrementing a column only works when this column is the primary key!*
#
#    - **"foreign_key"**: Enforce an "exist" relationship between tables by setting this variable to `foreign_table.foreign_column`. In other words, when adding an additional row, the column value should be an existing value as found in the column with name `foreign_column` of the table with name `foreign_table`.
#
#        ***NOTE**: Availability of foreign keys has to be enabled by setting the `foreign_keys`-variable to true BEFORE opening the database.*
#
#    **Example usage**:
#
#    ```gdscript
#    # Add the row "id" to the table, which is an auto-incremented primary key.
#    # When adding additional rows, this value can either by explicitely given or be unfilled.
#    table_dictionary["id"] = {
#        "data_type":"int", 
#        "primary_key": true, 
#        "auto_increment":true
#    }
#    ```
#
#    For more concrete usage examples see the `database.gd`-file as found in this repository's demo project.
#
#- Boolean success = **drop_table(** String table_name **)**
#
#- Boolean success = **insert_row(** String table_name, Dictionary row_dictionary **)**
#
#    Each key/value pair of the `row_dictionary`-variable defines the column values of a single row.  
#
#    Columns should adhere to the table schema as instantiated using the `table_dictionary`-variable and are required if their corresponding **"not_null"**-column value is set to `True`.
#
#- Boolean success = **insert_rows(** String table_name, Array row_array **)**
#
#- Array selected_rows = **select_rows(** String table_name, String query_conditions, Array selected_columns **)**
#
#- Boolean success = **update_rows(** String table_name, String query_conditions, Dictionary updated_row_dictionary **)**
#
#    With the `updated_row_dictionary`-variable adhering to the same table schema & conditions as the `row_dictionary`-variable defined previously.
#
#- Boolean success = **delete_rows(** String table_name, String query_conditions **)**
#
#- Boolean success = **import_from_json(** String import_path **)**
#
#    Drops all database tables and imports the database structure and content present inside of `import_path.json`.
#
#- Boolean success = **export_to_json(** String export_path **)**
#
#    Exports the database structure and content to `export_path.json` as a backup or for ease of editing.
#
#- Boolean success = **create_function(** String function_name, FuncRef function_reference, int number_of_arguments **)**
#
#    Bind a [scalar SQL function](https://www.sqlite.org/appfunc.html) to the database that can then be used in subsequent queries.
#
#- Integer mode = **get_autocommit()**
#
#    Get the current autocommit mode of the open database connection which can be used to check if there's any database transactions in progress, see [here](http://www.sqlite.org/c3ref/get_autocommit.html). A non-zero return value indicates that the database is in autocommit mode and thus has no active transaction.


# Called when the node enters the scene tree for the first time.
func _ready():
	db = SQLite.new()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
