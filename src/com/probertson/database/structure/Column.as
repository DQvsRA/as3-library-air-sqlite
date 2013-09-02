package com.probertson.database.structure
{
	
	
	import com.probertson.database.interfaces.ISyntax;
	
	/**
	 * Create Column SQLite syntax for databas operations. Specifically, 
	 * this class represents only one column in a table, and holds
	 * the column type as well the syntax generation to create and modify the column.
	 *  
	 * @author Jerry_Orta
	 * 
	 */
	public class Column extends AbstractDatabase implements ISyntax
	{
		public static const DROP_RECORD:String = "DROP";
		
		private var _title:String;
		private var _type:String;
		private var _insertData:Vector.<Object>;
		
		/**
		 * INTEGER PRIMARY KEY AUTOINCREMENT
		 */
		public static const INT_PK_AI:String = "INTEGER PRIMARY KEY AUTOINCREMENT";
		
		/**
		 * TEXT Column type
		 */
		public static const TEXT:String = "TEXT";
		
		/**
		 * NUMBERIC Column type
		 */
		public static const NUMERIC:String = "NUMBERIC";
		
		/**
		 *  NULL column tyupe
		 */		
		public static const NULL:String = "NULL";
		
		/**
		 * INTEGER Column type 
		 */		
		public static const INTEGER:String = "INTEGER";
		
		/**
		 * FLOAT Column type 
		 */		
		public static const FLOAT:String = "FLOAT";
		
		/**
		 * BLOB Column type 
		 */		
		public static const BLOB:String = "BLOB";
		
		/**
		 * NONE Column type 
		 */		
		public static const NONE:String = "NONE";
		
		
		public function Column(sColumnTitle:String, columnType):void {
			this._title = sColumnTitle;
			this.name = sColumnTitle;
			this._type = columnType;
		}
		
		public function insert( data:* ):void
		{
			_insertData.push( data );
		}
		
		
		public function operation():void {
			trace(this._title);
		}
		
		public function getCreateSyntax():String {
			return this._title + " "  + this._type;
		}
		
		public function getInsertSyntax():String {
			return this._title;
		}
		
		public function getUpdateSyntax():String {
			return this._title + " = :" + this._title;
		}
		
		public function getDeleteSyntax():String 
		{
			return this._title + " = :" + this._title;
		}
		
		public function getDropSyntax( title:String, exclude:Object ):String {
			return Column.DROP_RECORD;
		}
		
		public function parameter():String
		{
			return ":" + this._title;
		}
		
		public function get title():String {
			return _title;
		}
		
		public function get type():String
		{
			return _type;
		}
		
		
	}
}