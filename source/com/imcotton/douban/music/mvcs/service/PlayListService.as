package com.imcotton.douban.music.mvcs.service
{

import by.blooddy.crypto.serialization.JSON;

import com.imcotton.douban.music.data.PlayListJSONParser;
import com.imcotton.douban.music.mvcs.model.ChannelItem;
import com.imcotton.douban.music.mvcs.model.IChannelModel;
import com.imcotton.douban.music.mvcs.model.PlayListModel;
import com.imcotton.douban.music.mvcs.model.RemoteModel;

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.net.URLLoader;

import org.robotlegs.mvcs.Actor;


public class PlayListService extends Actor implements IPlayListService
{

    [Inject]
    public var remoteModel:RemoteModel;

    [Inject]
    public var channelModel:IChannelModel;

    [Inject]
    public var playListModel:PlayListModel;

    [Inject]
    public var playListJSONParser:PlayListJSONParser;

    public function PlayListService ()
    {
        this.init();
    }

    private var loader:URLLoader;

    public function renewChannel ():void
    {
        this.cancel();

        this.loader.load(this.remoteModel.createRenewRequest());
    }

    public function switchChannel ($item:ChannelItem):void
    {
        this.cancel();

        this.loader.load(this.remoteModel.createNewChannelRequest($item));
    }

    public function skip ():void
    {
        this.cancel();

        this.loader.load(this.remoteModel.createSkipRequest());
    }

    private function cancel ():void
    {
        if (!this.loader)
            return;

        try
        {
            this.loader.close();
        }
        catch (error:Error)
        {
            //  don't go anywhere
        }
    }

    private function init ():void
    {
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
                var json:Object = JSON.decode(this.loader.data);
                var arr:Array = json.song;

                if (arr && arr.length)
                    this.playListModel.update(this.playListJSONParser.parseJSON(arr));

                break;
            }
            case IOErrorEvent.IO_ERROR:
            {
                //  TODO: retry
                break;
            }
        }
    }

}
}

