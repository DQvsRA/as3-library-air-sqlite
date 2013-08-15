package com.probertson.database
{
	import com.probertson.database.errors.AbstractMethodError;
	import com.probertson.database.structure.Database;
	
	import flash.data.SQLResult;
	import flash.errors.SQLError;

	/**
	 * Abstract Class that executes database instantiation algorithm. 
	 * @author Jerry_Orta
	 * 
	 */	
	public class Template
	{
		protected var db:Database;
		protected var _name:String;
		protected var _tableCount:int = 0;
		
		protected var execute_complete:Function;
		
		public function Template( db:Database )
		{
			this.db = db;
			this._name = db.name;
			
			this.db._executeBatch_complete = this.executeBatch_complete;
			this.db._executeBatch_progress = this.executeBatch_progress;
			this.db._executeBatch_error = this.executeBatch_error;
			
			this.createTableAndColumnStructure();
			
			if ( db.exists )
			{
				this.databaseExistsAlgorithm();
			} else {
				this.databaseNotExistsAlgorithm();
			}
		}
		
		
		protected function databaseExistsAlgorithm():void
		{
			throw new AbstractMethodError;
		}
		
		protected function databaseNotExistsAlgorithm():void
		{
			throw new AbstractMethodError;
		}
		
		
		protected function createTableAndColumnStructure():void 
		{
			throw new AbstractMethodError;
		}
		
		protected function createTablesInDatabaseFile(  ):void
		{
			throw new AbstractMethodError;
		}
		
		public function getDataFromDatabase( tableName:String ):void
		{
			db.execute( this.db.getTables()[tableName].getSelectAllSyntax(), null, this.execute_complete, this.db.getTables()[tableName].itemClass );
		}
		

		protected function insertDefaultData():void
		{
			throw new AbstractMethodError;
		}
		

		private function executeBatch_progress(completedCount:uint, totalCount:uint):void
		{
			//			trace( "Progress completedCountd: " +  completedCount + " totalCount: " + totalCount);
		}
		
		private function executeBatch_complete(results:Vector.<SQLResult>):void
		{
			//			trace( "Batch Complete " + results.toString() );
			while ( db._createTableQueue.length )
			{
				db._createTableQueue.pop();
			}
			
			while ( db._sqlStmtsQueue.length )
			{
				db._sqlStmtsQueue.pop();
			}
		}
		
		private function executeBatch_error(error:SQLError):void
		{
			// handle the error as desired or bubble
			trace( error.toString() );
		}
				
		// GETTERS AND SETTERS
		public function get name():String
		{
			return _name;
		}
		
		public function get database():Database
		{
			return db;
		}
		
		
		
		
	}
}