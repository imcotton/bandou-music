package com.imcotton.douban.music.mvcs.service
{

public interface ILoginService
{
    
    function login (email:String, password:String):void;
    function logout():void;
    
}
}

