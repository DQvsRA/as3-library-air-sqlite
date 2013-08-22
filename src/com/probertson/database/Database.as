package com.probertson.database
{
	import com.probertson.data.QueuedStatement;
	import com.probertson.data.SQLRunner;
	import com.probertson.database.errors.AbstractMethodError;
	import com.probertson.database.interfaces.IDatabase;
	
	import flash.errors.IllegalOperationError;
	import flash.errors.SQLError;
	import flash.filesystem.File;
	import flash.utils.Dictionary;
	import com.probertson.database.structure.AbstractDatabase;
	import com.probertson.database.structure.Syntax;
	import com.probertson.database.structure.Table;
	
	public class Database extends AbstractDatabase
	{
		private var _dbFile:File;
		private var _sqlRunner:SQLRunner; 
		private var _tablesDictionary:Dictionary;
		public var _sqlStmtsQueue:Vector.<QueuedStatement>;
		public var exists:Boolean;
		
		public var _createTableQueue:Vector.<Table>;
		
		public var _execute_complete:Function;
		public var _executeBatch_complete:Function;
		public var _executeBatch_progress:Function;
		public var _executeBatch_error:Function;
		
		
		public function Database( dbFileName:String )
		{
			if ( dbFileName != null )
			{ 
				this._name = dbFileName;
			} else { 
				throw new IllegalOperationError("Database must have a name."); 
			}
			
			this._executeBatch_complete = this.executeBatch_complete;
			this._executeBatch_progress = this.executeBatch_progress;
			this._executeBatch_error = this.executeBatch_error;
			this._execute_complete = this.execute_complete;
			
			this._dbFile = File.applicationStorageDirectory.resolvePath( dbFileName );
			this.exists = this._dbFile.exists;
			this._tablesDictionary = new Dictionary();
			this._sqlStmtsQueue = new Vector.<QueuedStatement>();
			this._createTableQueue = new Vector.<Table>();
			
			_sqlRunner = new SQLRunner( this._dbFile );
			
			this.createTableAndColumnStructure();
			
			if ( this.exists )
			{
				this.databaseExistsAlgorithm();
			} else {
				this.databaseNotExistsAlgorithm();
			}
		}
		
		
		//ALGORITHM TO CREATE A DATABASE
		
		protected function databaseExistsAlgorithm():void
		{
//			throw new AbstractMethodError;
		}
		
		protected function databaseNotExistsAlgorithm():void
		{
//			throw new AbstractMethodError;
		}
		
		protected function createTableAndColumnStructure():void 
		{
//			throw new AbstractMethodError;
		}
		
		public function createTablesInDatabaseFile(  ):void
		{
			throw new AbstractMethodError;
		}
		
		public function insertDefaultData():void
		{
			throw new AbstractMethodError;
		}
		
		/**
		 * Add Database Queue Statment to perform database functions -- CRUD 
		 * @param stmt
		 * 
		 */		
		public function addToStmtQueue( stmt:QueuedStatement ):void {
			
			this._sqlStmtsQueue.push( stmt );
		}
		
		/**
		 * Create a table in the database;  
		 * @param table
		 * @param exucuteImmediately to create to table immediately rather than pooling the execution for a later time.
		 * 
		 */	
		public function createTable( table:Table, exucuteImmediately:Boolean = false ):void 
		{
			this.addToStmtQueue( new QueuedStatement( table.getCreateSyntax() ));
			
			if (exucuteImmediately)
			{
				this.executeModify();
			}
			
		}
		
		public function insert( table:Table, data:Object, exucuteImmediately:Boolean = false ):void
		{
			this.addToStmtQueue( new QueuedStatement( table.getInsertSyntax(), data ));
			
			if (exucuteImmediately)
			{
				this.executeModify();
			}
		}
		
		
		public function update( table:Table, queryTitles:Vector.<String>, data:Object, exucuteImmediately:Boolean = false ):void
		{
			//			_db.addToStmtQueue( new QueuedStatement(userTable.getUpdateSyntax( "category", {id:false} ), {category:"self", firstName:"John", lastName:"Doe"}));
			this.addToStmtQueue( new QueuedStatement( table.getUpdateSyntax( queryTitles, data), data ));
			
			if (exucuteImmediately)
			{
				this.executeModify();
			}
		}
		
		public function deleteRecords( table:Table, data:Object, logicalOperator:String = Syntax.AND, exucuteImmediately:Boolean = false  ):void
		{
			//			_db.addToStmtQueue( new QueuedStatement(userTable.getUpdateSyntax( "category", {id:false} ), {category:"self", firstName:"John", lastName:"Doe"}));
			this.addToStmtQueue( new QueuedStatement( table.getDeleteRecordsSyntax( data, logicalOperator), data ));
			
			if (exucuteImmediately)
			{
				this.executeModify();
			}
		}
		
		
		
		// ------- Public methods ------- 
		public function close(resultHandler:Function):void 
		{ 
			_sqlRunner.close(resultHandler); 
		} 
		
		public function execute(sql:String, parameters:Object, handler:Function, itemClass:Class=null):void 
		{ 
			_sqlRunner.execute(sql, parameters, handler, itemClass); 
		}
		
		public function executeModify():void 
		{ 
			_sqlRunner.executeModify(this._sqlStmtsQueue, this.executeBatch_complete, this.executeBatch_error, this.executeBatch_progress); 
		}
		
		// ------- Event handling -------
		
		
		public function getFile():File
		{
			return this._dbFile;
		}
		
		/**
		 * <p>Add Tables to database</p>
		 * <p>Example:</p>
		 * <code> 
		 * 		var _db = new Database( "servers.db" ); </br>
		 * 		var st = new Table( "servers" ); </br>
		 * 		var _db.add( st );
		 * </code>
		 * 
		 * @param Table
		 * 
		 */
		override public function add( table:AbstractDatabase ):void
		{
			this._tablesDictionary[ table.name ] = table;
			table.setParent( this );
			this.length++;
			
			//Add to statement 
			this._createTableQueue.push( table );
		}
		
		public function addTablesToDatabase():void
		{
			for ( var k:Object in this._tablesDictionary ) {
				this.addToStmtQueue( new QueuedStatement( this._tablesDictionary[k].getCreateSyntax() ) );
			}
		}
		
		private function safeRemove(c:AbstractDatabase):void {
			if (c.getComposite()) {
				c.remove(c); // composite
			} else {
				c.removeParentRef();
			}
			
		}
		
		
		override public function remove( table:AbstractDatabase ):void
		{
			this.length--;
			if ( table === this ) {
				for ( var k:Object in this._tablesDictionary ) {
					safeRemove( this._tablesDictionary[k] );
					delete this._tablesDictionary[k];
				}
			} else {
				for ( var j:Object in this._tablesDictionary ) {
					if ( this._tablesDictionary[j] == table ) {
						safeRemove( this._tablesDictionary[j] );
						delete this._tablesDictionary[j];
					}
				}
			}
			
		}
		
		// RETURN FUNCTIONS
		public function executeBatch_progress(completedCount:uint, totalCount:uint):void
		{
			//			trace( "Progress completedCountd: " +  completedCount + " totalCount: " + totalCount);
		}
		
		public function executeBatch_complete(results:Object):void
		{
			while ( this._createTableQueue.length )
			{
				this._createTableQueue.pop();
			}
			
			while ( this._sqlStmtsQueue.length )
			{
				this._sqlStmtsQueue.pop();
			}
		}
		
		protected function executeBatch_error(error:SQLError):void
		{
			// handle the error as desired or bubble
			trace( error.toString() );
		}
		
		protected function execute_complete():void {
			
		}
		
		// GETTER AND SETTERS
		
		public function getTables():Dictionary
		{
			return this._tablesDictionary;
		}
		
		public function getTableByName( name:String ):Table
		{
			return this._tablesDictionary[ name ];
		}
		
		override public function getChildByName( tableName:String ):AbstractDatabase
		{
			return this._tablesDictionary[ tableName ];
		}
		
		public function getDataFromDatabase( tableName:String ):void
		{
			this.execute( this.getTables()[tableName].getSelectAllSyntax(), null, this.execute_complete, this.getTables()[tableName].itemClass );
		}

	}
}