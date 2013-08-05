package com.probertson.database.structure
{
	import flash.utils.Dictionary;

	public class Column extends AbstractTable
	{
		private var _title:String;
		private var _type:String;
		private var _data:Dictionary;
		
		/**
		 * INTEGER PRIMARY KEY AUTOINCREMENT
		 */
		public static const INT_PK_AI:String = "INTEGER PRIMARY KEY AUTOINCREMENT";
		
		/**
		 * TEXT
		 */
		public static const TEXT:String = "TEXT";
		
		/**
		 * NUMBERIC
		 */
		public static const NUMERIC:String = "NUMBERIC";
		
		public function Column(sColumnTitle:String, sColumnType):void {
			this._title = sColumnTitle;
			this._type = sColumnType;
			this._data = new Dictionary();
		}
		
		public function data(sData:Object):void {
//			trace( "COLUMN DATA: " + sData.id + ", " + encodeURIComponent( sData.data ));
			this._data[sData.id] = sData.data;
		}
		
		override public function operation():void {
			trace(this._title);
		}
		
		override public function create():String {
			return this._title + " "  + this._type;
		}
		
		public function get title():String {
			return _title;
		}
		
		
	}
}