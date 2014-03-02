package com.engine.game;


import com.engine.render.Texture;
import com.engine.tween.Tween;
/**
 * ...
 * @author djoker
 */
class Screen extends GameObject
{
	public var width:Int;
	public var height:Int;
	

    public var game:Game = null;
	
	public    function show() {  }
	public   function render() { }

	public   function resize(width:Int, height:Int) {}
	
	public   function mouseMove(mousex:Float, mousey:Float) { };
	public   function mouseUp(mousex:Float, mousey:Float) { };
	public   function mouseDown(mousex:Float, mousey:Float) { };
	public   function keyDown(key:Int) { };
	public   function keyUp(key:Int) { };
	
	
	public  inline  function getTexture(url:String, ?flip:Bool = false ):Texture 
{
	
	return game.getTexture(url, flip);
}
public  inline  function addTween(t:Tween, start:Bool = false):Tween
{
	
	return game.addTween(t, start);
}
public  inline function removeTween(t:Tween)
{
	game.removeTween(t);
}

public  inline function keyPress(keyCode:Int):Bool
{
	return game.keyPress(keyCode);
}

}