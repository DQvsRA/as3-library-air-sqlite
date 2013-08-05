package com.probertson.database.structure
{
	import flash.errors.IllegalOperationError;
	
	// ABSTRACT Class (should be subclassed and not instantiated)
	public class AbstractTable {
		
		
		
		public function addColumn(c:AbstractTable):void {
			throw new IllegalOperationError("add operation not supported");
		}
		
		public function addRow( columnTitle:String, dataObject:Object):void {
			throw new IllegalOperationError("row operation not supported");
		}

        /**
         * Delete a table row by reference;
         *
         * TODO not sure how to implement this yet
         *
         * @param reference can be the table id
         * @param data
         */
		public function deleteRow( reference:*, data:* ):void {
			throw new IllegalOperationError("row operation not supported");
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
		
		public function create():String {
			throw new IllegalOperationError("create operation not supported");
			return null;
		}
		
	}
}