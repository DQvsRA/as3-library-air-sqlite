package com.probertson.database
{
	
	import com.probertson.database.interfaces.IDatabase;
	
	import flash.errors.IllegalOperationError;
	
	public class DatabaseManager
	{
		private var _databaseArray:Vector.<IDatabase>;
		private static  var _instance:DatabaseManager;
		
		public function DatabaseManager( pvt:PrivateClass )
		{
			this._databaseArray = new Vector.<IDatabase>();
		}
		
		//Singleton constructor method

		public function get databaseArray():Vector.<IDatabase>
		{
			return _databaseArray;
		}

		public static  function getInstance ():DatabaseManager
		{
			if (DatabaseManager._instance == null)
			{
				DatabaseManager._instance = new DatabaseManager( new PrivateClass  );
				trace ("DatabaseManager instantiated");
			}
			return DatabaseManager._instance;
		}
		

		public static function addDatabase( _database:IDatabase ):void
		{
			DatabaseManager.getInstance().databaseArray.push( _database );
		}
		
		public static function getDatabase( databaseFilename:String ):IDatabase
		{
			var dbLen:int = DatabaseManager._instance.databaseArray.length;
			var db:IDatabase;
			for ( var i:int = 0; i < dbLen; i++ )
			{
				if ( DatabaseManager._instance.databaseArray[i].dbFilename == databaseFilename )
				{
					db = DatabaseManager._instance.databaseArray[i];
					break;
				}
			}
			
			if ( db == null )
			{
				throw new IllegalOperationError( databaseFilename + " does not exist in DatabaseManager."); 
			}
			
			return db;
		}
		
	}
}

class PrivateClass
{
	public function PrivateClass ()
	{
		trace ("PrivateClass called");
	}
}