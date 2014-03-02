
package com.engine.misc ;


import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import flash.system.System;
import flash.text.StyleSheet;
import flash.text.TextField;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.Lib;    
import flash.xml.XML;

/**
* <b>Hi-ReS! Stats</b> FPS, MS and MEM, all in one.
*/
typedef Theme = { bg: UInt, fps: UInt, ms: UInt, mem: UInt, memmax: UInt }

class Stats extends Sprite
{      
		private var _xml : XML;

		private var _text : TextField;
		private var _style : StyleSheet;

		private var _timer : Int;
		private var _fps : Int;
		private var _ms : Int;
		private var _ms_prev : Int;
		private var _mem : Float;
		private var _mem_max : Float;
	   
		private var _graph : BitmapData;
		private var _rectangle : Rectangle;
	   
		private var _fps_graph : UInt;
		private var _mem_graph : UInt;
		private var _mem_max_graph : UInt;
	   
		private var _theme : Theme;

		private var frames:Int;
		public function new(  ) : Void
		{
			super();
		
				addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
		}

		private function init(e : Event) : Void
		{
				removeEventListener(Event.ADDED_TO_STAGE, init);
			   
					_theme = { bg: 0x000033, fps: 0xffff00, ms: 0x00ff00, mem: 0x00ffff, memmax: 0xff0070 }
		
			//	graphics.beginFill(_theme.bg);
			//	graphics.drawRect(0, 0, 70, 50);
			//	graphics.endFill();

				_mem_max = 0;
				frames = 0;

			//	_xml = new XML('<xml><fps>FPS:</fps><ms>MS:</ms><mem>MEM:</mem><memMax>MAX:</memMax></xml>');
	   
		 _timer =0;
		 _fps =0;
	    _ms = 0;
		_ms_prev = 0;
		 _mem = 0;
		 _mem_max =0 ;
		

				_text = new TextField();
				_text.width = 70;
				_text.height = 50;
				_text.selectable = false;
				_text.mouseEnabled = false;
				// _text.defaultTextFormat = new TextFormat("_sans", 10, 0, true);
 
      _text.textColor = 0xffff00;
	  _text.backgroundColor = 0xFFFFFF;
		
			   
				var bitmap : Bitmap = new Bitmap( _graph = new BitmapData(70, 50, false, _theme.bg) );
				bitmap.y = 50;
			//	addChild(bitmap);
			   
				_rectangle = new Rectangle( 0, 0, 1, _graph.height );                  
				addChild(_text);	   
		
				addEventListener(Event.ENTER_FRAME, update);
		}

		private function update(e : Event) : Void
		{
				_timer = Lib.getTimer();
				var caption:String="";
			     caption = "FPS: " + _fps_graph + " / " + stage.frameRate + "\n" + "MEM: " + _mem + "\n" + "MAX: " + _mem_max + "\nMS: " + (_timer - _ms);
			
				if( _timer - 1000 >  _ms_prev )
				{
						_ms_prev = _timer;
						_mem = cast ((System.totalMemory * 0.000000954)/*.toFixed(3)*/);
						_mem_max = _mem_max > _mem ? _mem_max : _mem;
					   
						_fps_graph = Std.int(Math.min( 50, ( _fps / stage.frameRate ) * 50 ));
						_mem_graph =  Std.int(Math.min( 50, Math.sqrt( Math.sqrt( _mem * 5000 ) ) ) ) - 2;
						_mem_max_graph =  Std.int(Math.min( 50, Math.sqrt( Math.sqrt( _mem_max * 5000 ) ) ) ) - 2;
					   
						_graph.scroll( 1, 0 );
					   
						_graph.fillRect( _rectangle , _theme.bg );
						_graph.setPixel( 0, _graph.height - _fps_graph, _theme.fps);
						_graph.setPixel( 0, _graph.height - ( ( _timer - _ms ) >> 1 ), _theme.ms );
						_graph.setPixel( 0, _graph.height - _mem_graph, _theme.mem);
						_graph.setPixel( 0, _graph.height - _mem_max_graph, _theme.memmax);
					   
						
					   
						_fps = 0;
				}

				_fps++;
				_ms = _timer;
			   _text.text = caption;
			//	_text.htmlText = _xml.toXMLString();
		}
	   

		// .. Utils
	   
		private function hex2css( color : Int ) : String
		{
				return "#" + StringTools.hex(color);
		}
}