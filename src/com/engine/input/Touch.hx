package com.engine.input;

import com.engine.game.Game;

class Touch
{
	public var id(default, null):Int;
	public var x:Float;
	public var y:Float;
	public var time(default, null):Float;
	public function new(x:Float, y:Float, id:Int)
	{
		this.x = x;
		this.y = y;
		this.id = id;
		this.time = 0;
	}

	public var sceneX(get, never):Float;
	private inline function get_sceneX():Float { return x + Game.camera.scrollX; }
	public var sceneY(get, never):Float;
	private inline function get_sceneY():Float { return y + Game.camera.scrollY; }

	public var pressed(get, never):Bool;
	private inline function get_pressed():Bool { return time == 0; }
	public function update(dt:Float)
	{
		time += dt;
	}
}
