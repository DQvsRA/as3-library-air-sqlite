package com.probertson.database.interfaces
{
import com.probertson.database.errors.AbstractMethodError;


	// ABSTRACT Class (should be subclassed and not instantiated)
	public interface ISyntax {

		function getCreateSyntax():String;
		
		function getInsertSyntax():String;

		function getUpdateSyntax( columnTitle:String, exclude:Object ):String;

        function getDropSyntax( title:String, exclude:Object ):String;

        function get name():String;
		
		
	}
}