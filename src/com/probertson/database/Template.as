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
		protected var _tempTableArray:Vector.<Object>;
		
		public function Template( db:Database )
		{
			this.db = db;
			this._name = db.name;
			
			this.db.executeBatch_complete = this.executeBatch_complete;
			this.db.executeBatch_progress = this.executeBatch_progress;
			this.db.executeBatch_error = this.executeBatch_error;
			
			this._tempTableArray = new Vector.<Object>();
			
			//Create table structure in memory to hold data
			this.createStructure();
			this.createTables();
			
			if ( db.exists )
			{
				//TODO Trigger Intro View
				
				this.db.getTables()
				for (var key:* in this.db.getTables()) {
					this._tempTableArray.push(key);
					_tableCount++;
				}
				
				this.db.executeBatch_complete = this.getInitialData;
				
				
			} else {
				this.insertDefaultData();
				this.db.executeModify();
			}
		}
		
		
		protected function createStructure():void 
		{
			throw new AbstractMethodError;
		}
		
		protected function createTables(  ):void
		{
			throw new AbstractMethodError;
		}
		
		private function getInitialData( junk:Vector.<SQLResult> = null ):void
		{
			if ( this._tempTableArray.length >= 0 ) 
			{
				var key:Object = this._tempTableArray.shift();
				db.execute( this.db.getTables()[key].getSelectAllSyntax(), null, this.initialDataResult, this.db.getTables()[key].itemClass );
			}
		}
		
		private function initialDataResult( result:SQLResult ):void
		{
			if (result.data == null)
			{
//				this.insertDefaultData();
			}
		}
		
		protected function insertDefaultData():void
		{
			throw new AbstractMethodError;
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
		
		//Functions
		private function executeBatch_progress(completedCount:uint, totalCount:uint):void
		{
			trace( "Progress completedCountd: " +  completedCount + " totalCount: " + totalCount);
		}
		
		private function executeBatch_complete(results:Vector.<SQLResult>):void
		{
			trace( "Batch Complete " + results.toString() );
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
		
		
	}
}