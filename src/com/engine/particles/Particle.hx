package com.engine.particles;


import com.engine.game.GameObject;
import com.engine.misc.Color4;
/**
 * ...
 * @author djoker
 */
     class Particle 
    {
        public var x:Float;
        public var y:Float;
        public var scale:Float;
        public var rotation:Float;
        public var color:Color4;
        public var alpha:Float;
        public var currentTime:Float;
        public var totalTime:Float;
		public var colorArgb:Color4;
        public var colorArgbDelta:Color4;
        public var startX:Float;
		public var startY:Float;
        public var velocityX:Float;
		public var velocityY:Float;
        public var radialAcceleration:Float;
        public var tangentialAcceleration:Float;
        public var emitRadius:Float; 
		public var emitRadiusDelta:Float;
        public var emitRotation:Float; 
		public var emitRotationDelta:Float;
        public var rotationDelta:Float;
        public var scaleDelta:Float;

        public function new()
        {

            x = y = rotation = currentTime = 0.0;
            totalTime = alpha = scale = 1.0;
            color = new Color4(1, 1, 1, 1);
			colorArgb = new Color4(0, 0, 0, 0);
			colorArgbDelta=new Color4(0, 0, 0, 0);
			
        }
    }
