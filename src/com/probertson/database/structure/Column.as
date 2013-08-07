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
		
		override public function getCreateSyntax():String {
			return this._title + " "  + this._type;
		}
		
		override public function getInsertSyntax():String {
			return this._title;
		}
		
		override public function getUpdateSyntax( columnTitle:String, exclude:Object ):String {
			return this._title + " = :" + this._title;
		}
		
		override public function parameter():String
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