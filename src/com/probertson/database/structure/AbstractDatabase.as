/**
 * Created with IntelliJ IDEA.
 * User: Jerry_Orta
 * Date: 8/12/13
 * Time: 7:53 AM
 * To change this template use File | Settings | File Templates.
 */
package com.probertson.database.structure {


import com.probertson.database.errors.AbstractMethodError;


/**
 * Serves both as an Abstract Composite Class and Abstract Template Class.
 * @author Jerry_Orta
 * 
 */
public class AbstractDatabase {

    protected var _name:String;
    protected var parentNode:AbstractDatabase = null;
	protected var length:int = 0;
	private var _onComplete:Function;
	private var _onCompleteParams:Array;
	
    public function AbstractDatabase() {
		this._onCompleteParams = new Array();
	}

    public function get name():String
    {
        return _name;
    }

    public function set name( _val:String ):void
    {
        this._name = _val;
    }

    public function add(c:AbstractDatabase):void { throw new AbstractMethodError(); }
	

    public function remove(c:AbstractDatabase):void { throw new AbstractMethodError(); }

    public function getChildByName( name:String ):AbstractDatabase {
        throw new AbstractMethodError();
        return null;
    }

    public function getParent():AbstractDatabase {
        return this.parentNode;
    }

    public function setParent(compositeNode:AbstractDatabase):void {
        this.parentNode = compositeNode;
    }

    public function removeParentRef():void {
        this.parentNode = null;
    }

    public function getComposite():AbstractDatabase {
        return null;
    }
	
	public function set onComplete( func:Function ):void
	{
		this._onComplete = func;
	}
	
	protected function callBack():void 
	{
		if (this._onComplete != null)
		{
			this._onComplete.apply( null, ( this._onCompleteParams.length > 0 ? this._onCompleteParams : null ) );
		}
	}
	
	
	
	
}
}
