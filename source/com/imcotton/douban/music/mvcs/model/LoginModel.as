package com.imcotton.douban.music.mvcs.model
{
import mx.utils.StringUtil;


public class LoginModel
{
    
    public var ck:String;
    public var uid:String;
    public var name:String;

    public function get hasLogin ():Boolean
    {
        return this.uid && this.uid != "0";
    }
    
    public function reset ():void
    {
        this.ck = this.name = this.uid = "";
    }
    
    public function toString ():String
    {
        return StringUtil.substitute
        (
            "[LoginModel name={0} uid={1} ck={2}]",
            this.name,
            this.uid,
            this.ck
        );
    }

}
}

