package com.imcotton.douban.music.events
{

import flash.events.Event;


public class LoginEvent extends Event
{
    
    public static const LOGIN:String = "login";
    public static const LOGIN_FAIL:String = "loginFail";
    public static const ON_LOGIN:String = "onLogin";
    
    public static const LOGOUT:String = "logout";
    public static const ON_LOGOUT:String = "onLogout";
    
    public function LoginEvent ($type:String)
    {
        super($type);
    }
    
}
}

