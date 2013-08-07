package com.probertson.database.structure
{
	import flash.errors.IllegalOperationError;
	
	// ABSTRACT Class (should be subclassed and not instantiated)
	public class AbstractTable {
		
		
		
		public function addColumn(c:AbstractTable):void {
			throw new IllegalOperationError("add operation not supported");
		}
		
	

		public function removeColumn(c:AbstractTable):void {
			throw new IllegalOperationError("remove operation not supported");
		}
		
		public function getColumn(n:int):AbstractTable { 
			throw new IllegalOperationError("getChild operation not supported");
			return null;
		}
		
		// ABSTRACT Method (must be overridden in a subclass)
		public function operation():void {
		}
		
		public function getCreateSyntax():String {
			throw new IllegalOperationError("create operation not supported");
			return null;
		}
		
		public function getInsertSyntax():String {
			throw new IllegalOperationError("create operation not supported");
			return null;
		}
		
		public function getUpdateSyntax( columnTitle:String, exclude:Object ):String {
			throw new IllegalOperationError("create operation not supported");
			return null;
		}
		
		public function parameter():String {
			throw new IllegalOperationError("create operation not supported");
			return null;
		}
		
		
	}
}