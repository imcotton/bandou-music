package com.imcotton.douban.music.mvcs.service
{

import com.imcotton.douban.music.events.LoginEvent;
import com.imcotton.douban.music.mvcs.model.LoginModel;

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.URLRequestHeader;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;
import flash.text.TextField;

import org.as3commons.lang.StringUtils;
import org.robotlegs.mvcs.Actor;


public class LoginService extends Actor implements ILoginService
{

    [Inject]
    public var loginModel:LoginModel;

    public function LoginService ()
    {
        this.init();
    }

    private var loader:URLLoader;

    private var request:URLRequest;
    private var logoutRequest:URLRequest;

    public function login ($email:String, $password:String):void
    {
        this.cancel();

        var variables:URLVariables = new URLVariables();
            variables.source = "radio";
            variables.form_email = $email;
            variables.form_password = $password;

        this.request.data = variables;
        this.loader.load(this.request);
        this.request.data = null;
    }

    public function logout ():void
    {
        new URLLoader(this.logoutRequest);
        this.loginModel.reset();
        this.dispatch(new LoginEvent(LoginEvent.ON_LOGOUT));
    }

    private function parse ($page:String):void
    {
        if (!$page)
        {
            this.dispatch(new LoginEvent(LoginEvent.LOGIN_FAIL));
            return;
        }

        var list:Array = $page.split(/\n/);

        for each (var item:String in list)
        {
            item = StringUtils.trim(item);

            if (item.indexOf("uid:") != -1)
            {
                this.loginModel.uid = item.match(/\buid:.*['|"](.+)['|"]/)[1];
            }

            if (item.indexOf('id="fm-user"') != -1)
            {
                var tf:TextField = new TextField();
                    tf.htmlText = item;
                this.loginModel.name = StringUtils.trim(tf.text);
            }

            if (/\bck=/.test(item))
            {
                this.logoutRequest = new URLRequest(item.match(/["|'](.*)["|']/)[1]);
                this.logoutRequest.requestHeaders = [new URLRequestHeader("Referer", "http://www.douban.com")];

                this.loginModel.ck = item.match(/\bck=(.*)['|"]/)[1];
            }
        }

        this.dispatch(new LoginEvent
        (
            this.loginModel.hasLogin ? LoginEvent.ON_LOGIN : LoginEvent.LOGIN_FAIL
        ));
    }

    private function cancel ():void
    {
        if (!this.loader)
            return;

        try { this.loader.close() }
        catch (error:Error) { }
    }

    private function init ():void
    {
        this.request = new URLRequest("https://www.douban.com/accounts/login");
        this.request.method = URLRequestMethod.POST;

        this.loader = new URLLoader();
        this.loader.addEventListener(Event.COMPLETE, loader_onEvent);
        this.loader.addEventListener(IOErrorEvent.IO_ERROR, loader_onEvent);
    }

    private function loader_onEvent (event:Event):void
    {
        switch (event.type)
        {
            case Event.COMPLETE:
            {
                this.parse(event.target.data);
                break;
            }
            case IOErrorEvent.IO_ERROR:
            {
                break;
            }
        }
    }

}
}

