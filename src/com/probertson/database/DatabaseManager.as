package com.probertson.database
{
	
	
	import flash.utils.Dictionary;
	
	
	public class DatabaseManager
	{
		private var databaseDict:Dictionary;
		private static  var _instance:DatabaseManager;
		
		public function DatabaseManager( pvt:PrivateClass )
		{
			this.databaseDict = new Dictionary();
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
		
		public static function addDatabase( database:Database ):void
		{
			DatabaseManager.getInstance().databaseDict[ database.name ] = database;
		}
		
		/**
		 * Gets a database by file name. If data base does not exist, it creates a database. 
		 * @param databaseFilename
		 * @return 
		 * 
		 */		
		public static function getDatabase( databaseFilename:String ):Database
		{
			
			return DatabaseManager.getInstance().databaseDict[ databaseFilename ];
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