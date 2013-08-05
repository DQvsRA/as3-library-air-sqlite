package com.probertson.database.structure
{
	
	import com.probertson.database.structure.AbstractTable;
	import com.probertson.database.structure.Column;
	

	public class Table extends AbstractTable
	{
		
		/**
		 * CREATE TABLE IF NOT EXISTS
		 */
		public static const CREATE:String = "CREATE TABLE IF NOT EXISTS ";
		
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
		
		override public function addRow( columnTitle:String, dataObject:Object ):void {
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
		
		//TODO create colu
		override public function create():String
		{
			
			var sql:String = Table.CREATE + this.sName + " ( ";
			
			//Add each column
			for each (var c:AbstractTable in aColumns) {
				sql += c.create() + ", ";
			}
			
			sql = sql.substring(0, sql.length - 2) + " )";
			
			return sql;
		}

		
		
		
	}
}