package com.engine.particles;

import com.engine.misc.Color4;
import flash.geom.Point;
	

/**
 * ...
 * @author djoker
 */
class MParticle
{
   public var Location: Point;
    public var Velocity: Point;

   public var  Gravity: Float;
    public var RadialAccel: Float;
    public var TangentialAccel: Float;

    public var Spin: Float;
    public var SpinDelta: Float;

    public var Size: Float;
    public var SizeDelta: Float;

    public var Color: Color4;
    public var ColorDelta: Color4;
    public var  Age: Float;
    public var TerminalAge: Float;

	
			public function new() 
	{
		    Location = new Point();
			Velocity = new Point();
			Color = new Color4(1,1,1,1);
			ColorDelta = new Color4(1,1,1,1);
			Location= new Point();
            Velocity = new Point();
	}
	
}