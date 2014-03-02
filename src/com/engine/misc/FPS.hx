package com.engine.misc ;


import flash.display.Stage;
import flash.Lib;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.events.Event;
import flash.system.System;
import flash.system.Capabilities;

/**
 * ...
 * @author djoker
 */

class FPS extends TextField
{
   var times:Array<Float>;
   var dpi:Float;
   var screenResolutionX:Float;
   var screenResolutionY:Float;
   var _mem : Float;
   var _mem_max : Float;
   
	   
		
   public function new(inX:Float=10.0, inY:Float=10.0, inCol:Int = 0x000000)
   {
      super();
      x = inX;
      y = inY;
      selectable = false;
     // defaultTextFormat = new TextFormat("_sans", 20, 0, true);
      text = "FPS:";
      textColor = inCol;
	  backgroundColor = 0xFFFFFF;
      width = 200;
      times = [];
	  _mem = 0;
	  _mem_max = getMemory();
	  dpi = Capabilities.screenDPI;
	  screenResolutionX = Capabilities.screenResolutionX;
	  screenResolutionY = Capabilities.screenResolutionY;
      addEventListener(Event.ENTER_FRAME, onEnter);
   }

   public function onEnter(Env:Event)
   {
	 	//_mem = cast ((System.totalMemory * 0.000000954)/*.toFixed(3)*/);
	   //_mem_max = _mem_max > _mem ? _mem_max : _mem;
						
	  
    var now = Lib.getTimer () / 1000;
      times.push(now);
      while(times[0]<now-1)
         times.shift();
      if (visible)
      {
         text = screenResolutionX + "x" + screenResolutionY + "x" +dpi +  "\nFPS:" + times.length + "/" + Lib.current.stage.frameRate +"\nmem:" + getMemory()+"/"+_mem_max;
      }
   }
         private function getMemory():Float
        {
	
			//return  cast (System.totalMemory /  1024 * 1024);// * 0.000000954);
			//return System.totalMemory * 1 / (1024 * 1024);
            return Math.round (System.totalMemory * 0.000000954); 
        }

}