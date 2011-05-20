package com.imcotton.douban.music.mvcs.model
{

import by.blooddy.crypto.MD5;

import com.imcotton.douban.music.data.PlayTypeEnum;

import flash.net.URLRequest;
import flash.net.URLVariables;


public class RemoteModel
{

    private static const PLAYLIST_URL:String = "http://douban.fm/j/mine/playlist";

    private static const SIGN_KEY:String = "fr0d0";

    [Inject]
    public var channelModel:IChannelModel;

    [Inject]
    public var playListModel:PlayListModel;

    [Inject]
    public var playHistoryModel:IPlayHistoryModel;

    public function createRenew ():URLRequest
    {
        var variables:Variables = new Variables()
                .setType(PlayTypeEnum.LIST_OUT)
                .setSID(this.playListModel.current.sid)
                .setHistory(this.playHistoryModel.historyString)
                .setChannelID(this.channelModel.current.id);

        return this.makeRequest(variables);
    }

    public function createNewChannel ($item:ChannelItem):URLRequest
    {
        var variables:Variables = new Variables()
                .setType(PlayTypeEnum.NEW_LIST)
                .setHistory(this.playHistoryModel.historyString)
                .setChannelID($item.id);

        return this.makeRequest(variables);
    }

    public function createSkip ():URLRequest
    {
        var variables:Variables = new Variables()
                .setType(PlayTypeEnum.SKIP_NEXT)
                .setSID(this.playListModel.current.sid)
                .setHistory(this.playHistoryModel.historyString)
                .setChannelID(this.channelModel.current.id);

        return this.makeRequest(variables);
    }

    public function createLikeUnlike ($item:PlayListItem, $isLike:Boolean):URLRequest
    {
        var variables:Variables = new Variables()
                .setType($isLike ? PlayTypeEnum.LIKE : PlayTypeEnum.UNLIKE)
                .setSID($item.sid)
                .setHistory(this.playHistoryModel.historyString)
                .setChannelID(this.channelModel.current.id);

        return this.makeRequest(variables);
    }

    public function createBan ($item:PlayListItem):URLRequest
    {
        var variables:Variables = new Variables()
                .setType(PlayTypeEnum.BAN)
                .setSID($item.sid)
                .setHistory(this.playHistoryModel.historyString)
                .setChannelID(this.channelModel.current.id);

        return this.makeRequest(variables);
    }

    public function createAlbumSiteRequest ():URLRequest
    {
        return new URLRequest
        (
            [
                "http://music.douban.com/subject/",
                this.playListModel.current.aid,
            ].join("")
        );
    }

    private function makeRequest ($variables:Variables):URLRequest
    {
        var request:URLRequest = new URLRequest(PLAYLIST_URL);
            request.data = $variables.urlVarables;

        $variables.setSign(this.sign(request))
                  .setMark();

        return request;
    }

    private function sign ($request:URLRequest):String
    {
        //  TODO: order sensitivity of GET parameter, maybe???

        var url:String =
        [
            $request.url,
            "?",
            URLVariables($request.data).toString(),
            SIGN_KEY,
        ].join("");

        return MD5.hash(url).substr(-10);
    }

}
}



import flash.net.URLVariables;


class Variables
{

    public function Variables ()
    {
        this.init();
    }

    public var urlVarables:URLVariables;

    public function setChannelID ($id:String):Variables
    {
        this.urlVarables.channel = $id;

        return this;
    }

    public function setType ($type:String):Variables
    {
        this.urlVarables.type = $type;

        return this;
    }

    public function setHistory ($history:String):Variables
    {
        this.urlVarables.h = $history;

        return this;
    }

    public function setSID ($sid:String):Variables
    {
        this.urlVarables.sid = $sid;

        return this;
    }

    public function setSign ($sign:String):Variables
    {
        this.urlVarables.r = $sign;

        return this;
    }

    public function setMark ():Variables
    {
        this.urlVarables.mark = "imcotton@air";

        return this;
    }

    private function init ():void
    {
        this.urlVarables = new URLVariables();
    }

}

