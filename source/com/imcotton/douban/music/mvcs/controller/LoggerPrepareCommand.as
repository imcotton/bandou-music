package com.imcotton.douban.music.mvcs.controller
{

import com.demonsters.debugger.MonsterDebuggerFlex;

import mx.core.IVisualElementContainer;
import mx.logging.ILogger;
import mx.logging.Log;
import mx.logging.targets.TraceTarget;

import org.robotlegs.mvcs.Command;


internal class LoggerPrepareCommand extends Command
{

    override public function execute ():void
    {
        Log.addTarget(new TraceTarget());
        IVisualElementContainer(this.contextView).addElement(new MonsterDebuggerFlex());
        this.injector.mapValue(ILogger, Log.getLogger("global"));
    }

}
}

