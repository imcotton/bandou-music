package com.imcotton.douban.music.data
{

import com.imcotton.douban.music.mvcs.model.PlayListItem;


public class PlayListJSONParser
{

    public function parseJSON ($array:Array):Vector.<PlayListItem>
    {
        var item:PlayListItem;
        var list:Vector.<PlayListItem> = new Vector.<PlayListItem>();

        for each (var i:Object in $array)
        {
            item = new PlayListItem();

            item.aid = i.aid;
            item.sid = i.sid;
            item.artistName = i.artist;

            item.albumName = i.albumtitle;
            item.albumCoverURL = i.picture;

            item.songURL = i.url;
            item.songName = i.title;
            item.songDuration = parseInt(i.length);

            list.push(item);
        }

        return list;
    }

}
}

