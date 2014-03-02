package com.engine.particles;
import com.engine.game.Game;
import com.engine.game.GameObject;
import com.engine.misc.Color4;
import com.engine.render.Clip;
import com.engine.render.SpriteBatch;
import com.engine.render.Texture;
import com.engine.render.BlendMode;
import com.engine.misc.Util;
import openfl.Assets;
import haxe.xml.Fast;

/**
 * ...
 * @author djoker
 */
class ParticleSystem extends GameObject
{
        private var EMITTER_TYPE_GRAVITY:Int = 0;
        private var EMITTER_TYPE_RADIAL:Int  = 1;
        
        // emitter configuration                            // .pex element name
        private var mEmitterType:Int;                       // emitterType
        private var mEmitterXVariance:Float;               // sourcePositionVariance x
        private var mEmitterYVariance:Float;               // sourcePositionVariance y
        
        // particle configuration
        private var mMaxNumParticles:Int;                   // maxParticles
        private var mLifespan:Float;                       // particleLifeSpan
        private var mLifespanVariance:Float;               // particleLifeSpanVariance
        private var mStartSize:Float;                      // startParticleSize
        private var mStartSizeVariance:Float;              // startParticleSizeVariance
        private var mEndSize:Float;                        // finishParticleSize
        private var mEndSizeVariance:Float;                // finishParticleSizeVariance
        private var mEmitAngle:Float;                      // angle
        private var mEmitAngleVariance:Float;              // angleVariance
        private var mStartRotation:Float;                  // rotationStart
        private var mStartRotationVariance:Float;          // rotationStartVariance
        private var mEndRotation:Float;                    // rotationEnd
        private var mEndRotationVariance:Float;            // rotationEndVariance
        
        // gravity configuration
        private var mSpeed:Float;                          // speed
        private var mSpeedVariance:Float;                  // speedVariance
        private var mGravityX:Float;                       // gravity x
        private var mGravityY:Float;                       // gravity y
        private var mRadialAcceleration:Float;             // radialAcceleration
        private var mRadialAccelerationVariance:Float;     // radialAccelerationVariance
        private var mTangentialAcceleration:Float;         // tangentialAcceleration
        private var mTangentialAccelerationVariance:Float; // tangentialAccelerationVariance
        
        // radial configuration 
        private var mMaxRadius:Float;                      // maxRadius
        private var mMaxRadiusVariance:Float;              // maxRadiusVariance
        private var mMinRadius:Float;                      // minRadius
        private var mRotatePerSecond:Float;                // rotatePerSecond
        private var mRotatePerSecondVariance:Float;        // rotatePerSecondVariance
        
        // color configuration
        private var mStartColor:Color4;                  // startColor
        private var mStartColorVariance:Color4;          // startColorVariance
        private var mEndColor:Color4;                    // finishColor
        private var mEndColorVariance:Color4;            // finishColorVariance
		
		private var mTexture:Texture;
        private var mParticles:Array<Particle>;
        private var mFrameTime:Float;
         private var mNumParticles:Int;
        private var mMaxCapacity:Int;
        private var mEmissionRate:Float; // emitted particles per second
        private var mEmissionTime:Float;
        
        private var mEmitterX:Float;
        private var mEmitterY:Float;
		private var uvclip:Clip;
		private var blendMode:Int;
		private var game:Game;
				 
        
        
		
	public inline function new(game:Game) 
	{
		   super();
		    this.game = game;
	        mParticles = [];
            mEmissionRate = 0;
            mEmissionTime = 0.0;
            mFrameTime = 0.0;
			mMaxCapacity = 0;
			mNumParticles = 0;
			mMaxNumParticles = 0;
            mEmitterX = mEmitterY = 0;
			              mStartColor = new Color4(0, 0, 0, 0);
						  mStartColorVariance = new Color4(0, 0, 0, 0);
						  mEndColor = new Color4(0, 0, 0, 0);
						  mEndColorVariance = new Color4(0, 0, 0, 0);
			blendMode = BlendMode.ADD;			  
			
   }
   public inline function load(filename:String, path:String)
	{
		parseFile(Assets.getText(path + filename), path);
		updateEmissionRate();
		mMaxCapacity = mMaxNumParticles;
		uvclip = new Clip(0, 0, mTexture.width, mTexture.height);
		  
		for (i in 0...mMaxNumParticles)
		{
		  mParticles.push(createParticle());
		}
		  
		   
   }
 
   
	
	
       private inline function createParticle():Particle
        {
            return new Particle();
        }
        
		 public inline function setMaxNumParticles(value:Int)
        { 
            mMaxNumParticles = value; 
            updateEmissionRate(); 
        }
        private inline function updateEmissionRate()
        {
            mEmissionRate = mMaxNumParticles / mLifespan;
        }
       
        public inline function setLifespan(value:Float)
        { 
            mLifespan = Math.max(0.01, value);
            updateEmissionRate();
        }
        private  function initParticle(particle:Particle)
        {
	
		    
            var lifespan:Float = mLifespan + mLifespanVariance * (Math.random() * 2.0 - 1.0); 
            if (lifespan <= 0.0) return;
            
            particle.currentTime = 0.0;
            particle.totalTime = lifespan;
            
            particle.x = mEmitterX + mEmitterXVariance * (Math.random() * 2.0 - 1.0);
            particle.y = mEmitterY + mEmitterYVariance * (Math.random() * 2.0 - 1.0);
            particle.startX = mEmitterX;
            particle.startY = mEmitterY;
            
            var angle:Float = mEmitAngle + mEmitAngleVariance * (Math.random() * 2.0 - 1.0);
            var speed:Float = mSpeed + mSpeedVariance * (Math.random() * 2.0 - 1.0);
            particle.velocityX = speed * Math.cos(angle);
            particle.velocityY = speed * Math.sin(angle);
            
            particle.emitRadius = mMaxRadius + mMaxRadiusVariance * (Math.random() * 2.0 - 1.0);
            particle.emitRadiusDelta = mMaxRadius / lifespan;
            particle.emitRotation = mEmitAngle + mEmitAngleVariance * (Math.random() * 2.0 - 1.0); 
            particle.emitRotationDelta = mRotatePerSecond + mRotatePerSecondVariance * (Math.random() * 2.0 - 1.0); 
            particle.radialAcceleration = mRadialAcceleration + mRadialAccelerationVariance * (Math.random() * 2.0 - 1.0);
            particle.tangentialAcceleration = mTangentialAcceleration + mTangentialAccelerationVariance * (Math.random() * 2.0 - 1.0);
            
            var startSize:Float = mStartSize + mStartSizeVariance * (Math.random() * 2.0 - 1.0); 
            var endSize:Float = mEndSize + mEndSizeVariance * (Math.random() * 2.0 - 1.0);
            if (startSize < 0.1) startSize = 0.1;
            if (endSize < 0.1)   endSize = 0.1;
            particle.scale = startSize / mTexture.width;
            particle.scaleDelta = ((endSize - startSize) / lifespan) / mTexture.width;
            
            // colors
            
            var startColor:Color4 = particle.colorArgb;
            var colorDelta:Color4 = particle.colorArgbDelta;
            
             startColor.r   = mStartColor.r;
            startColor.g = mStartColor.g;
            startColor.b  = mStartColor.b;
            startColor.a = mStartColor.a;
            
            if (mStartColorVariance.r != 0)   startColor.r   += mStartColorVariance.r   * (Math.random() * 2.0 - 1.0);
            if (mStartColorVariance.g != 0) startColor.g += mStartColorVariance.g * (Math.random() * 2.0 - 1.0);
            if (mStartColorVariance.b != 0)  startColor.b  += mStartColorVariance.b  * (Math.random() * 2.0 - 1.0);
            if (mStartColorVariance.a != 0) startColor.a += mStartColorVariance.a * (Math.random() * 2.0 - 1.0);
            
            var endColorRed:Float   = mEndColor.r;
            var endColorGreen:Float = mEndColor.g;
            var endColorBlue:Float  = mEndColor.b;
            var endColorAlpha:Float = mEndColor.a;

            if (mEndColorVariance.r != 0)   endColorRed   += mEndColorVariance.r   * (Math.random() * 2.0 - 1.0);
            if (mEndColorVariance.g != 0) endColorGreen += mEndColorVariance.g * (Math.random() * 2.0 - 1.0);
            if (mEndColorVariance.b != 0)  endColorBlue  += mEndColorVariance.b  * (Math.random() * 2.0 - 1.0);
            if (mEndColorVariance.a != 0) endColorAlpha += mEndColorVariance.a * (Math.random() * 2.0 - 1.0);
            
            colorDelta.r   = (endColorRed   - startColor.r)   / lifespan;
            colorDelta.g = (endColorGreen - startColor.g) / lifespan;
            colorDelta.b  = (endColorBlue  - startColor.b)  / lifespan;
            colorDelta.a = (endColorAlpha - startColor.a) / lifespan;
            
            // rotation
            
            var startRotation:Float = mStartRotation + mStartRotationVariance * (Math.random() * 2.0 - 1.0); 
            var endRotation:Float   = mEndRotation   + mEndRotationVariance   * (Math.random() * 2.0 - 1.0);
            
            particle.rotation = startRotation;
            particle.rotationDelta = (endRotation - startRotation) / lifespan;
        }

        private inline function advanceParticle(particle:Particle, passedTime:Float)
        {
			  
            var restTime:Float = particle.totalTime - particle.currentTime;
            passedTime = restTime > passedTime ? passedTime : restTime;
            particle.currentTime += passedTime;
            
            if (mEmitterType == EMITTER_TYPE_RADIAL)
            {
                particle.emitRotation += particle.emitRotationDelta * passedTime;
                particle.emitRadius   -= particle.emitRadiusDelta   * passedTime;
                particle.x = mEmitterX - Math.cos(particle.emitRotation) * particle.emitRadius;
                particle.y = mEmitterY - Math.sin(particle.emitRotation) * particle.emitRadius;
                
                if (particle.emitRadius < mMinRadius)
                    particle.currentTime = particle.totalTime;
            }
            else
            {
                var distanceX:Float = particle.x - particle.startX;
                var distanceY:Float = particle.y - particle.startY;
                var distanceScalar:Float = Math.sqrt(distanceX*distanceX + distanceY*distanceY);
                if (distanceScalar < 0.01) distanceScalar = 0.01;
                
                var radialX:Float = distanceX / distanceScalar;
                var radialY:Float = distanceY / distanceScalar;
                var tangentialX:Float = radialX;
                var tangentialY:Float = radialY;
                
                radialX *= particle.radialAcceleration;
                radialY *= particle.radialAcceleration;
                
                var newY:Float = tangentialX;
                tangentialX = -tangentialY * particle.tangentialAcceleration;
                tangentialY = newY * particle.tangentialAcceleration;
                
                particle.velocityX += passedTime * (mGravityX + radialX + tangentialX);
                particle.velocityY += passedTime * (mGravityY + radialY + tangentialY);
                particle.x += particle.velocityX * passedTime;
                particle.y += particle.velocityY * passedTime;
            }
            
            particle.scale += particle.scaleDelta * passedTime;
            particle.rotation += particle.rotationDelta * passedTime;
            
            particle.colorArgb.r   += particle.colorArgbDelta.r   * passedTime;
            particle.colorArgb.g += particle.colorArgbDelta.g * passedTime;
            particle.colorArgb.b  += particle.colorArgbDelta.b  * passedTime;
            particle.colorArgb.a += particle.colorArgbDelta.a * passedTime;
            
            particle.color = particle.colorArgb;
            particle.alpha = particle.colorArgb.a;
        }
		
       public inline function start(duration:Float=1.79e+308)
        {
            if (mEmissionRate != 0)                
                mEmissionTime = duration;
        }
        
        public inline function stop(clear:Bool=false)
        {
            mEmissionTime = 0.0;
            if (clear) mNumParticles = 0;
        }
		override public inline function update(passedTime:Float)
        {
            var particleIndex:Int = 0;
            var particle:Particle;
            
            // advance existing particles
            
            while (particleIndex < mNumParticles)
            {
                particle = mParticles[particleIndex];
                
                if (particle.currentTime < particle.totalTime)
                {
                    advanceParticle(particle, passedTime);
                    ++particleIndex;
                }
                else
                {
                    if (particleIndex != mNumParticles - 1)
                    {
                        var nextParticle:Particle = mParticles[mNumParticles-1] ;
                        mParticles[mNumParticles-1] = particle;
                        mParticles[particleIndex] = nextParticle;
					//	trace("create particle");
                    }
                    
                    --mNumParticles;
                    
                    if (mNumParticles == 0)
					{
						trace("no particles");
                        //dispatchEvent(new Event(Event.COMPLETE));
					}
                }
            }
            
            // create and advance new particles
         
            if (mEmissionTime > 0)
            {
                var timeBetweenParticles:Float = 1.0 / mEmissionRate;
                mFrameTime += passedTime;
				
			//	trace(mNumParticles+'>'+mMaxCapacity);
                
                while (mFrameTime > 0)
                {
                    if (mNumParticles < mMaxCapacity)
                    {
						
                        particle = mParticles[mNumParticles++] ;
                        initParticle(particle);
                        advanceParticle(particle, mFrameTime);
                    }
                    
                    mFrameTime -= timeBetweenParticles;
                }
                
                if (mEmissionTime != 10000)
                    mEmissionTime = Math.max(0.0, mEmissionTime - passedTime);

		}
		
	
     
        }
		
		 public inline function renderBatch(batch:SpriteBatch)
		{
		
			
			var alpha:Float;
            var rotation:Float;
            var x:Float; 
			var y:Float;
            var xOffset:Float;
			var yOffset:Float;
            var textureWidth:Float  =this.uvclip.width;
            var textureHeight:Float =this.uvclip.height;
			var color:Color4;
			var matrix =	this.getLocalToWorldMatrix();
			
		var count:Int = 0;
		for (i in 0...mNumParticles)
		{
			
			   var particle:Particle = mParticles[i];
	            color = particle.color;
                alpha = particle.alpha;
                rotation = particle.rotation;
	
				
			var px:Float = particle.x;
			var py:Float = particle.y;
			x = matrix.a * px + matrix.c * py + matrix.tx;
		    y = matrix.d * py + matrix.b * px + matrix.ty;
			
				
             
                xOffset = ( textureWidth /2  * particle.scale );
                yOffset = ( textureHeight / 2  * particle.scale );
				
			//	if (xOffset <= 0.2) continue;
			//	if (yOffset <= 0.2) continue;
				if (alpha <= 0) continue;
				count++;				
		
				
				
					
				batch.drawVertex(this.mTexture,
                x - xOffset, y - yOffset,
                x - xOffset, y + yOffset,
                x + xOffset, y + yOffset,
                x + xOffset, y - yOffset,
				this.uvclip,  color.r, color.g, color.b, alpha,blendMode);
                	
		}
		
		//trace(count);
		
		}
			public inline function parseFile(data:String, path:String)
	{

		var xml:Xml = Xml.parse (data);
	//	var node = xml.firstElement();
		
	
	
	   for (child in xml) 
		{
			if (Util.isValidElement(child)) 
			{
				for (data in child)
				{
					if (Util.isValidElement(data)) 
			        {
						if (data.nodeName == "texture")
						{
						mTexture= game.getTexture(path + data.get("name"));
						}
						if (data.nodeName == "sourcePosition")
						{
							mEmitterX=Std.parseFloat(data.get("x"));
							mEmitterY = Std.parseFloat(data.get("y"));
						
						}
						if (data.nodeName == "sourcePositionVariance")
						{
							mEmitterXVariance=Std.parseFloat(data.get("x"));
							mEmitterYVariance = Std.parseFloat(data.get("y"));
						
						}
						if (data.nodeName == "gravity")
						{
							mGravityX=Std.parseFloat(data.get("x"));
							mGravityY = Std.parseFloat(data.get("y"));
							
						}	
	
    					if (data.nodeName == "emitterType")
						{
							mEmitterType = Std.parseInt(data.get("value"));
							
						}	
						if (data.nodeName == "maxParticles")
						{
							mMaxNumParticles = Std.parseInt(data.get("value"));
							//mMaxNumParticles = 5;
							
						}
						if (data.nodeName == "particleLifeSpan")
						{
							  mLifespan = Math.max(0.01, Std.parseFloat(data.get("value")));
							
						}
							if (data.nodeName == "particleLifespanVariance")
						{
							  mLifespanVariance = Std.parseFloat(data.get("value"));
							 
						}
						if (data.nodeName == "startParticleSize")
						{
							  mStartSize = Std.parseFloat(data.get("value"));
						}
							if (data.nodeName == "startParticleSizeVariance")
						{
							  mStartSizeVariance = Std.parseFloat(data.get("value"));
						}
						if (data.nodeName == "finishParticleSize")
						{
							  mEndSize = Std.parseFloat(data.get("value"));
						}
							if (data.nodeName == "FinishParticleSizeVariance")
						{
							  mEndSizeVariance = Std.parseFloat(data.get("value"));
						}
						if (data.nodeName == "angle")
						{
							  mEmitAngle = Util.deg2rad(Std.parseFloat(data.get("value")));
						}
						if (data.nodeName == "angleVariance")
						{
							  mEmitAngleVariance = Util.deg2rad(Std.parseFloat(data.get("value")));
						}
						if (data.nodeName == "rotationStart")
						{
							  mStartRotation = Util.deg2rad(Std.parseFloat(data.get("value")));
						}
						if (data.nodeName == "rotationStartVariance")
						{
							  mStartRotationVariance = Util.deg2rad(Std.parseFloat(data.get("value")));
						}
						if (data.nodeName == "rotationEnd")
						{
							  mEndRotation = Util.deg2rad(Std.parseFloat(data.get("value")));
						}
						if (data.nodeName == "rotationEndVariance")
						{
							  mEndRotationVariance = Util.deg2rad(Std.parseFloat(data.get("value")));
						}
						
						if (data.nodeName == "speed")
						{
							  mSpeed = Std.parseFloat(data.get("value"));
						}
						if (data.nodeName == "speedVariance")
						{
							  mSpeedVariance = Std.parseFloat(data.get("value"));
						}
						if (data.nodeName == "radialAcceleration")
						{
							  mRadialAcceleration = Std.parseFloat(data.get("value"));
						}
						if (data.nodeName == "radialAccelVariance")
						{
							  mRadialAccelerationVariance = Std.parseFloat(data.get("value"));
						}
						if (data.nodeName == "tangentialAcceleration")
						{
							 mTangentialAcceleration = Std.parseFloat(data.get("value"));
						}
						if (data.nodeName == "tangentialAccelVariance")
						{
							  mTangentialAccelerationVariance = Std.parseFloat(data.get("value"));
						}
						if (data.nodeName == "maxRadius")
						{
							  mMaxRadius = Std.parseFloat(data.get("value"));
						}
						if (data.nodeName == "maxRadiusVariance")
						{
							  mMaxRadiusVariance = Std.parseFloat(data.get("value"));
						}
						if (data.nodeName == "minRadius")
						{
							  mMinRadius = Std.parseFloat(data.get("value"));
						}
						
						if (data.nodeName == "rotatePerSecond")
						{
							  mRotatePerSecond = Util.deg2rad(Std.parseFloat(data.get("value")));
						}
						if (data.nodeName == "rotatePerSecondVariance")
						{
							  mRotatePerSecondVariance = Util.deg2rad(Std.parseFloat(data.get("value")));
						}
						   
						  
						if (data.nodeName == "startColor")
						{
							
							  mStartColor.r = Std.parseFloat(data.get("red"));
							  mStartColor.g = Std.parseFloat(data.get("green"));
							  mStartColor.b = Std.parseFloat(data.get("blue"));
							  mStartColor.a = Std.parseFloat(data.get("alpha"));
						}
						
							if (data.nodeName == "startColorVariance")
						{
							  mStartColorVariance.r = Std.parseFloat(data.get("red"));
							  mStartColorVariance.g = Std.parseFloat(data.get("green"));
							  mStartColorVariance.b = Std.parseFloat(data.get("blue"));
							  mStartColorVariance.a = Std.parseFloat(data.get("alpha"));
						}
						if (data.nodeName == "finishColor")
						{
							  mEndColor.r = Std.parseFloat(data.get("red"));
							  mEndColor.g = Std.parseFloat(data.get("green"));
							  mEndColor.b = Std.parseFloat(data.get("blue"));
							  mEndColor.a = Std.parseFloat(data.get("alpha"));
						}
						if (data.nodeName == "finishColorVariance")
						{
							  mEndColorVariance.r = Std.parseFloat(data.get("red"));
							  mEndColorVariance.g = Std.parseFloat(data.get("green"));
							  mEndColorVariance.b = Std.parseFloat(data.get("blue"));
							  mEndColorVariance.a = Std.parseFloat(data.get("alpha"));
						}

			         }
				}
				
			}
		}
	}
	

	public var emitterX(get_emitterX, set_emitterX):Float;
	
	private inline function get_emitterX():Float
	{
		return mEmitterX;
	}
	private inline function set_emitterX(value:Float):Float
	{
	 mEmitterX = value;
	 return mEmitterX;
	}		
	
		
	public var emitterY(get_emitterY, set_emitterY):Float;
	
	private inline function get_emitterY():Float
	{
		return mEmitterY;
	}
	private inline function set_emitterY(value:Float):Float
	{
	 mEmitterY = value;
	 return mEmitterY;
	}

		
	public var angle(get_angle, set_angle):Float;
	
	private inline function get_angle():Float
	{
		return mEmitAngle;
	}
	private inline function set_angle(value:Float):Float
	{
	 mEmitAngle = value;
	 return mEmitAngle;
	}	
      
}