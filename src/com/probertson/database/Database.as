package com.probertson.database
{
	import com.probertson.database.interfaces.IDatabase;
	
	import flash.data.SQLConnection;
	import flash.data.SQLStatement;
	import flash.errors.IllegalOperationError;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	
	public class Database implements IDatabase
	{
		private var _dbFilename:String;
		private var _conn:SQLConnection = new SQLConnection(); 
		private var _dbFile:File; 

		
		public function Database( dbFileName:String )
		{
			if ( dbFileName != null ) 
			{ 
				this._dbFilename = dbFileName;
			} else { 
				throw new IllegalOperationError("Database must have a name."); 
			}

			this._dbFile = File.applicationStorageDirectory.resolvePath( dbFileName ); 
			
			_conn.addEventListener(SQLEvent.OPEN, openHandler); 
			_conn.addEventListener(SQLErrorEvent.ERROR, errorHandler); 

			_conn.openAsync( _dbFile ); 
			
		}
		
		public function createTable( table:String ):void
		{
			var createStmt:SQLStatement = new SQLStatement(); 
			createStmt.sqlConnection = this._conn; 
			createStmt.text = table; 
			createStmt.execute(); 
			createStmt = null;
		}
		
		public function getFile():File
		{
			return this._dbFile;
		}

		public function get dbFilename():String
		{
			return _dbFilename;
		}
		
		public function disconnect():void
		{
			_conn.close();
			_conn.removeEventListener(SQLEvent.OPEN, openHandler); 
			_conn.removeEventListener(SQLErrorEvent.ERROR, errorHandler); 
			_conn = null;

		}
		
		private function openHandler(event:SQLEvent):void 
		{ 
			trace("the database " +  this._dbFilename + " was created successfully"); 
		} 
		
		private function errorHandler(event:SQLErrorEvent):void 
		{ 
			trace("Error message:", event.error.message); 
			trace("Details:", event.error.details); 
		} 

		

	}
}