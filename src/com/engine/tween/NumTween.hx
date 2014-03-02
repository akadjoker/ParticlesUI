package com.engine.tween;

import com.engine.tween.Tween;
import com.engine.tween.Ease;


class NumTween extends Tween
{
	public var value:Float;
	
	public function new(?complete:CompleteCallback, ?type:TweenType) 
	{
		value = 0;
		super(0, type, complete);
	}
	
	/**
	 * Tweens the value from one value to another.
	 * @param	fromValue		Start value.
	 * @param	toValue			End value.
	 * @param	duration		Duration of the tween.
	 * @param	ease			Optional easer function.
	 */
	public function tween(fromValue:Float, toValue:Float, duration:Float, ?ease:EaseFunction)
	{
		_start = value = fromValue;
		_range = toValue - value;
		_target = duration;
		_ease = ease;
		start();
	}
	

	override public function update(dt:Float) 
	{
		super.update(dt);
		value = _start + _range * _t;
	}
	

	private var _start:Float;
	private var _range:Float;
}