package com.probertson.database
{
	import com.probertson.data.QueuedStatement;
	import com.probertson.data.SQLRunner;
	import com.probertson.database.interfaces.IDatabase;
	import com.probertson.database.structure.AbstractDatabase;
	
	import flash.data.SQLConnection;
	import flash.data.SQLStatement;
	import flash.errors.IllegalOperationError;
	import flash.filesystem.File;
	import flash.net.Responder;
	import flash.utils.Dictionary;
	
	public class Database extends AbstractDatabase implements IDatabase
	{
		private var _conn:SQLConnection = new SQLConnection();
		private var _dbFile:File; 
		private var _sqlRunner:SQLRunner; 
        private var _tablesDictionary:Dictionary;
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
				this._name = dbFileName;
			} else { 
				throw new IllegalOperationError("Database must have a name."); 
			}

			this._dbFile = File.applicationStorageDirectory.resolvePath( dbFileName );
            this._tablesDictionary = new Dictionary();
			this._sqlStmtsQueue = new Vector.<SQLStatement>;
			this._statementTracker = new Dictionary();
			
			_sqlRunner = new SQLRunner( this._dbFile );
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
		
		public function executeModify(statementBatch:Vector.<QueuedStatement> = null, resultHandler:Function = null, errorHandler:Function = null, progressHandler:Function = null):void 
		{ 
			_sqlRunner.executeModify(statementBatch, resultHandler, errorHandler, progressHandler); 
		}

        public function getFile():File
        {
            return this._dbFile;
        }

        //Abstract functonality
        //Abstract functonality
        //Abstract functonality

		override public function add( table:AbstractDatabase ):void
		{
            this._tablesDictionary[ table.name ] = table;
            table.setParent( this );
			this.length++;
		}

        private function safeRemove(c:AbstractDatabase):void {
            if (c.getComposite()) {
                c.remove(c); // composite
            } else {
                c.removeParentRef();
            }
			
        }

        override public function getChild( table:AbstractDatabase ):AbstractDatabase
        {
            return this._tablesDictionary[ table.name ];
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


    }
}