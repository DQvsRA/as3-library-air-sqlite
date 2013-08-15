package com.probertson.database.structure
{
	
	import com.probertson.database.interfaces.ISyntax;
	
	import flash.utils.Dictionary;

/**
 *
 * Create Table SQLite syntax for database operations.  Specifically, 
 * this class represents only one table in a database, and holds the 
 * syntax generation to create and modify the table.
 *  
 * @author Jerry_Orta
 * 
 */
public class Table extends AbstractDatabase implements ISyntax
	{
		
		/**
		 * CREATE TABLE IF NOT EXISTS
		 */
		public static const CREATE:String = "CREATE TABLE IF NOT EXISTS main.";
		public static const INSERT:String = "INSERT INTO main.";
		public static const UPDATE:String = "UPDATE main.";
		public static const DROP_TABLE:String = "DROP TABLE IF EXISTS main.";
		public static const SELECT:String = "SELECT ";
	
		protected var aColumns:Array;
        protected var _columnsDictionary:Dictionary;
		public static var isCreated:Boolean = false;
		public var itemClass:Class;
		
		private var _lastRecordPK:int = 1;
		
		public function Table( columnTitle:String )
		{
			this._name = columnTitle;
            this._columnsDictionary = new Dictionary();
		}
		

		/**
		 * <p>Add a column to a table using new Column( [column title], [column type] ).</p>
		 * 
		 * <p>Example:</p>
		 * <code>db.getTableByName( serverTable ).add( new Column( "id", Column.INT_PK_AI ));</code>

		 * @param new Column( [column title], [column type] 
		 * 
		 */		
        override public function add( column:AbstractDatabase ):void
        {
            this._columnsDictionary[ column.name ] = column;
            column.setParent( this );
			this.length++;
        }
		
		/**
		 * <p>Add Columns to a table using an object, where the properties
		 * are the column titles, and values are the type of columns.</p>
		 * <p>Example:</p>
		 * <code>var userTable:String = "user"; </br>
			ut = new Table( userTable );</br>
			 * var userTableSchema:Object = {</br>
					"id" : Column.INT_PK_AI,</br>
					"category" : Column.TEXT,</br>
					"firstName" : Column.TEXT,</br>
					"lastName" : Column.TEXT</br>
			};</br></br>
			
			ut.addByObject( userTableSchema );</code> 
		 * @param Object
		 * 
		 */		
		public function addColumnsByObject( parameterObject:Object):void {
			for (var key:String in parameterObject) 
			{
				this.add( new Column( key, parameterObject[ key ] ));
			}
		}
		

        private function safeRemove(c:AbstractDatabase):void {
            if (c.getComposite()) {
                c.remove(c); // composite
            } else {
                c.removeParentRef();
            }
        }

        override public function getChildByName( columnName:String ):AbstractDatabase
        {
            return this._columnsDictionary[ columnName ];
        }
		
		public function getColumnByTitle( title:String):Column
		{
			return this._columnsDictionary[ title ];
		}

        override public function remove( column:AbstractDatabase ):void
        {
			this.length--;
            if ( column === this ) {
                for ( var k:Object in this._columnsDictionary ) {
                    safeRemove( this._columnsDictionary[k] );
                    delete this._columnsDictionary[k];
                }
            } else {
                for ( var j:Object in this._columnsDictionary ) {
                    if ( this._columnsDictionary[j] == column ) {
                        safeRemove( this._columnsDictionary[j] );
                        delete this._columnsDictionary[j];
                    }
                }
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
		public function getCreateSyntax():String
		{
			
			var sql:String = Table.CREATE + this.name + " ( ";

			var isFirst:Boolean = true;
			for ( var k:Object in this._columnsDictionary ) {
				if (!isFirst) {
					sql += ", "; 
				}
				sql += this._columnsDictionary[k].getCreateSyntax();
				isFirst = false;
			}
			
			sql += " )";
			return sql;
		}
		
	 	
		public function getInsertSyntax():String
		{
			var sql:String = Table.INSERT + this.name + " ( ";

			var isFirst:Boolean = true;
			for ( var j:Object in this._columnsDictionary ) {
				
				if ( this._columnsDictionary[j].type != Column.INT_PK_AI ) {
					if (!isFirst) {
						sql += ", "; 
					}
					sql += this._columnsDictionary[j].getInsertSyntax();
					isFirst = false;
				}
				
				
			}

			sql += " ) VALUES ( ";
			

			
			isFirst = true;
			for ( var k:Object in this._columnsDictionary ) {
				
				
				if ( this._columnsDictionary[k].type != Column.INT_PK_AI ) {
					if (!isFirst) {
						sql += ", "; 
					}
					sql += this._columnsDictionary[k].parameter();
					isFirst = false;
				} 
				
			}
			
			sql += " )";
			trace(sql);
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
		public function getUpdateSyntax( queryColumnTitles:Vector.<String>, data:Object ):String
		{
			
			var sql:String = Table.UPDATE + this.name + " SET ";
			var isFirst:Boolean = true;
			var len:int = queryColumnTitles.length;

		
			for ( var prop:String in data)
			{
				for (var j:int = 0; j < len; j++)
				{
					if ( queryColumnTitles[j] != prop )
					{
						if (!isFirst) {	sql += ", "; }
						sql += this._columnsDictionary[ prop ].getUpdateSyntax();
						isFirst = false;
					}
				}			
			}


			sql += " WHERE ";
			
			for (var q:int = 0; q < len; q++) {
				sql += queryColumnTitles[q] + " = :" + queryColumnTitles[q];
			}

			return sql;
		}

        public function getDropSyntax( columnTitle:String, exclude:Object ):String {
            return Table.DROP_TABLE + this.name;
        }
		
		public function getSelectAllSyntax():String 
		{
			var sql:String = Table.SELECT;
			
			var isFirst:Boolean = true;
			for ( var j:Object in this._columnsDictionary ) {
				if (!isFirst) {
					sql += ", "; 
				}
				sql += this._columnsDictionary[j].title;
				isFirst = false;
			}
			
			sql += " FROM main." + this._name;
			trace( sql );
			return sql;
		}
	}
}