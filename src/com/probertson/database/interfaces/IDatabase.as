package com.probertson.database.interfaces
{
	import com.probertson.data.QueuedStatement;
	import com.probertson.database.structure.AbstractDatabase;


	public interface IDatabase
	{
//		function add( table:AbstractDatabase ):void;
//		function createStructure():void;
		function addToStmtQueue( stmt:QueuedStatement ):void;
		function execute(sql:String, parameters:Object, handler:Function, itemClass:Class=null):void;
		function executeModify():void;
	}
}