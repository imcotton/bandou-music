package com.imcotton.douban.music.mvcs.controller
{

import com.imcotton.douban.music.events.LoginEvent;
import com.imcotton.douban.music.mvcs.model.IChannelModel;
import com.imcotton.douban.music.mvcs.model.LoginModel;
import com.imcotton.douban.music.mvcs.service.ILoginService;
import com.imcotton.douban.music.mvcs.view.components.LoginView;

import mx.controls.Alert;
import mx.core.IFlexDisplayObject;
import mx.core.IUIComponent;
import mx.events.CloseEvent;
import mx.managers.PopUpManager;

import org.robotlegs.mvcs.Command;


public class LoginCommand extends Command
{
    
    [Inject]
    public var event:LoginEvent;
    
    [Inject]
    public var loginModel:LoginModel;
    
    [Inject]
    public var loginService:ILoginService;
    
    [Inject]
    public var channelModel:IChannelModel;
    
    override public function execute ():void
    {
        switch (this.event.type)
        {
            case LoginEvent.LOGIN:
            {
                var dialog:IFlexDisplayObject = PopUpManager.createPopUp
                    (
                        this.contextView,
                        LoginView,
                        true
                    );
                        
                PopUpManager.centerPopUp(dialog);
                
                this.mediatorMap.createMediator(dialog);
                
                break;
            }
            case LoginEvent.LOGOUT:
            {
                this.commandMap.detain(this);
                
                Alert.show
                (
                    "Are you sure to logout?",
                    "Logout",
                    Alert.YES | Alert.CANCEL,
                    null,
                    this.onClose,
                    null,
                    Alert.CANCEL
                    
                ).isPopUp = false;
                
                break;
            }
            case LoginEvent.ON_LOGIN:
            {
                this.channelModel.showPresonalChannel();
                break;
            }
        }
        
    }
    
    private function onClose (event:CloseEvent):void
    {
        if (event.detail == Alert.YES)
            this.loginService.logout();
        
        this.commandMap.release(this);
    }
    
}
}

