package com.engine.tween;

import com.engine.tween.Tween;
import com.engine.tween.Ease;


class Motion extends Tween
{
	public var x:Float;
	public var y:Float;

	public function new(duration:Float, ?complete:CompleteCallback, ?type:TweenType, ease:EaseFunction = null)
	{
		x = y = 0;
		super(duration, type, complete, ease);
	}
}