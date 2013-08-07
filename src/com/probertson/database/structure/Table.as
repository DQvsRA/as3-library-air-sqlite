package com.probertson.database.structure
{
	
	import com.probertson.database.structure.AbstractTable;
	import com.probertson.database.structure.Column;
	

	public class Table extends AbstractTable
	{
		
		/**
		 * CREATE TABLE IF NOT EXISTS
		 */
		public static const CREATE:String = "CREATE TABLE IF NOT EXISTS main.";
		public static const INSERT:String = "INSERT INTO main.";
		public static const UPDATE:String = "UPDATE main.";
		
		protected var sName:String;
		protected var aColumns:Array;
		protected var aRow:Array;
		
		public function Table( sNodeName:String )
		{
			this.sName = sNodeName;
			this.aColumns = new Array();
			this.aRow = new Array();
		}
		
		override public function addColumn(c:AbstractTable):void {
			aColumns.push(c);
		}

		

		
		private function getColumnByTitle( sTitle:String ):Column {
			for each (var c:Column in aColumns) {
				if (c.title == sTitle) {
					return c;
				}
			}
			return null;
		}
		
		override public function getColumn(n:int):AbstractTable { 
			if ((n > 0) && (n <= aColumns.length)) {
				return aColumns[n-1];
			} else {
				return null;
			}
		}
		
		override public function operation():void {
			for each (var c:AbstractTable in aColumns) {
				c.operation();
			}
		}
		
		/**
		 * <p>Returns SQL syntax to creat a table for SQLite to execute.</p>
		 * 
		 * <p>EXAMPLE: </br>
		 * <code>CREATE TABLE IF NOT EXISTS employees ( id INTEGER PRIMARY KEY AUTOINCREMENT, phone NUMBERIC, name TEXT )</code>
		 * </p>
		 * 
		 * 
		 */
		override public function getCreateSyntax():String
		{
			
			var sql:String = Table.CREATE + this.sName + " ( ";
			
			var colLen:int = aColumns.length;
			for (var i:int = 0; i < colLen; i++) {
				sql += aColumns[i].getCreateSyntax();
				sql += (i < colLen - 1) ? ", " : "";
			}
			
			sql += " )";
			
			return sql;
		}
		
	 	
		override public function getInsertSyntax():String
		{
			var sql:String = Table.INSERT + this.sName + " ( ";
			
			var colLen:int = aColumns.length;
			for (var i:int = 0; i < colLen; i++) {
				if ( aColumns[i].type != Column.INT_PK_AI ) { //do not include autoincrement primary key
					sql += aColumns[i].getInsertSyntax();
					sql += (i < colLen - 1) ? ", " : "";
				}
				
			}
			
			sql += " ) VALUES ( ";
			
			for (i = 0; i < colLen; i++) {
				if ( aColumns[i].type != Column.INT_PK_AI ) { //do not include autoincrement primary key
					sql += aColumns[i].parameter();
					sql += (i < colLen - 1) ? ", " : "";
				}
			}
			
			sql += " )";
			
			return sql;
		}
		
		/**
		 * <p>Get syntax to update a record in the database. The result will be similar to</p>
		 * 
		 * <code>UPDATE main.user SET firstName = :firstName, lastName = :lastName WHERE category = :category</code>
		 * 
		 * <p>A table is required to be instantiated before this method is called:</p>
		 * 
		 * <code>
		 *  var userTable = new Table( "user" );
		 *  userTable.addColumn( new Column( "id", Column.INT_PK_AI ) );
		 *  userTable.addColumn( new Column( "category", Column.TEXT ) );
		 *  userTable.addColumn( new Column( "firstName", Column.TEXT ) );
		 *  userTable.addColumn( new Column( "lastName", Column.TEXT ));
		 * </code>
		 * 
		 * <p>Get the parsed syntax, then by calling:</p>
		 * 
		 * <code>userTable.getUpdateSyntax( "category", {id:false} )</code>
		 *  
		 * @param columnTitle The Column Title which to target the update
		 * @param exclude Columns to exclude from the update. Format is {ColumnTitle:false}. The Column
		 * 			title (object property) is always set to false. Nothing is done to include a column.
		 * @return 
		 * 
		 */		
		override public function getUpdateSyntax( columnTitle:String, exclude:Object ):String
		{
			var sql:String = Table.UPDATE + this.sName + " SET ";
			
			var colLen:int = aColumns.length;
			for (var i:int = 0; i < colLen; i++) {
		
				if ( aColumns[i].title != columnTitle && exclude[aColumns[i].title] == null ) { //do not include autoincrement primary key
					sql += aColumns[i].getUpdateSyntax(null, null);
					sql += (i < colLen - 1) ? ", " : "";
				}
				
			}
			
			sql += " WHERE " + String(columnTitle) + " = :" + String(columnTitle);
			
			
			
			return sql;
		}

		
		
		
	}
}