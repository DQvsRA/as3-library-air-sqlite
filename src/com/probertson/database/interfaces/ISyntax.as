package com.probertson.database.interfaces
{

	// ABSTRACT Class (should be subclassed and not instantiated)
	public interface ISyntax {

		function getCreateSyntax():String;
		
		function getInsertSyntax():String;

		function getUpdateSyntax( columnTitle:String, exclude:Object ):String;

        function getDropSyntax( title:String, exclude:Object ):String;
		
//		function getSelectAllSyntax():String;

        function get name():String;
		
		
	}
}