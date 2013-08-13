package com.probertson.database.structure
{
	import com.probertson.data.QueuedStatement;
	import com.probertson.data.SQLRunner;
	import com.probertson.database.interfaces.IDatabase;
	
	import flash.errors.IllegalOperationError;
	import flash.filesystem.File;
	import flash.utils.Dictionary;
	
	public class Database extends AbstractDatabase implements IDatabase
	{
		private var _dbFile:File;
		private var _sqlRunner:SQLRunner; 
        private var _tablesDictionary:Dictionary;
		public var _sqlStmtsQueue:Vector.<QueuedStatement>;
		public var exists:Boolean;

		public var _createTableQueue:Vector.<Table>;
		
		public var executeBatch_complete:Function;
		public var executeBatch_progress:Function;
		public var executeBatch_error:Function;
		
		public function Database( dbFileName:String )
		{
			if ( dbFileName != null )
			{ 
				this._name = dbFileName;
			} else { 
				throw new IllegalOperationError("Database must have a name."); 
			}

			this._dbFile = File.applicationStorageDirectory.resolvePath( dbFileName );
			this.exists = this._dbFile.exists;
            this._tablesDictionary = new Dictionary();
			this._sqlStmtsQueue = new Vector.<QueuedStatement>();
			this._createTableQueue = new Vector.<Table>();
			_sqlRunner = new SQLRunner( this._dbFile );

		}
		
		
		public function addToStmtQueue( stmt:QueuedStatement ):void {
			this._sqlStmtsQueue.push( stmt );
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

        //Abstract functonality
        //Abstract functonality
        //Abstract functonality

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