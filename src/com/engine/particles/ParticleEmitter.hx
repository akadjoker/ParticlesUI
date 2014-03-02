package com.engine.particles;
import com.engine.game.Game;
import com.engine.game.GameObject;
import com.engine.misc.Color4;
import com.engine.render.Clip;
import com.engine.render.SpriteBatch;
import com.engine.render.Texture;
import com.engine.render.BlendMode;
import com.engine.misc.Util;
import flash.utils.ByteArray;
import flash.utils.Endian;


import openfl.Assets;
import haxe.xml.Fast;
import flash.geom.Point;


  #if neko
import sys.io.File;
import sys.io.FileOutput;
#end


	/**
	 * ...
	 * @author djoker
	 */
	
	  class ParticleSystemInfo 
	{
		
	public var Blend:Int;
	public var Frame:Int;
		 
    public var Emission:Int;
    public var Lifetime: Float;

    public var ParticleLifeMin: Float;
    public var ParticleLifeMax: Float;

   public var  Direction: Float;
   public var  Spread: Float;
   public var  Relative: Int;

   public var  SpeedMin: Float;
   public var  SpeedMax: Float;

  public var   GravityMin: Float;
  public var   GravityMax: Float;

  public var   RadialAccelMin: Float;
  public var   RadialAccelMax: Float;

   public var  TangentialAccelMin: Float;
   public var  TangentialAccelMax: Float;

  public var   SizeStart: Float;
   public var  SizeEnd: Float;
   public var  SizeVar: Float;

 public var    SpinStart: Float;
  public var   SpinEnd: Float;
  public var   SpinVar: Float;

  public var   ColorStart: Color4;
  public var   ColorEnd: Color4;
  public var   ColorVar: Float;
  public var   AlphaVar: Float;
		
		public inline function new() 
		{
			ColorStart = new Color4();
			ColorEnd = new Color4();
Frame = 0;
Blend = 0;
Emission=20;
Lifetime=10.000;
ParticleLifeMin=0.437;
ParticleLifeMax=0.992;
Direction=0.000;
//Spread=6.283;
Spread=0;
Relative = 0;
SpeedMin=85.714;
SpeedMax = 104.762;
GravityMin=0.000;
GravityMax = 0.000;
RadialAccelMin=-71.429;
RadialAccelMax=-71.429;
TangentialAccelMin=0.000;
TangentialAccelMax=0.000;
SizeStart=0.989;
SizeEnd=2.301;
SizeVar=0.000;
SpinStart=19.841;
SpinEnd=19.841;
SpinVar=0.524;
ColorVar=0.206;
AlphaVar=0.206;
ColorStart.r=0.095;
ColorStart.g=0.802;
ColorStart.b=0.357;
ColorStart.a=1.000;
ColorEnd.r=0.413;
ColorEnd.g=0.159;
ColorEnd.b=0.889;
ColorEnd.a=0.286;


			
		}
		
		public function toXml():String
		{
			var result:String;
			
			result='<?xml version="1.0"?>\n'+
            '<EmitterConfig>\n'+

'<Emission value="'+Emission+'"/>\n'+
'<Lifetime value="'+Lifetime+'"/>\n'+
'<Direction value="'+Direction+'"/>\n'+
'<Spread value="'+Spread+'"/>\n'+
'<Relative value="'+Relative+'"/>\n'+


'<Life Min="' + ParticleLifeMin + '" Max="' + ParticleLifeMax + '"/>\n' +
'<Speed Min="' + SpeedMin + '" Max="' + SpeedMin + '"/>\n' +
'<RadialAccel Min="' + RadialAccelMin + '" Max="' + RadialAccelMax + '"/>\n' +
'<TangentialAccel Min="' + TangentialAccelMin + '" Max="' + TangentialAccelMax + '"/>\n' +

'<Size Start="' + SizeStart + '" End="' + SizeEnd + '" Var="' + SizeVar + '"/>\n' +
'<Rotation Start="' + SpinStart + '" End="' + SpinEnd + '" Var="' + SpinVar + '"/>\n' +

'<ColorVar value="' + ColorVar + '"/>\n' +
'<AlphaVar value="' + AlphaVar + '"/>\n' +

'<StartColor r="' + ColorStart.r + '" g="' + ColorStart.g + '" b="' + ColorStart.b + '" a="' + ColorStart.a + '"/>\n' +
'<ColorEnd r="' + ColorEnd.r + '" g="' + ColorEnd.g + '" b="' + ColorEnd.b + '" a="'+ColorEnd.a+'"/>\n' +

'</EmitterConfig>\n'+
'<!-- Converter by Luis Santos AKA DJOKER-->' ;
return result;

		}
    public  function parseInfoFromFile(info:String) 
	{
		var xml:Xml = Xml.parse (Assets.getText(info));

		
	
	
	   for (child in xml) 
		{
			if (Util.isValidElement(child)) 
			{
				for (data in child)
				{
					if (Util.isValidElement(data)) 
			        {
						if (data.nodeName == "Emission")
						{
							this.Emission=Std.parseInt(data.get("value"));
						}
						if (data.nodeName == "Lifetime")
						{
							this.Lifetime=Std.parseFloat(data.get("value"));
						}
						if (data.nodeName == "Direction")
						{
							this.Direction=Std.parseFloat(data.get("value"));
						}
						if (data.nodeName == "Spread")
						{
							this.Spread=Std.parseFloat(data.get("value"));
						}			
	                	if (data.nodeName == "Relative")
						{
							this.Relative=Std.parseInt(data.get("value"));
						}	
						if (data.nodeName == "Life")
						{
							this.ParticleLifeMin = Std.parseFloat(data.get("Min"));
							this.ParticleLifeMax=Std.parseFloat(data.get("Max"));
						}						
						if (data.nodeName == "Speed")
						{
							this.SpeedMin = Std.parseFloat(data.get("Min"));
							this.SpeedMax=Std.parseFloat(data.get("Max"));
						}	
						if (data.nodeName == "Gravity")
						{
							this.GravityMin = Std.parseFloat(data.get("Min"));
							this.GravityMax=Std.parseFloat(data.get("Max"));
						}		
						if (data.nodeName == "RadialAccel")
						{
							this.RadialAccelMin = Std.parseFloat(data.get("Min"));
							this.RadialAccelMax=Std.parseFloat(data.get("Max"));
						}			
						if (data.nodeName == "TangentialAccel")
						{
							this.TangentialAccelMin = Std.parseFloat(data.get("Min"));
							this.TangentialAccelMax=Std.parseFloat(data.get("Max"));
						}							
						if (data.nodeName == "Size")
						{
							this.SizeStart = Std.parseFloat(data.get("Start"));
							this.SizeEnd = Std.parseFloat(data.get("End"));
							this.SizeVar=Std.parseFloat(data.get("Var"));
						}	
						if (data.nodeName == "Rotation")
						{
							this.SpinStart = Std.parseFloat(data.get("Start"));
							this.SpinEnd = Std.parseFloat(data.get("End"));
							this.SpinVar=Std.parseFloat(data.get("Var"));
						}			
					   if (data.nodeName == "ColorVar")
						{
							this.ColorVar=Std.parseFloat(data.get("value"));
						}		
					   if (data.nodeName == "AlphaVar")
						{
							this.AlphaVar=Std.parseFloat(data.get("value"));
						}	
					   if (data.nodeName == "StartColor")
						{
							this.ColorStart.r = Std.parseFloat(data.get("r"));
							this.ColorStart.g = Std.parseFloat(data.get("g"));
							this.ColorStart.b = Std.parseFloat(data.get("b"));
							this.ColorStart.a =Std.parseFloat(data.get("a"));
						}			
					   if (data.nodeName == "EndColor")
						{
							this.ColorEnd.r = Std.parseFloat(data.get("r"));
							this.ColorEnd.g = Std.parseFloat(data.get("g"));
							this.ColorEnd.b = Std.parseFloat(data.get("b"));
							this.ColorEnd.a =Std.parseFloat(data.get("a"));
						}							
					}
				}
			}
		}
		/*
			trace("Emission "+Emission );
			trace("Lifetime "+Lifetime  );
			trace("ParticleLifeMin "+ParticleLifeMin  );
			trace("ParticleLifeMax "+ParticleLifeMax  );
			trace("Direction "+Direction );
			trace("Spread "+Spread );
			trace("Relative "+Relative );
			trace("SpeedMin "+SpeedMin  );
			trace("SpeedMax "+SpeedMax  );
			trace("GravityMin "+GravityMin  );
			trace("GravityMax"+GravityMax  );
			trace("radial min "+RadialAccelMin  );
			trace("radial max "+RadialAccelMax  );
			trace("Tangent Min "+TangentialAccelMin  );
			trace("Tangetn Max "+TangentialAccelMax  );
			trace("SizeStart "+SizeStart  );
			trace("SizeEnd "+SizeEnd  );
			trace("SizeVar "+SizeVar  );
			trace("SpinStart "+SpinStart  );
			trace("SpinEnd "+SpinEnd  );
			trace("SpinVar "+SpinVar  );
			trace("ColorVar "+ColorVar  );
			trace("AlphaVar "+AlphaVar  );
			
			trace("start color");
			trace(ColorStart.r );
			trace(ColorStart.g );
			trace(ColorStart.b );
			trace(ColorStart.a);
			
			trace("end color");
			trace(ColorEnd.r  );
			trace(ColorEnd.g );
			trace(ColorEnd.b );
			trace(ColorEnd.a);
			*/
	}
	 public  function parseInfoFromString(info:String) 
	{
		var xml:Xml = Xml.parse (info);

		
	
	
	   for (child in xml) 
		{
			if (Util.isValidElement(child)) 
			{
				for (data in child)
				{
					if (Util.isValidElement(data)) 
			        {
						if (data.nodeName == "Emission")
						{
							this.Emission=Std.parseInt(data.get("value"));
						}
						if (data.nodeName == "Lifetime")
						{
							this.Lifetime=Std.parseFloat(data.get("value"));
						}
						if (data.nodeName == "Direction")
						{
							this.Direction=Std.parseFloat(data.get("value"));
						}
						if (data.nodeName == "Spread")
						{
							this.Spread=Std.parseFloat(data.get("value"));
						}			
	                	if (data.nodeName == "Relative")
						{
							this.Relative=Std.parseInt(data.get("value"));
						}	
						if (data.nodeName == "Life")
						{
							this.ParticleLifeMin = Std.parseFloat(data.get("Min"));
							this.ParticleLifeMax=Std.parseFloat(data.get("Max"));
						}						
						if (data.nodeName == "Speed")
						{
							this.SpeedMin = Std.parseFloat(data.get("Min"));
							this.SpeedMax=Std.parseFloat(data.get("Max"));
						}	
						if (data.nodeName == "Gravity")
						{
							this.GravityMin = Std.parseFloat(data.get("Min"));
							this.GravityMax=Std.parseFloat(data.get("Max"));
						}		
						if (data.nodeName == "RadialAccel")
						{
							this.RadialAccelMin = Std.parseFloat(data.get("Min"));
							this.RadialAccelMax=Std.parseFloat(data.get("Max"));
						}			
						if (data.nodeName == "TangentialAccel")
						{
							this.TangentialAccelMin = Std.parseFloat(data.get("Min"));
							this.TangentialAccelMax=Std.parseFloat(data.get("Max"));
						}							
						if (data.nodeName == "Size")
						{
							this.SizeStart = Std.parseFloat(data.get("Start"));
							this.SizeEnd = Std.parseFloat(data.get("End"));
							this.SizeVar=Std.parseFloat(data.get("Var"));
						}	
						if (data.nodeName == "Rotation")
						{
							this.SpinStart = Std.parseFloat(data.get("Start"));
							this.SpinEnd = Std.parseFloat(data.get("End"));
							this.SpinVar=Std.parseFloat(data.get("Var"));
						}			
					   if (data.nodeName == "ColorVar")
						{
							this.ColorVar=Std.parseFloat(data.get("value"));
						}		
					   if (data.nodeName == "AlphaVar")
						{
							this.AlphaVar=Std.parseFloat(data.get("value"));
						}	
					   if (data.nodeName == "StartColor")
						{
							this.ColorStart.r = Std.parseFloat(data.get("r"));
							this.ColorStart.g = Std.parseFloat(data.get("g"));
							this.ColorStart.b = Std.parseFloat(data.get("b"));
							this.ColorStart.a =Std.parseFloat(data.get("a"));
						}			
					   if (data.nodeName == "EndColor")
						{
							this.ColorEnd.r = Std.parseFloat(data.get("r"));
							this.ColorEnd.g = Std.parseFloat(data.get("g"));
							this.ColorEnd.b = Std.parseFloat(data.get("b"));
							this.ColorEnd.a =Std.parseFloat(data.get("a"));
						}							
					}
				}
			}
		}
		/*
			trace("Emission "+Emission );
			trace("Lifetime "+Lifetime  );
			trace("ParticleLifeMin "+ParticleLifeMin  );
			trace("ParticleLifeMax "+ParticleLifeMax  );
			trace("Direction "+Direction );
			trace("Spread "+Spread );
			trace("Relative "+Relative );
			trace("SpeedMin "+SpeedMin  );
			trace("SpeedMax "+SpeedMax  );
			trace("GravityMin "+GravityMin  );
			trace("GravityMax"+GravityMax  );
			trace("radial min "+RadialAccelMin  );
			trace("radial max "+RadialAccelMax  );
			trace("Tangent Min "+TangentialAccelMin  );
			trace("Tangetn Max "+TangentialAccelMax  );
			trace("SizeStart "+SizeStart  );
			trace("SizeEnd "+SizeEnd  );
			trace("SizeVar "+SizeVar  );
			trace("SpinStart "+SpinStart  );
			trace("SpinEnd "+SpinEnd  );
			trace("SpinVar "+SpinVar  );
			trace("ColorVar "+ColorVar  );
			trace("AlphaVar "+AlphaVar  );
			
			trace("start color");
			trace(ColorStart.r );
			trace(ColorStart.g );
			trace(ColorStart.b );
			trace(ColorStart.a);
			
			trace("end color");
			trace(ColorEnd.r  );
			trace(ColorEnd.g );
			trace(ColorEnd.b );
			trace(ColorEnd.a);
			*/
	}
	public  function loadInfoFromFile(info:String) 
	{
			var bytes:ByteArray =	Assets.getBytes(info);
			bytes.endian = Endian.LITTLE_ENDIAN;
			
			   this.Frame = bytes.readInt() & 0xFFFF;
			   this.Blend = this.Frame >> 16;
			   
			   this.Emission = bytes.readInt();
			   this.Lifetime = bytes.readFloat();
			   this.ParticleLifeMin = bytes.readFloat();
			   this.ParticleLifeMax = bytes.readFloat();
			   this.Direction =  bytes.readFloat();// * 180 / 3.14159265358979323846;
			   this.Spread =  bytes.readFloat();// * 180 / 3.14159265358979323846;
			   this.Relative =  bytes.readInt();
			   
			   this.SpeedMin = bytes.readFloat();
			   this.SpeedMax = bytes.readFloat();
			   this.GravityMin = bytes.readFloat();
			   this.GravityMax = bytes.readFloat();
			   this.RadialAccelMin = bytes.readFloat();
			   this.RadialAccelMax = bytes.readFloat();
			   this.TangentialAccelMin = bytes.readFloat();
			   this.TangentialAccelMax = bytes.readFloat();
			   this.SizeStart = bytes.readFloat();
			   this.SizeEnd = bytes.readFloat();
			   this.SizeVar = bytes.readFloat();
		       this.SpinStart = bytes.readFloat();
			   this.SpinEnd = bytes.readFloat();
			   this.SpinVar = bytes.readFloat();

			   
			   this.ColorStart.r = bytes.readFloat();
			   this.ColorStart.g = bytes.readFloat();
			   this.ColorStart.b = bytes.readFloat();
			   this.ColorStart.a =bytes.readFloat();
		
			   
			   this.ColorEnd.r = bytes.readFloat();
			   this.ColorEnd.g = bytes.readFloat();
			   this.ColorEnd.b = bytes.readFloat();
			   this.ColorEnd.a = bytes.readFloat();
			   
	

			   
			   this.ColorVar = bytes.readFloat();
			   this.AlphaVar = bytes.readFloat();

			//trace(Emission );		
			   bytes = null;
			   /*
			trace(Frame);   
			trace(Blend);  
			
			trace("Emission "+Emission );
			trace("Lifetime "+Lifetime  );
			trace("ParticleLifeMin "+ParticleLifeMin  );
			trace("ParticleLifeMax "+ParticleLifeMax  );
			trace("Direction "+Direction );
			trace("Spread "+Spread );
			trace("Relative "+Relative );
			trace("SpeedMin "+SpeedMin  );
			trace("SpeedMax "+SpeedMax  );
			trace("GravityMin "+GravityMin  );
			trace("GravityMax"+GravityMax  );
			trace("radial min "+RadialAccelMin  );
			trace("radial max "+RadialAccelMax  );
			trace("Tangent Min "+TangentialAccelMin  );
			trace("Tangetn Max "+TangentialAccelMax  );
			trace("SizeStart "+SizeStart  );
			trace("SizeEnd "+SizeEnd  );
			trace("SizeVar "+SizeVar  );
			trace("SpinStart "+SpinStart  );
			trace("SpinEnd "+SpinEnd  );
			trace("SpinVar "+SpinVar  );
			trace("ColorVar "+ColorVar  );
			trace("AlphaVar "+AlphaVar  );
			
			trace("start color");
			trace(ColorStart.r );
			trace(ColorStart.g );
			trace(ColorStart.b );
			trace(ColorStart.a);
			
			trace("end color");
			trace(ColorEnd.r  );
			trace(ColorEnd.g );
			trace(ColorEnd.b );
			trace(ColorEnd.a);
			
*/
			
			   
		
	}
	public  function loadInfoFromBytes(bytes:ByteArray) 
	{
		   	bytes.endian = Endian.LITTLE_ENDIAN;
			
			   this.Frame = bytes.readInt() & 0xFFFF;
			   this.Blend = this.Frame >> 16;
			   
			   this.Emission = bytes.readInt();
			   this.Lifetime = bytes.readFloat();
			   this.ParticleLifeMin = bytes.readFloat();
			   this.ParticleLifeMax = bytes.readFloat();
			   this.Direction =  bytes.readFloat();// * 180 / 3.14159265358979323846;
			   this.Spread =  bytes.readFloat();// * 180 / 3.14159265358979323846;
			   this.Relative =  bytes.readInt();
			   
			   this.SpeedMin = bytes.readFloat();
			   this.SpeedMax = bytes.readFloat();
			   this.GravityMin = bytes.readFloat();
			   this.GravityMax = bytes.readFloat();
			   this.RadialAccelMin = bytes.readFloat();
			   this.RadialAccelMax = bytes.readFloat();
			   this.TangentialAccelMin = bytes.readFloat();
			   this.TangentialAccelMax = bytes.readFloat();
			   this.SizeStart = bytes.readFloat();
			   this.SizeEnd = bytes.readFloat();
			   this.SizeVar = bytes.readFloat();
		       this.SpinStart = bytes.readFloat();
			   this.SpinEnd = bytes.readFloat();
			   this.SpinVar = bytes.readFloat();

			   
			   this.ColorStart.r = bytes.readFloat();
			   this.ColorStart.g = bytes.readFloat();
			   this.ColorStart.b = bytes.readFloat();
			   this.ColorStart.a =bytes.readFloat();
		
			   
			   this.ColorEnd.r = bytes.readFloat();
			   this.ColorEnd.g = bytes.readFloat();
			   this.ColorEnd.b = bytes.readFloat();
			   this.ColorEnd.a = bytes.readFloat();
			   
	

			   
			   this.ColorVar = bytes.readFloat();
			   this.AlphaVar = bytes.readFloat();

			//trace(Emission );		
			   bytes = null;
			   /*
			trace(Frame);   
			trace(Blend);  
			
			trace("Emission "+Emission );
			trace("Lifetime "+Lifetime  );
			trace("ParticleLifeMin "+ParticleLifeMin  );
			trace("ParticleLifeMax "+ParticleLifeMax  );
			trace("Direction "+Direction );
			trace("Spread "+Spread );
			trace("Relative "+Relative );
			trace("SpeedMin "+SpeedMin  );
			trace("SpeedMax "+SpeedMax  );
			trace("GravityMin "+GravityMin  );
			trace("GravityMax"+GravityMax  );
			trace("radial min "+RadialAccelMin  );
			trace("radial max "+RadialAccelMax  );
			trace("Tangent Min "+TangentialAccelMin  );
			trace("Tangetn Max "+TangentialAccelMax  );
			trace("SizeStart "+SizeStart  );
			trace("SizeEnd "+SizeEnd  );
			trace("SizeVar "+SizeVar  );
			trace("SpinStart "+SpinStart  );
			trace("SpinEnd "+SpinEnd  );
			trace("SpinVar "+SpinVar  );
			trace("ColorVar "+ColorVar  );
			trace("AlphaVar "+AlphaVar  );
			
			trace("start color");
			trace(ColorStart.r );
			trace(ColorStart.g );
			trace(ColorStart.b );
			trace(ColorStart.a);
			
			trace("end color");
			trace(ColorEnd.r  );
			trace(ColorEnd.g );
			trace(ColorEnd.b );
			trace(ColorEnd.a);
			
*/
			
			   
		
	}	
		

		public inline function Smoke():Void
		{
Emission=268;
Lifetime=-1.000;
ParticleLifeMin=3.056;
ParticleLifeMax=4.008;
Direction=0.801;
Spread=0.000;
Relative = 0;
SpeedMin=300.000;
SpeedMax = 300.000;
GravityMin=0.000;
GravityMax = 0.000;
RadialAccelMin=14.286;
RadialAccelMax=0.000;
TangentialAccelMin=-14.286;
TangentialAccelMax=0.000;
SizeStart=2.192;
SizeEnd=0.471;
SizeVar=0.357;
SpinStart=-0.159;
SpinEnd=-0.159;
SpinVar=0.000;
ColorVar=0.278;
AlphaVar=0.278;
ColorStart.r=0.849;
ColorStart.g=0.667;
ColorStart.b=0.056;
ColorStart.a=1.000;
ColorEnd.r=0.333;
ColorEnd.g=0.159;
ColorEnd.b=0.786;
ColorEnd.a=0.381;
		
		}
		public inline function Fontain():Void		
		{
Emission=138;
Lifetime=-1.000;
ParticleLifeMin=0.476;
ParticleLifeMax=1.032;
Direction=0.000;
Spread=0.675;
Relative = 0;
SpeedMin=300.000;
SpeedMax = 300.000;
GravityMin=428.571;
GravityMax = 728.571;
RadialAccelMin=-0.794;
RadialAccelMax=-0.794;
TangentialAccelMin=-0.159;
TangentialAccelMax=-0.159;
SizeStart=1.676;
SizeEnd=0.154;
SizeVar=0.444;
SpinStart=-50.000;
SpinEnd=8.730;
SpinVar=0.063;
ColorVar=0.413;
AlphaVar=0.413;
ColorStart.r=0.944;
ColorStart.g=0.183;
ColorStart.b=0.095;
ColorStart.a=0.611;
ColorEnd.r=1.000;
ColorEnd.g=0.802;
ColorEnd.b=0.071;
ColorEnd.a=0.119;
		}
		public inline function Fire():Void
		{
Emission=67;
Lifetime=-1.000;
ParticleLifeMin=1.071;
ParticleLifeMax=1.944;
Direction=0.000;
Spread=1.181;
Relative = 0;
SpeedMin=114.286;
SpeedMax = 190.476;
GravityMin=0.000;
GravityMax = 0.000;
RadialAccelMin=0.000;
RadialAccelMax=0.000;
TangentialAccelMin=0.000;
TangentialAccelMax=0.000;
SizeStart=1.529;
SizeEnd=2.511;
SizeVar=0.278;
SpinStart=0.000;
SpinEnd=0.000;
SpinVar=0.000;
ColorVar=0.000;
AlphaVar=0.000;
ColorStart.r=1.000;
ColorStart.g=0.738;
ColorStart.b=0.000;
ColorStart.a=0.905;
ColorEnd.r=0.571;
ColorEnd.g=0.000;
ColorEnd.b=0.246;
ColorEnd.a=0.056;
			
		}
		
		
	

}

   class ParticleEmitter extends GameObject

	{
		
	
     private var MAXP:Float   =300;
	 private var M_PI:Float   = 3.14159265358979323846;
     private var M_PI_2:Float = 1.57079632679489661923;
  
	public var FAge: Float;
    private var FEmissionResidue: Float;
    private var FPrevLocation: Point;
    private var FLocation: Point;
    private var FTX:Float;
	private var FTY: Float;
    private var spaw:Int;
	public var FInfo:ParticleSystemInfo;
	private var usetexture:Texture;
	
	private var Accel:Point;
	private var Accel2:Point;
	private var V:Point;
 
	public var nParticlesAlive:Int;
	private var clip:Clip;

	
	private var Time:Int = 0;
	private var LastEmitTime:Int = 0;
	private var blendMode:Int;
		
	public var FParticles:Array<MParticle>;
		
		public inline function new(texture:Texture) 
		{
			super();
			FEmissionResidue = 0;
			if (texture != null)
			{
			usetexture = texture;
			clip = new  Clip(0, 0, texture.width, texture.height);
			} else
			{
				texture = null;
				clip = new Clip(0, 0, 0, 0);
			}
		
				
			FParticles = [];
		
			FPrevLocation = new Point();
			FLocation = new Point(0, 0);
			
			 Accel= new Point();
	         Accel2= new Point();
             V= new Point();
			  FAge = -2;
              spaw=0;
			  nParticlesAlive=0;
			  blendMode = BlendMode.ADD;	
			FInfo = new ParticleSystemInfo();

			  

		}
		
	public inline function loadInfo(info:ParticleSystemInfo) 
	{
		FInfo = null;
		this.FInfo = info;
	}
	public inline function loadInfoFromFile(info:String) 
	{
		FInfo = new ParticleSystemInfo();
		FInfo.loadInfoFromFile(info);
	
	}
	public inline function parceInfoFromFile(info:String) 
	{
		FInfo = new ParticleSystemInfo();
		FInfo.parseInfoFromFile(info);
	
	}
		
  
	
public inline function createFire() 
	{
		FInfo = null;
		FInfo = new ParticleSystemInfo();
		FInfo.Fire();
	}	
public inline function createFontain() 
	{
		FInfo = null;
		FInfo = new ParticleSystemInfo();
		FInfo.Fontain();
	}	
		
		
public inline function Fire():Void
    {
         if (FInfo.Lifetime == -1) 
           FAge = -1;
            else
           FAge = 0;
   }
public inline function  FireAt( X:Float, Y: Float):Void
{
  Stop();
  MoveTo(X,Y);
  Fire();
}

public inline function Stop(KillParticles: Bool=false):Void
{
  FAge = -2;
  if (KillParticles) nParticlesAlive = 0;
}

public inline function removeParticle(entity:MParticle):Void 
{
		FParticles.remove(entity);
		nParticlesAlive--;
}

public inline function MoveTo( X:Float, Y:Float, MoveParticles: Bool=false):Void
{
  var I:Int;
  var DX:Float;
  var DY:Float;

  if (MoveParticles) 
  {
    DX = X - FLocation.x;
    DY = Y - FLocation.y;
    for (I in 0... nParticlesAlive)
	{
      FParticles[I].Location.x = FParticles[I].Location.x + DX;
      FParticles[I].Location.y = FParticles[I].Location.y + DY;
    }
    FPrevLocation.x = FPrevLocation.x + DX;
    FPrevLocation.y = FPrevLocation.y + DY;
  } else 
  {
    if (FAge == -2) 
	{
      FPrevLocation.x = X;
      FPrevLocation.y = Y;
    } else 
	{
      FPrevLocation.x = FLocation.x;
      FPrevLocation.y = FLocation.y;
    }
  }
  FLocation.x = X;
  FLocation.y = Y;
}



 public  function renderBatch(batch:SpriteBatch)
{
     if (usetexture == null) return;
    if (FParticles.length <= 0) return;
	  

	
	  
	        var I:Int=0;
            var spin:Float;	  
            var dstx:Float; 
			var dsty:Float;
            var xOffset:Float =  clip.width  / 2;
            var yOffset:Float =  clip.height / 2;
			
			
            var color:Color4;
			var matrix =	this.getLocalToWorldMatrix();
			
	 while (I<nParticlesAlive)
	 {
	 
  	  var particle:MParticle = FParticles[I];
	  color = particle.Color;
	  spin = particle.Spin*particle.Age;
	        
            var px:Float = particle.Location.x;
			var py:Float = particle.Location.y;
			dstx = matrix.a * px + matrix.c * py + matrix.tx;
		    dsty = matrix.d * py + matrix.b * px + matrix.ty;
		           var  TX1 = -xOffset * particle.Size;
                   var  TY1 = -yOffset * particle.Size;
                   var  TX2 = (clip.width  - xOffset) * particle.Size;
                   var  TY2 = (clip.height - yOffset) * particle.Size;

			
		       if (spin!=0)
                {
       
                   var CosT:Float  = Math.cos(spin);
                   var SinT:Float  = Math.sin(spin);
                 	
      batch.drawVertex(usetexture,
 TX1 * CosT - TY1 * SinT + dstx,TX1 * SinT + TY1 * CosT + dsty,
 TX2 * CosT - TY1 * SinT + dstx,TX2 * SinT + TY1 * CosT + dsty,
 TX2 * CosT - TY2 * SinT + dstx,TX2 * SinT + TY2 * CosT + dsty,
 TX1 * CosT - TY2 * SinT + dstx,TX1 * SinT + TY2 * CosT + dsty,
 clip,  color.r, color.g, color.b, color.a, blendMode);
				   

				   
                }
                else 
                {
				
		
				batch.drawVertex(usetexture,
                TX1 + dstx, TY1 + dsty,
                TX2 + dstx, TY1 + dsty,
                TX2 + dstx, TY2 + dsty,
                TX1 + dstx, TY2 + dsty,
				clip,  color.r, color.g, color.b, color.a, blendMode);
				

	
				}
         I++;       	
		}
}		
		
override public inline function update(dt:Float)
{
		  
	  if (FAge >= 0) 
      {
        FAge = FAge + dt;
        if (FAge >= FInfo.Lifetime) 
        FAge = -2;
	  }
	  
	    move(dt);
	  
	    if (FAge != -2) 
		{
   
  
		 
		    var  ParticlesNeeded:Float  =FInfo.Emission * dt + FEmissionResidue;
            var  ParticlesCreated:Int =Std.int( ParticlesNeeded);	
             FEmissionResidue = ParticlesNeeded - ParticlesCreated;
      	 
			// trace(ParticlesCreated + '<>', ParticlesNeeded + '<>' + FEmissionResidue);

	
			 
		    for (I in 0... ParticlesCreated)
            {
			      if (FParticles.length >= MAXP) break ;
				  var Par: MParticle = new MParticle();
				  reset(Par);
			      FParticles.push(Par);
			      nParticlesAlive++;
			}
			
			
		    }
		FPrevLocation = FLocation;
		}
		
		private inline function reset(Par:MParticle):Void
		{
		var Ang:Float;	
	    Par.Age = 0;
        Par.TerminalAge = Util.randf(FInfo.ParticleLifeMin,FInfo.ParticleLifeMax);
        Par.Location.x = FPrevLocation.x + (FLocation.x - FPrevLocation.x)* Util.randf(0.0,1.0);
        Par.Location.y = FPrevLocation.y + (FLocation.y - FPrevLocation.y)*  Util.randf(0.0,1.0);
        Par.Location.x = Par.Location.x +  Util.randf(-2.0,2.0);
        Par.Location.y = Par.Location.y +  Util.randf(-2.0,2.0);
        
		
		
		Ang = FInfo.Direction -M_PI_2 +Util.randf(0, FInfo.Spread) - FInfo.Spread / 2;

		
        if (FInfo.Relative==1) 
        {
           V.x = FPrevLocation.x - FLocation.x;
           V.y = FPrevLocation.y - FLocation.y;
           Ang = Ang + (Util.VectorAnglTan(V) + M_PI_2);
        }
      Par.Velocity.x = Math.cos(Ang);
      Par.Velocity.y = Math.sin(Ang);
      Par.Velocity.x=Par.Velocity.x*Util.randf(FInfo.SpeedMin,FInfo.SpeedMax);
      Par.Velocity.y=Par.Velocity.y*Util.randf(FInfo.SpeedMin,FInfo.SpeedMax);


      Par.Gravity = Util.randf(FInfo.GravityMin,FInfo.GravityMax);
      Par.RadialAccel =Util.randf(FInfo.RadialAccelMin,FInfo.RadialAccelMax);
      Par.TangentialAccel = Util.randf(FInfo.TangentialAccelMin,FInfo.TangentialAccelMax);

      Par.Size = Util.randf(FInfo.SizeStart,FInfo.SizeStart+ (FInfo.SizeEnd - FInfo.SizeStart) * FInfo.SizeVar);
      Par.SizeDelta = (FInfo.SizeEnd - Par.Size) / Par.TerminalAge;

      Par.Spin = Util.randf(FInfo.SpinStart,FInfo.SpinStart+ (FInfo.SpinEnd - FInfo.SpinStart) * FInfo.SpinVar);
      Par.SpinDelta  = (FInfo.SpinEnd - Par.Spin) / Par.TerminalAge;
			

      Par.Color.r = Util.randf(FInfo.ColorStart.r,FInfo.ColorStart.r+ (FInfo.ColorEnd.r - FInfo.ColorStart.r) * FInfo.ColorVar);
      Par.Color.g = Util.randf(FInfo.ColorStart.g,FInfo.ColorStart.g+ (FInfo.ColorEnd.g - FInfo.ColorStart.g) * FInfo.ColorVar);
      Par.Color.b = Util.randf(FInfo.ColorStart.b,FInfo.ColorStart.b+ (FInfo.ColorEnd.b - FInfo.ColorStart.b) * FInfo.ColorVar);
      Par.Color.a = Util.randf(FInfo.ColorStart.a,FInfo.ColorStart.a+ (FInfo.ColorEnd.a - FInfo.ColorStart.a) * FInfo.ColorVar);

      Par.ColorDelta.r = (FInfo.ColorEnd.r - Par.Color.r) / Par.TerminalAge;
      Par.ColorDelta.g = (FInfo.ColorEnd.g - Par.Color.g) / Par.TerminalAge;
      Par.ColorDelta.b = (FInfo.ColorEnd.b - Par.Color.b) / Par.TerminalAge;
      Par.ColorDelta.a = (FInfo.ColorEnd.a - Par.Color.a) / Par.TerminalAge;
	 
	}
		
	
private  function move( dt: Float):Void
{
	  var Ang:Float;
	  var I:Int=0;
		  
	 if (FParticles.length <= 0) return;
	  
	 while (I<nParticlesAlive)
	 {
	  var Par:MParticle = FParticles[I];
	  Par.Age = Par.Age + dt;
	
         if (Par.Age >= Par.TerminalAge  || Par.Color.a < 0.0 || Par.Size<0.1)  
             {
			  	removeParticle(Par);
			    continue;
	         }			

    Accel.x = Par.Location.x - FLocation.x;
    Accel.y = Par.Location.y - FLocation.y;




    Accel=Util.VectorNormalize(Accel);
    Accel2 = Accel;
    Accel.x=Accel.x*Par.RadialAccel;
    Accel.y=Accel.y*Par.RadialAccel;


    Ang = Accel2.x;
    Accel2.x = -Accel2.y;
    Accel2.y = Ang;




    Accel2.x=Accel2.x*Par.TangentialAccel;
    Accel2.y=Accel2.y*Par.TangentialAccel;

    Par.Velocity.x=Par.Velocity.x+(Accel.x + Accel2.x) * dt;
    Par.Velocity.y=Par.Velocity.y+(Accel.y + Accel2.y) * dt;

    Par.Velocity.y = Par.Velocity.y + (Par.Gravity * dt);

    Par.Location.x=Par.Location.x+(Par.Velocity.x * dt);
    Par.Location.y=Par.Location.y+(Par.Velocity.y * dt);


    Par.Spin = Par.Spin + (Par.SpinDelta * dt);
    Par.Size  = Par.Size + (Par.SizeDelta * dt);
		

    Par.Color.r = Par.Color.r     + (Par.ColorDelta.r * dt);
    Par.Color.g = Par.Color.g + (Par.ColorDelta.g * dt);
    Par.Color.b = Par.Color.b   + (Par.ColorDelta.b * dt);
    Par.Color.a = Par.Color.a + (Par.ColorDelta.a * dt);
   I++;
		  
  }
}

    public var angle(get_angle, set_angle):Float;
	private inline function get_angle():Float
	{return FInfo.Direction;}
	private inline function set_angle(value:Float):Float
	{FInfo.Direction = value; return FInfo.Direction; }	
	
	public var spread(get_spread, set_spread):Float;
	private inline function get_spread():Float
	{return FInfo.Spread;}
	private inline function set_spread(value:Float):Float
	{FInfo.Spread = value; return FInfo.Spread; }	
	
	
	

}