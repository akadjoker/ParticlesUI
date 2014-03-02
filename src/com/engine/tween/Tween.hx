package com.engine.tween;

import com.engine.game.Game;
import com.engine.tween.Ease;
import com.engine.tween.TweenEvent;
import flash.events.EventDispatcher;

enum TweenType
{
	Persist;
	Looping;
	OneShot;
}

typedef CompleteCallback = Dynamic -> Void;


typedef FriendTween = {
	private function finish():Void;

	private var _finish:Bool;
	private var _parent:Tweener;
	private var _prev:FriendTween;
	private var _next:FriendTween;
}

class Tween extends EventDispatcher
{
	public var active:Bool;

public function new(duration:Float, ?type:TweenType, ?complete:CompleteCallback, ?ease:EaseFunction)
	{
		_target = duration;
		if (type == null) type = TweenType.Persist;
		_type = type;
		_ease = ease;
		_t = 0;
		super();

		if (complete != null)
		{
			addEventListener(TweenEvent.FINISH, complete);
		}
	}


	public function update(dt:Float)
	{
		_time += dt;
		_t = _time / _target;
		if (_ease != null && _t > 0 && _t < 1) _t = _ease(_t);
		if (_time >= _target)
		{
			_t = 1;
			_finish = true;
		}
		dispatchEvent(new TweenEvent(TweenEvent.UPDATE));
	}


	public function start()
	{
		_time = 0;
		if (_target == 0)
		{
			active = false;
			dispatchEvent(new TweenEvent(TweenEvent.FINISH));
		}
		else
		{
			active = true;
			dispatchEvent(new TweenEvent(TweenEvent.START));
		}
	}


	private function finish()
	{
		switch(_type)
		{
			case Persist:
				_time = _target;
				active = false;
			case Looping:
				_time %= _target;
				_t = _time / _target;
				if (_ease != null && _t > 0 && _t < 1) _t = _ease(_t);
				start();
			case OneShot:
				_time = _target;
				active = false;
				_parent.removeTween(this);
		}
		_finish = false;
		dispatchEvent(new TweenEvent(TweenEvent.FINISH));
	}


	public function cancel()
	{
		active = false;
		if (_parent != null)
		{
			_parent.removeTween(this);
		}
	}

	public var percent(get, set):Float;
	private function get_percent():Float { return _time / _target; }
	private function set_percent(value:Float):Float { _time = _target * value; return _time; }

	public var scale(get, null):Float;
	private function get_scale():Float { return _t; }

	private var _type:TweenType;
	private var _ease:EaseFunction;
	private var _t:Float;

	private var _time:Float;
	private var _target:Float;

	private var _finish:Bool;
	private var _parent:Tweener;
	private var _prev:FriendTween;
	private var _next:FriendTween;
}
