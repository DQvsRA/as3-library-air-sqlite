package com.probertson.database.interfaces
{
	import com.probertson.data.QueuedStatement;


	public interface IDatabase
	{
//		function createTableAndColumnStructure():void;
//		function databaseExistsAlgorithm():void;
//		function databaseNotExistsAlgorithm():void;
		
		function createTablesInDatabaseFile(  ):void
		function insertDefaultData():void;
		function executeBatch_complete(results:Object):void;
		
		function addToStmtQueue( stmt:QueuedStatement ):void;
		function execute(sql:String, parameters:Object, handler:Function, itemClass:Class=null):void;
		function executeModify():void;
	}
}