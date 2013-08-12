/**
 * Created with IntelliJ IDEA.
 * User: Jerry_Orta
 * Date: 8/12/13
 * Time: 7:53 AM
 * To change this template use File | Settings | File Templates.
 */
package com.probertson.database.structure {


import com.probertson.database.errors.AbstractMethodError;

public class AbstractDatabase {

    protected var _name:String;
    protected var parentNode:AbstractDatabase = null;
	protected var length:int = 0;
	
    public function AbstractDatabase() {
		
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

    public function getChild( c:AbstractDatabase ):AbstractDatabase {
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
}
}
