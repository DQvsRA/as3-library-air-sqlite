package com.probertson.database
{
	import com.probertson.data.QueuedStatement;
	import com.probertson.data.SQLRunner;
	import com.probertson.database.interfaces.IDatabase;
	
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.errors.IllegalOperationError;
	import flash.errors.SQLError;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	import flash.net.Responder;
	import flash.utils.Dictionary;
	
	public class Database implements IDatabase
	{
		private var _dbFilename:String;
		private var _conn:SQLConnection = new SQLConnection(); 
		private var _dbFile:File; 
		private var _sqlRunner:SQLRunner; 
		private var _tables:Vector.<String>;
		private var _sqlStmtsQueue:Vector.<SQLStatement>;
		private var _sqlStmtCount:int = 0;
		private var _tableCreateResponder:Responder;
		private var _statementTracker:Dictionary;
		private var _creatTableCallback:Function;
		
		private var _resultHandler:Function;
		private var _errorHandler:Function;
		private var _progressHandler:Function;
		
		public function Database( dbFileName:String )
		{
			

			
			if ( dbFileName != null ) 
			{ 
				this._dbFilename = dbFileName;
			} else { 
				throw new IllegalOperationError("Database must have a name."); 
			}

			this._dbFile = File.applicationStorageDirectory.resolvePath( dbFileName ); 
			this._tables = new Vector.<String>;
			this._sqlStmtsQueue = new Vector.<SQLStatement>;
			this._statementTracker = new Dictionary();
			
			_sqlRunner = new SQLRunner( this._dbFile );
			
			_tableCreateResponder = new Responder( onCreateTableResult, onCreateTableError );
			
//			_conn.addEventListener(SQLEvent.OPEN, openHandler); 
//			_conn.addEventListener(SQLErrorEvent.ERROR, errorHandler); 
//			_conn.addEventListener(SQLEvent.CLOSE, closeHandler);
			

			_conn.openAsync( _dbFile ); 
			
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
		
		public function executeModify(statementBatch:Vector.<QueuedStatement>, resultHandler:Function, errorHandler:Function, progressHandler:Function):void 
		{ 
			_sqlRunner.executeModify(statementBatch, resultHandler, errorHandler, progressHandler); 
		} 
		
		

		public function addTable( table:String ):void
		{
			this._tables.push( table );
		}
		
		
		
		public function executeCreateTables( callback:Function = null):void {
			this._creatTableCallback = callback;
			
			var len:int = _tables.length;
			for (var i:int = 0; i < len; i++ )
			{
				var createStmt:SQLStatement = new SQLStatement(); 
				createStmt.sqlConnection = this._conn; 
				createStmt.text = this._tables[i];
				this._sqlStmtsQueue.push( createStmt );
				_sqlStmtCount++;
			}
			
			for (i = 0; i < len; i++) 
			{
	
				this._sqlStmtsQueue[i].execute( -1, _tableCreateResponder );
			}
		}
		
		
		private function onCreateTableResult(result:SQLResult):void 
		{ 
			_sqlStmtCount--;
			
			if (_sqlStmtCount == 0) 
			{
				
				if (this._creatTableCallback != null) { this._creatTableCallback.apply(null, null); };
				
				while ( this._sqlStmtsQueue.length )
				{
					this._sqlStmtsQueue.pop();
				}
				
				
				
			}
		} 
		
		private function onCreateTableError(error:SQLError):void 
		{ 
			// do something after the statement execution fails 
		} 
		
		
		public function getFile():File
		{
			return this._dbFile;
		}

		public function get dbFilename():String
		{
			return _dbFilename;
		}
		
		
		/*
		protected function closeHandler(event:SQLEvent):void
		{
			_conn.removeEventListener(SQLEvent.CLOSE, closeHandler);		
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
*/
		

	}
}