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
		
		override public function insertRecord( columnTitle:String, dataObject:Object ):void {
			getColumnByTitle( columnTitle ).data( dataObject );
		}
		
		override public function deleteRow( reference:*, data:* ):void {
			//TODO needs implementation
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
		
		override public function getUpdateSyntax( columnTitle:String, exclude:Object ):String
		{
			var sql:String = Table.UPDATE + this.sName + " SET ";
			
			var colLen:int = aColumns.length;
			for (var i:int = 0; i < colLen; i++) {
		
				if ( aColumns[i].title != columnTitle && exclude[aColumns[i].title] == null ) { //do not include autoincrement primary key
					sql += aColumns[i].getInsertSyntax();
					sql += (i < colLen - 1) ? ", " : "";
				}
				
			}
			
			sql += " WHERE  " + String(columnTitle) + " = :" + String(columnTitle);
			
			
			
			return sql;
		}

		
		
		
	}
}