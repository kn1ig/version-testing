SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER VisionSC_DDL_Trigger ON DATABASE 
FOR 
DDL_ASSEMBLY_EVENTS, 
DDL_APPLICATION_ROLE_EVENTS, 
DDL_ASYMMETRIC_KEY_EVENTS, 
DDL_CERTIFICATE_EVENTS,
DDL_ROLE_EVENTS, 
DDL_SCHEMA_EVENTS, 
DDL_SYMMETRIC_KEY_EVENTS, 
DDL_USER_EVENTS, 
DDL_DEFAULT_EVENTS, 
DDL_EVENT_NOTIFICATION_EVENTS,
DDL_FULLTEXT_CATALOG_EVENTS, 
DDL_FULLTEXT_STOPLIST_EVENTS, 
DDL_FUNCTION_EVENTS, 
DDL_PARTITION_EVENTS, 
DDL_PROCEDURE_EVENTS,
DDL_RULE_EVENTS,
DDL_SEARCH_PROPERTY_LIST_EVENTS, 
DDL_SEQUENCE_EVENTS,  
DDL_CONTRACT_EVENTS, 
DDL_MESSAGE_TYPE_EVENTS, 
DDL_QUEUE_EVENTS, 
DDL_REMOTE_SERVICE_BINDING_EVENTS, 
DDL_ROUTE_EVENTS, 
DDL_SERVICE_EVENTS, 
DDL_SYNONYM_EVENTS, 
DDL_TABLE_EVENTS, 
DDL_VIEW_EVENTS, 
DDL_TRIGGER_EVENTS, 
DDL_TYPE_EVENTS,
DDL_XML_SCHEMA_COLLECTION_EVENTS,
DDL_EXTENDED_PROPERTY_EVENTS,
DDL_INDEX_EVENTS,
RENAME -- Applies to sp_rename and also renaming of columns
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @data XML;
	DECLARE @schema sysname;
	DECLARE @object sysname;
	DECLARE @eventType sysname;
	DECLARE @parentObjectName nvarchar(255);
	DECLARE @parentObjectType nvarchar(255);
	DECLARE @newObjectName nvarchar(255);
	DECLARE @objectID nvarchar(max);
	DECLARE @objectType nvarchar(50);
	DECLARE @Urn NVARCHAR(4000);
	DECLARE @objectName nvarchar(255);

	SET @data = EVENTDATA();
	SET @eventType = @data.value('(/EVENT_INSTANCE/EventType)[1]', 'sysname');
	SET @schema = @data.value('(/EVENT_INSTANCE/SchemaName)[1]', 'sysname');
	SET @object = @data.value('(/EVENT_INSTANCE/ObjectName)[1]', 'sysname') 
	SET @parentObjectName = @data.value('(/EVENT_INSTANCE/TargetObjectName)[1]', 'nvarchar(255)');
	SET @parentObjectType = @data.value('(/EVENT_INSTANCE/TargetObjectType)[1]', 'nvarchar(255)');
	SET @newObjectName = @data.value('(/EVENT_INSTANCE/NewObjectName)[1]', 'nvarchar(255)');
	SET @objectType = @data.value('(/EVENT_INSTANCE/ObjectType)[1]', 'nvarchar(50)');

	IF @object IS NOT NULL
		PRINT '  ' + @eventType + ' - ' + @schema + '.' + @object;
	ELSE
		PRINT '  ' + @eventType + ' - ' + @schema;

	IF @eventType IS NULL
		PRINT CONVERT(nvarchar(max), @data);

	DECLARE @objectTempID int;
	SET @objectTempID = OBJECT_ID(@objectID);

	IF OBJECT_ID(@objectTempID) IS NULL
	BEGIN    
	   IF @objectType = N'TYPE'
		  SET @objectTempID = (SELECT DISTINCT system_type_id From sys.types WHERE sys.types.name = @object)
	   IF @objectType = N'TRIGGER'
		  SET @objectTempID = (SELECT TOP 1 OBJECT_ID FROM sys.triggers WHERE name = @object)
	   IF @objectType = N'ASSEMBLY'
		  SET @objectTempID = (SELECT DISTINCT sys.assemblies.assembly_id FROM sys.assemblies WHERE [name] = @object)
	   IF @objectType = N'CONTRACT'
		  SET @objectTempID = (SELECT DISTINCT sys.service_contracts.service_contract_id FROM sys.service_contracts WHERE [name] = @object)
	   IF @objectType = N'EVENT NOTIFICATION'
		  SET @objectTempID = (SELECT DISTINCT OBJECT_ID FROM sys.event_notifications WHERE [name] = @object)
	   IF @objectType = N'SERVICE'
		  SET @objectTempID = (SELECT DISTINCT OBJECT_ID from sys.services a inner join sys.service_queues b on a.service_queue_id = b.object_id WHERE b.name = @object)
	   IF @objectType = N'ROUTE'
		  SET @objectTempID = (SELECT DISTINCT sys.routes.route_id FROM sys.routes WHERE [name] = @object)
	   IF @objectType = N'FULLTEXT CATALOG'
		  SET @objectTempID = (SELECT DISTINCT sys.fulltext_catalogs.fulltext_catalog_id FROM sys.fulltext_catalogs WHERE [name] = @object)
	   IF @objectType = N'MESSAGE TYPE'
		  SET @objectTempID = (SELECT DISTINCT sys.service_message_types.message_type_id FROM sys.service_message_types WHERE [name] = @object)
	   IF @objectType = N'PARTITION FUNCTION'
		  SET @objectTempID = (SELECT DISTINCT sys.partition_functions.function_id FROM sys.partition_functions WHERE [name] = @object)
	   IF @objectType = N'PARTITION SCHEME'
		  SET @objectTempID = (SELECT DISTINCT sys.partition_schemes.function_id FROM sys.partition_schemes WHERE [name] = @object)
	   IF @objectType = N'ROLE'
		  SET @objectTempID = (SELECT DISTINCT sys.database_principals.principal_id FROM sys.database_principals WHERE [name] = @object)
	   IF @objectType = N'APPLICATION ROLE'
		  SET @objectTempID = (SELECT DISTINCT sys.database_principals.principal_id FROM sys.database_principals WHERE [name] = @object)
	   IF @objectType = N'SQL USER'
		  SET @objectTempID = (SELECT DISTINCT sys.sysusers.uid FROM sys.sysusers WHERE [name] = @object)
	   IF @objectType = N'REMOTE SERVICE BINDING'
		  SET @objectTempID = (SELECT DISTINCT sys.remote_service_bindings.remote_service_binding_id FROM sys.remote_service_bindings WHERE [name] = @object)
	   IF @objectType = N'SCHEMA'
		  SET @objectTempID = (SELECT DISTINCT a.schema_id FROM sys.schemas a inner join sys.database_principals sysdbp on a.principal_id = sysdbp.principal_id WHERE a.name = @object)
	   IF @objectType = N'SEARCH PROPERTY LIST'
		  SET @objectTempID = (SELECT DISTINCT sys.registered_search_property_lists.property_list_id FROM sys.registered_search_property_lists WHERE [name] = @object)
	   IF @objectType = N'XML SCHEMA COLLECTION'
		  SET @objectTempID = (SELECT DISTINCT sys.xml_schema_collections.xml_collection_id from sys.xml_schema_collections WHERE [name] = @object)
	   IF @objectType = N'FULLTEXT STOPLIST'
		  SET @objectTempID = (SELECT DISTINCT sys.fulltext_stoplists.stoplist_id from sys.fulltext_stoplists WHERE [name] = @object)
	END

	IF @objectType = 'PROCEDURE'
		SET @objectType = 'StoredProcedure';
	ELSE IF @objectType = 'USER-DEFINED FUNCTION'
		SET @objectType = 'User-Defined Function';
	ELSE IF @objectType = 'ASYMMETRIC KEY'
		SET @objectType = 'Asymmetric Key';
	ELSE IF @objectType = 'CERTIFICATE'
		SET @objectType = 'Certificate';
	ELSE IF @objectType = 'SYMMETRIC KEY'
		SET @objectType = 'Symmetric Key';
	ELSE IF @objectType = 'EVENT NOTIFICATION'
		SET @objectType = 'Event Notification';
	ELSE IF @objectType = 'FULLTEXT CATALOG'
		SET @objectType = 'Fulltext Catalog';
	ELSE IF @objectType = 'FULLTEXT STOPLIST'
		SET @objectType = 'Fulltext Stoplist';
	ELSE IF @objectType = 'SEARCH PROPERTY LIST'
		SET @objectType = 'Search Property List';
	ELSE IF @objectType = 'REMOTE SERVICE BINDING'
		SET @objectType = 'Remote Service Binding';
	ELSE IF @objectType = 'XML SCHEMA COLLECTION'
		SET @objectType = 'XML Schema Collection';
	ELSE IF @objectType = 'EXTENDED PROPERTY'
		SET @objectType = 'Extended Property';
	ELSE IF @objectType = 'MESSAGE TYPE'
		SET @objectType = 'Message Type';
	ELSE
		-- Handle all other object types, defaulting to first letter capitalized, rest lower
		SET @objectType = UPPER(LEFT(@objectType, 1)) + LOWER(SUBSTRING(@objectType, 2, LEN(@objectType)));

	DECLARE @baseUrn NVARCHAR(MAX);
	DECLARE @schemaPart NVARCHAR(MAX);

	-- Determine base Urn and schema part dynamically
	SET @baseUrn = CONCAT(
		'Server[@Name=''',
		CONVERT(NVARCHAR(128), SERVERPROPERTY('ServerName')),
		''']/Database[@Name=''',
		DB_NAME(),
		''']'
	);

	IF @schema IS NOT NULL
		SET @schemaPart = CONCAT(' and @Schema=''', @schema, '''');
	ELSE
		SET @schemaPart = '';

	-- Handle different event types
	IF @eventType = 'RENAME'
	BEGIN
		-- Special handling for COLUMN rename
		IF @data.value('(/EVENT_INSTANCE/ObjectType)[1]', 'nvarchar(50)') = 'COLUMN'
		BEGIN
			SET @objectID = CONCAT(
				@data.value('(/EVENT_INSTANCE/DatabaseName)[1]', 'varchar(256)'),
				'.',
				CONVERT(sysname, @schema),
				'.',
				CONVERT(sysname, @parentObjectName)
			);
			SET @objectName = CONVERT(sysname, @parentObjectName);

			-- Use parent object type (Table) instead of Column
			SET @Urn = CONCAT(
				@baseUrn,
				'/Table[@Name=''', @objectName, '''', @schemaPart, ']'
			);
		END
		ELSE
		BEGIN
			SET @objectID = CONCAT(
				@data.value('(/EVENT_INSTANCE/DatabaseName)[1]', 'varchar(256)'),
				'.',
				CONVERT(sysname, @schema),
				'.',
				CONVERT(sysname, @newObjectName)
			);
			SET @objectName = CONVERT(sysname, @newObjectName);

			-- Use object type for non-COLUMN rename
			SET @Urn = CONCAT(
				@baseUrn,
				'/', @objectType, '[@Name=''', @objectName, '''', @schemaPart, ']'
			);
		END
	END
	ELSE
	BEGIN
		-- General case for non-RENAME events
		SET @objectID = CONCAT(
			@data.value('(/EVENT_INSTANCE/DatabaseName)[1]', 'varchar(256)'),
			'.',
			CONVERT(sysname, @schema),
			'.',
			CONVERT(sysname, @object)
		);
		SET @objectName = CONVERT(sysname, @object);

		SET @Urn = CONCAT(
			@baseUrn,
			'/', @objectType, '[@Name=''', @objectName, '''', @schemaPart, ']'
		);
	END

	-- Assuming Service Broker objects have a certain naming convention or schema
	-- Change 'ServiceBrokerSchema' and 'SB_' to match your actual environment
	IF NOT (CONVERT(sysname, @schema) = 'ServiceBrokerAuth' OR @objectName LIKE 'SB_%')
	BEGIN
		INSERT INTO VisionSC_Database_Info
		(
			[Obj_Id], 
			[Server], 
			[Database], 
			[Schema], 
			[Obj_Name], 
			[Obj_Type], 
			[New_Obj_Name], 
			[Parent_Obj_Name], 
			[Parent_Obj_Type], 
			[Event], 
			[User], 
			[Sql_Query], 
			[Xml_Event], 
			[Event_Exec_Time], 
			[Processed],
			[Urn]
		)
		VALUES 
		(
			@objectTempID,
			@@SERVERNAME,
			DB_NAME(),
			CONVERT(sysname, @schema),
			CONVERT(sysname, @object),
			@objectType,
			@newObjectName,
			@parentObjectName,
			@parentObjectType,
			@eventType,
			SYSTEM_USER, 
			@data.value('(/EVENT_INSTANCE/TSQLCommand)[1]', 'nvarchar(max)'),
			@data,
			GETDATE(),
			0, -- Insert '0' since it is not yet processed
			@Urn
		);
	END

	
END;
GO
ENABLE TRIGGER [VisionSC_DDL_Trigger] ON DATABASE