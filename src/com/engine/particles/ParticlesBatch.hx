package com.engine.particles;

import flash.geom.Matrix3D;
import openfl.gl.GL;
import openfl.gl.GLBuffer;
import openfl.gl.GLProgram;
import openfl.utils.Float32Array;
import openfl.utils.Int16Array;

import com.engine.render.BlendMode;
import com.engine.game.Game;
import com.engine.render.filter.Filter;
import com.engine.render.VertexData;

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
class ParticleEmitter extends GameObject
{
        private var EMITTER_TYPE_GRAVITY:Int = 0;
        private var EMITTER_TYPE_RADIAL:Int  = 1;
        
        // emitter configuration                      
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
				 
		//******
	private var capacity:Int;
	private var numVerts:Int;
	private var numIndices:Int; 
	private var vertices:Float32Array;
	private var indices:Int16Array;
	private var currentBatchSize:Int;
	private var currentBlendMode:Int;
	private var currentBaseTexture:Texture;
    private var vertexBuffer:GLBuffer;
    private var indexBuffer:GLBuffer;
	public  var vertexStrideSize:Int;
    private var invTexWidth:Float  = 0;
    private var invTexHeight:Float = 0;     
	private var viewMatrix:Matrix3D;
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
			viewMatrix = new  Matrix3D();
			viewMatrix.identity();
			
   }
   public inline function load(filename:String, path:String)
	{
		parseFile(Assets.getText(path + filename), path);
		updateEmissionRate();
		mMaxCapacity = mMaxNumParticles;	  
	    creteBuffer();
   }
   public inline function creteBuffer()
   {
	   
	   
		var index:Int = 0;
		 	uvclip = new Clip(0, 0, mTexture.width, mTexture.height);
			invTexWidth  = 1.0 / mTexture.width;
            invTexHeight = 1.0 / mTexture.height;
		 
		vertexStrideSize =  (3+2+4) *4; // 9 floats (x, y, z,u,v, r, g, b, a)
 
	   numVerts   = mMaxCapacity * vertexStrideSize;
	   numIndices = mMaxCapacity * 6;
       vertices = new Float32Array(numVerts);
       this.indices = new Int16Array(numIndices); 
 
		
		for (i in 0...mMaxNumParticles)
		{
		        mParticles.push(createParticle());
		        var numVertices:Int = i * 4;
                this.indices[index] = numVertices + 0;index++;
				this.indices[index] = numVertices + 1;index++;
				this.indices[index] = numVertices + 2;index++;
				this.indices[index] = numVertices + 0;index++;
				this.indices[index] = numVertices + 2;index++;
				this.indices[index] = numVertices + 3;index++;
		}

    currentBatchSize = 0;
    vertexBuffer = GL.createBuffer();
    indexBuffer = GL.createBuffer();
    GL.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, indexBuffer);
    GL.bufferData(GL.ELEMENT_ARRAY_BUFFER, indices, GL.STATIC_DRAW);
    GL.bindBuffer(GL.ARRAY_BUFFER, vertexBuffer);
    GL.bufferData(GL.ARRAY_BUFFER, vertices, GL.STATIC_DRAW);
	indices = null;
   }
   	public  function isValidElement(element:Xml):Bool
	{
		return Std.string(element.nodeType) == "element";
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
        private inline function initParticle(particle:Particle)
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
						//trace("no particles");
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
		
	
	
		public inline function render()
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
			
		Begin();
			
		var count:Int = 0;
		for (i in 0...mNumParticles)
		{
			
			   var particle:Particle = mParticles[i];
	            color = particle.color;
                alpha = particle.alpha;
                rotation = particle.rotation;
                x = particle.x;
                y = particle.y;
                xOffset = ( textureWidth /2  * particle.scale );
                yOffset = ( textureHeight / 2  * particle.scale );
				
				if (xOffset <= 0.2) continue;
				if (yOffset <= 0.2) continue;
				if (alpha <= 0) continue;
				count++;				
				
		       if (rotation!=0)
                {
                    var cos:Float  = Math.cos(rotation);
                    var sin:Float  = Math.sin(rotation);
                    var cosX:Float = cos * xOffset;
                    var cosY:Float = cos * yOffset;
                    var sinX:Float = sin * xOffset;
                    var sinY:Float = sin * yOffset;
                    
                   drawVertex(
				   x - cosX + sinY, y - sinX - cosY,
                   x + cosX + sinY, y + sinX - cosY,
                   x - cosX - sinY, y - sinX + cosY,
                   x + cosX - sinY, y + sinX + cosY,
				    color.r, color.g, color.b, alpha);
				   
                }
                else 
                {
					
				drawVertex(
                x - xOffset, y - yOffset,
                x - xOffset, y + yOffset,
                x + xOffset, y + yOffset,
                x + xOffset, y - yOffset,
				color.r, color.g, color.b, alpha);			
                }		
				
					
			
				  
		}
		
		End();
		//trace(count);
	}
	
public inline function drawVertex(
    	 x1:Float,
		 y1:Float,
		 x2:Float,
		 y2:Float,
		 x3:Float,
		 y3:Float,
		 x4:Float,
		 y4:Float,
	     r:Float,g:Float,b:Float,a:Float)
	{

 var u:Float  = uvclip.x * invTexWidth;
 var u2:Float = ( uvclip.x +  uvclip.width) * invTexWidth;
 var v:Float  = ( uvclip.y +  uvclip.height) * invTexHeight;
 var v2:Float =  uvclip.y * invTexHeight;


var index:Int = currentBatchSize *  vertexStrideSize;



//z
vertices[index+0*9+2] = 0;
vertices[index+1*9+2] = 0;
vertices[index+2*9+2] = 0;
vertices[index+3*9+2] = 0;



vertices[index + 0 * 9 + 0] = x1; vertices[index + 0 * 9 + 1] = y1;
vertices[index + 1 * 9 + 0] = x2; vertices[index + 1 * 9 + 1] = y2;
vertices[index + 2 * 9 + 0] = x3; vertices[index + 2 * 9 + 1] = y3;
vertices[index + 3 * 9 + 0] = x4; vertices[index + 3 * 9 + 1] = y4;



vertices[index+0*9+3] = u;vertices[index+0*9+4] =v2;
vertices[index+1*9+3] = u;vertices[index+1*9+4] =v;
vertices[index+2*9+3] =u2;vertices[index+2*9+4] =v;
vertices[index+3*9+3] =u2;vertices[index+3*9+4] =v2;

	


vertices[index+0*9+5] = r;vertices[index+0*9+6] = g;vertices[index+0*9+7] = b;vertices[index+0*9+8] = a;
vertices[index+1*9+5] = r;vertices[index+1*9+6] = g;vertices[index+1*9+7] = b;vertices[index+1*9+8] = a;
vertices[index+2*9+5] = r;vertices[index+2*9+6] = g;vertices[index+2*9+7] = b;vertices[index+2*9+8] = a;
vertices[index+3*9+5] = r;vertices[index+3*9+6] = g;vertices[index+3*9+7] = b;vertices[index+3*9+8] = a;


	
 
this.currentBatchSize++;

}
	private inline function Begin()
	{
	 currentBatchSize = 0;
	 Game.spriteShader.Enable();
	 GL.bindBuffer(GL.ARRAY_BUFFER, this.vertexBuffer);
     GL.vertexAttribPointer(Filter.vertexAttribute, 3, GL.FLOAT, false, vertexStrideSize, 0);
     GL.vertexAttribPointer(Filter.texCoordAttribute  , 2, GL.FLOAT, false, vertexStrideSize, 3 * 4);
     GL.vertexAttribPointer(Filter.colorAttribute, 4, GL.FLOAT, false, vertexStrideSize, (3+2) * 4);
   
    }
	private inline function End()
	{
	if (currentBatchSize==0) return;
	Game.spriteShader.setTexture(mTexture);
	BlendMode.setBlend(blendMode);
 	Game.spriteShader.setProjMatrix(Game.camera.projMatrix);
	Util.convertTo3D(this.getLocalToWorldMatrix(), viewMatrix);
	Game.spriteShader.setViewMatrix(viewMatrix);
    GL.bufferData(GL.ARRAY_BUFFER, vertices, GL.STATIC_DRAW);
    GL.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, this.indexBuffer);
    GL.drawElements(GL.TRIANGLES, currentBatchSize * 6, GL.UNSIGNED_SHORT, 0);
    Game.spriteShader.Disable();
	}	
	public inline function parseFile(data:String, path:String)
	{

		var xml:Xml = Xml.parse (data);
	//	var node = xml.firstElement();
		
	
	
	   for (child in xml) 
		{
			if (isValidElement(child)) 
			{
				for (data in child)
				{
					if (isValidElement(data)) 
			        {
						if (data.nodeName == "texture")
						{
							
							mTexture= game.getTexture(path + data.get("name"));
							//mTexture.load(path + data.get("name"));
							//trace(path + data.get("name"));
							//trace(data.get("name"));
							
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
						//	mMaxNumParticles = 5;
							
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
	
 override public inline function dispose():Void 
{
	this.vertices = null;
	GL.deleteBuffer(indexBuffer);
	GL.deleteBuffer(vertexBuffer);
	super.dispose();
	
}
}