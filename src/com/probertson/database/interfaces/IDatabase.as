package com.probertson.database.interfaces
{
	public interface IDatabase
	{
		function get dbFilename():String;
		function createTable( table:String ):void;
	}
}