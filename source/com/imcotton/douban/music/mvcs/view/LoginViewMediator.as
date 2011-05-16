package com.imcotton.douban.music.mvcs.view
{

import com.imcotton.douban.music.events.LoginEvent;
import com.imcotton.douban.music.mvcs.service.ILoginService;
import com.imcotton.douban.music.mvcs.view.components.LoginView;

import flash.events.Event;

import mx.managers.PopUpManager;

import org.robotlegs.mvcs.Mediator;


public class LoginViewMediator extends Mediator
{

    [Inject]
    public var view:LoginView;

    [Inject]
    public var loginService:ILoginService;

    override public function onRegister ():void
    {
        this.view.submitSignal.add(onSubmit);
        this.view.closeSignal.addOnce(onClose);

        this.addContextListener(LoginEvent.ON_LOGIN, onLoginEvent, LoginEvent);
        this.addContextListener(LoginEvent.LOGIN_FAIL, onLoginEvent, LoginEvent);
    }

    private function onLoginEvent (event:Event):void
    {
        switch (event.type)
        {
            case LoginEvent.ON_LOGIN:
            {
                this.onClose();
                break;
            }
            case LoginEvent.LOGIN_FAIL:
            {
                this.view.toTypeInState();
                break;
            }
        }
    }

    private function onSubmit ($email:String, $password:String):void
    {
        this.loginService.login($email, $password);
        this.view.toConnectState();
    }

    private function onClose ():void
    {
        this.preRemove();
        PopUpManager.removePopUp(this.view);
        this.onRemove();
    }

}
}

