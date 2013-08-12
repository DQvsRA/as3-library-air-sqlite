package com.probertson.database
{
	
	import com.probertson.database.interfaces.IDatabase;
	
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
		

		public static function addDatabase( _database:Database ):void
		{
            DatabaseManager.getInstance().databaseDict[ _database.name ] = _database;
		}
		
		public static function getDatabase( databaseFilename:String ):IDatabase
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