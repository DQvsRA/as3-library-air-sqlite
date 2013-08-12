package com.probertson.database.interfaces
{
	import com.probertson.data.QueuedStatement;

	public interface IDatabase
	{
		function execute(sql:String, parameters:Object, handler:Function, itemClass:Class=null):void;
		function executeModify(statementBatch:Vector.<QueuedStatement> = null, resultHandler:Function = null, errorHandler:Function = null, progressHandler:Function = null):void;
	}
}