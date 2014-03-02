package com.engine.game;



import com.engine.particles.ParticleSystem;
import com.engine.render.BlendMode;
import com.engine.render.Camera;
import com.engine.render.Texture;
import com.engine.render.filter.Filter;
import com.engine.math.Vector2;
import com.engine.misc.Util;
import com.engine.ui.Text;
import com.engine.input.Touch;
import com.engine.tween.Tweener;
import com.engine.tween.Tween;
import flash.display.Stage;

import com.engine.render.PrimitiveShader;
import com.engine.render.SpriteShader;


import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.events.TouchEvent;
import flash.geom.Rectangle;
import flash.Lib;
import flash.ui.Multitouch;
import flash.ui.MultitouchInputMode;

import openfl.display.OpenGLView;
import openfl.gl.GL;

import flash.geom.Matrix;
import flash.geom.Matrix3D;
import flash.geom.Point;




/**
 * ...
 * @author djoker
 * http://code-haxe.co.nf/
 */
class Game extends OpenGLView
{

public static var viewWidth:Int = 0;
public static var viewHeight:Int = 0;
public static var game:Game;
public static var now:Int = 0;
public static var then:Int = 0;
public static var frameStart:Int = 0;
public static var fps:Int = 0;
public static var dt:Float = 0;
public static var frames:Int = 0;
public static var fixedTimestep:Bool=true;
public static var camera:Camera;


public static var primitiveShader:PrimitiveShader;
public static var spriteShader:SpriteShader;
	
	private var ready:Bool;
	public var deltaTime:Float;
    private var prevFrame:Int;
    private var nextFrame:Int; 
	private var mMultiTouch:Bool;
	private var screen:Screen = null;
	private var container:Sprite;
	//value from the windows resize
	public var screenWidth:Int = 0;
	public var screenHeight:Int = 0;
	//values from the game initiate
	public var gameWidth:Int=0;
	public var gameHeight:Int = 0;

	private var keys:Array<Int>;
	private var _touches:Map<Int,Touch>;
	private var _touchNum:Int;
	


	
	private var rescale:Bool = false;
	private var enableDepth:Bool;
    public var red:Float;
    public var green:Float;
    public var blue:Float;
	private var textures:Map<String,Texture>;
	private var requestedFramerate:Int;
	private var gameObjects:List<GameObject>;	
	private var tweener:Tweener;
	

	public function fixRatio(w:Int, h:Int)
	{
		rescale = true;
		gameWidth = w;
		gameHeight = h;
	}

	public function new() 
	{

	super();
	
	
	Game.game = this;
	ready = false;
    this.render = renderView;
   
	
	
		screenWidth = Lib.current.stage.stageWidth;
		screenHeight = Lib.current.stage.stageHeight;
		requestedFramerate = Std.int(Lib.current.stage.frameRate);
	    viewWidth = screenWidth;
		viewHeight = screenHeight;
		gameWidth = screenWidth;
	    gameHeight = screenHeight;
		Game.camera = new Camera(screenWidth, screenHeight);
		Game.primitiveShader = new  PrimitiveShader();
        Game.spriteShader = new SpriteShader();
	
		gameObjects = new List<GameObject>();
	
		textures= new  Map<String,Texture>();
	
		
	tweener = new Tweener();
	
	keys = new Array<Int>();
	for (i in 0...255 )
	{
		keys.push(0);
	}
	

	stage.addEventListener(Event.RESIZE, onResize);
	stage.addEventListener(Event.ADDED, focusGained);
	stage.addEventListener(Event.DEACTIVATE, focusLost);
	
	
	container = new Sprite();
	container.addEventListener(Event.ADDED_TO_STAGE, addedToStage);		
	stage.addChild(container);

	//addChild(new Stats());
	prevFrame = Lib.getTimer();
	
	

	
	}
	
	public function setDeph(v:Bool)
	{
		enableDepth = v;
		if (v == true)
		{
		 GL.disable(GL.DEPTH_TEST);
		} else
		{
		GL.enable(GL.DEPTH_TEST);
		GL.depthFunc(GL.FASTEST);
    	}
	}
	public function clarColor(r:Float, g:Float, b:Float)
	{
		red = r;
		green = g;
		blue = b;
	}
	
	public	function removeChild(child : DisplayObject)
	{
		container.removeChild(child);
	}
	
	public function addChild(child : DisplayObject) 
  {
	  container.addChild(child);
  }
		
  
  
	private function addedToStage(e:Event)
	{
  	
	mMultiTouch = Multitouch.supportsTouchEvents;
    if (mMultiTouch) Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
  //  trace("Using multi-touch : " + mMultiTouch);
	
	
	
	Lib.current.stage.addEventListener (MouseEvent.MOUSE_DOWN, doMouseDown);
	Lib.current.stage.addEventListener (MouseEvent.MOUSE_MOVE, doMouseMove);
	Lib.current.stage.addEventListener (MouseEvent.MOUSE_UP, doMouseUp);
    Lib.current.stage.addEventListener (KeyboardEvent.KEY_DOWN, stage_onKeyDown);
	Lib.current.stage.addEventListener (KeyboardEvent.KEY_UP, stage_onKeyUp);
	//Lib.current.stage.addEventListener (Event.ENTER_FRAME, onEnterFrame);
	
		
	
	if (mMultiTouch)
	{
	Lib.current.stage.addEventListener(TouchEvent.TOUCH_BEGIN, doTouchDown);
    Lib.current.stage.addEventListener(TouchEvent.TOUCH_MOVE, doTouchMove);
    Lib.current.stage.addEventListener(TouchEvent.TOUCH_END, doTouchUp);
	_touchNum = 0;
	_touches = new Map<Int,Touch>();	
	} 
	
	
	 
	 
 
 		  
		   //
    GL.disable(GL.CULL_FACE);
    GL.enable(GL.BLEND);
	GL.blendFunc(GL.SRC_ALPHA,GL.DST_ALPHA );
	GL.pixelStorei(GL.PACK_ALIGNMENT, 2);
//	GL.enable(GL.DEPTH_TEST);
    setDeph(true);
	clarColor(0, 0, 0.4);
	GL.clearColor(red, green, blue, 1);
	GL.depthMask(true);
	GL.colorMask(true, true, true, true);
	GL.activeTexture(GL.TEXTURE0);
		 
	
	  

		begin(); 
		ready = true; 
	
	}
	public function focusGained(e:Event) 
	{ 
		
	
	  
	
	}

	private function stage_onKeyDown (event:KeyboardEvent):Void 
	{
		//if (event.keyCode >= 0 || event.keyCode <= 255)      
		keys[event.keyCode] = 1;
		
		
		keyDown(event.keyCode);
		if (screen != null) screen.keyDown(event.keyCode);
	}
	
	
	private function stage_onKeyUp (event:KeyboardEvent):Void
	{
	  //  if (event.keyCode>=0 || event.keyCode<=255)     
	  keys[event.keyCode] = 0;
	
	  
		keyUp(event.keyCode);
		if (screen != null) screen.keyUp(event.keyCode);
	}
	
	private function doMouseDown (event:MouseEvent):Void 
	{
	mouseDown(event.localX, event.localY);
	if (screen != null) screen.mouseDown(event.localX, event.localY);
	}
	private function doMouseUp (event:MouseEvent):Void 
	{
	mouseUp(event.localX, event.localY);
	if (screen != null) screen.mouseUp(event.localX, event.localY);
	}
    private function doMouseMove (event:MouseEvent):Void 
	{
	mouseMove(event.localX, event.localY);
	if (screen != null) screen.mouseMove(event.localX, event.localY);

	}

	private function doTouchDown (e:TouchEvent):Void 
	{
	
		var touchPoint:Touch = new Touch(e.stageX, e.stageY , e.touchPointID);
		_touches.set(e.touchPointID, touchPoint);
		_touchNum += 1;
	}
	private function doTouchUp (e:TouchEvent):Void 
	{
		_touches.remove(e.touchPointID);
		_touchNum -= 1;
	}
    private function doTouchMove (e:TouchEvent):Void 
	{
		var point:Touch = _touches.get(e.touchPointID);
		point.x = e.stageX;
		point.y = e.stageY;
	}
	

	public  var touches(get, never):Map<Int,Touch>;
	private   function get_touches():Map<Int,Touch> { return _touches; }


    private function focusLost(e:Event) 
	{
		ready = false; 
		end(); 
		for (tex in this.textures)
		{
			tex.dispose();
		}
		
		textures = null;
	}
	private function onResize(e:Event) 
	{
		screenWidth = Lib.current.stage.stageWidth;
		screenHeight = Lib.current.stage.stageHeight;
		
		resize(screenWidth,screenHeight);
	}
	
	public function begin() {  }
	public function end()   {  }
	public function resize(width:Int, height:Int) 
	{
    // trace("resize :" + width + "X" + height);
	if (screen != null) screen.resize(width, height);
	}
	public function onUpdate(dt:Float) 
	{
	
	}
	
	public function onRender() 
	{
	if (screen != null) screen.update(deltaTime);	
	tweener.updateTweens(deltaTime);
	if (screen != null) screen.render();
	}
	
    public function keyDown(key:Int) { };
	public function keyUp(key:Int) { };

	public function mouseMove(mousex:Float, mousey:Float) { };
	public function mouseUp(mousex:Float, mousey:Float) { };
	public function mouseDown(mousex:Float, mousey:Float) { };
	
	public function setScreen ( screen:Screen) 
	{
		if (this.screen != null) this.screen.dispose();
		this.screen = screen;
		this.screen.game = this;
		if (this.screen != null)
		{
			this.screen.width  = screenWidth;
			this.screen.height = screenHeight;
			this.screen.show();
			this.screen.resize(Std.int(Game.viewWidth),Std.int(Game.viewHeight));
		}
	}
	
	
private function onEnterFrame (event:Event):Void 
{
onUpdate(dt);
}
	
		
private function renderView(rect:Rectangle):Void 
{ 
	
    updateTimer();
	
	
    var timer:Int = getTimer();
	viewWidth   = Std.int(rect.width);
	viewHeight  = Std.int(rect.height);
	
	if (rescale==true)
	{
	var ar_origin:Float = (gameWidth   / gameHeight);
    var ar_new   :Float = (screenWidth /screenHeight);

    var scale_w:Float = (screenWidth / gameWidth);
    var scale_h:Float = (screenHeight / gameHeight);
    if (ar_new > ar_origin) 
	{
        scale_w = scale_h;
    } else {
        scale_h = scale_w;
    }

    var margin_x:Float = (screenWidth  - gameWidth * scale_w) / 2;
    var margin_y:Float = (screenHeight - gameHeight * scale_h) / 2;
	
	GL.viewport (Std.int (margin_x), Std.int (margin_y), Std.int (gameWidth * scale_w), Std.int (gameHeight * scale_h));
    if (camera!=null) camera.resize( gameWidth / ar_origin, gameHeight / ar_origin);
	} else
	{
	GL.viewport (Std.int (rect.x), Std.int (rect.y), Std.int (rect.width), Std.int (rect.height));
    if (camera!=null)camera.resize( viewWidth , viewHeight );
	//if (camera!=null)camera.resize( gameWidth,gameHeight );
	}
	if (camera!=null)camera.update();

 

	
   
	nextFrame = Lib.getTimer();
    deltaTime = (nextFrame - prevFrame) * 0.001;
    GL.clearColor(red, green, blue, 1);
	
	if (enableDepth == true)
	{
	 GL.clear(GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT);
	} else
	{
	GL.clear(GL.COLOR_BUFFER_BIT );	
	}

 
	if (mMultiTouch)
		{
			for (touch in _touches) touch.update(deltaTime);
		}


	if (ready)
	{
		
	  onRender();
    }
	
 GL.disableVertexAttribArray (Filter.vertexAttribute);
 GL.disableVertexAttribArray (Filter.texCoordAttribute);
 GL.disableVertexAttribArray (Filter.colorAttribute);	
 GL.bindBuffer (GL.ARRAY_BUFFER, null);	
 GL.useProgram (null);	
 GL.blendFunc(GL.SRC_ALPHA, GL.DST_ALPHA );
 
 
//

timer = getTimer();
prevFrame = nextFrame;
}
	
public function getTexture(url:String, ?flip:Bool = false ):Texture 
{
	if (textures.exists(url))
	{
		return textures.get(url);
	} else
	{	
	var tex = new Texture();
	tex.load(url, flip);
	textures.set(url,tex);
	return tex;
	}
}
private  function updateTimer()
{
then = now;
now = getTimer();
dt = then == 0 ? 0 : (now - then) / 1000;
if (fixedTimestep) {
dt = 1 / requestedFramerate;
}

frames++;
if (now - frameStart >= 1000) 
{
	fps = Std.int(Math.min(requestedFramerate, frames));
frames = 0;
frameStart = now;
}
}

public  function getTimer():Int
{
	return Lib.getTimer();
}

public function addTween(t:Tween, start:Bool = false):Tween
{
	return tweener.addTween(t, start);
}

public function removeTween(t:Tween)
{
	tweener.removeTween(t);
}
public function keyPress(keyCode:Int):Bool
{
   return  (keys[keyCode])!=0 ;
	
	
}	
	

public function createParticleSystem():ParticleSystem
{
	var part:ParticleSystem = new ParticleSystem(this);
//	this.gameObjects.add(part);
	return part;
}

public function updateGameObjects(dt:Float)
{
	for (obj in  gameObjects.iterator())
	{
	   obj.update(dt);
		
	}
}
public function renderGameObjects()
{
	for (obj in  gameObjects.iterator())
	{
	//   obj.update(dt);
		
	}
}

public function dispose()
{
tweener.clearTweens();
tweener = null;
keys = null;
}


}