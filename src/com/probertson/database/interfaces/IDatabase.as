package com.probertson.database.interfaces
{
	import com.probertson.data.QueuedStatement;

	public interface IDatabase
	{
		function get dbFilename():String;
		function addTable( table:String ):void;
		function executeCreateTables( callback:Function = null):void
		function execute(sql:String, parameters:Object, handler:Function, itemClass:Class=null):void;
		function executeModify(statementBatch:Vector.<QueuedStatement>, resultHandler:Function, errorHandler:Function, progressHandler:Function):void;
	}
}