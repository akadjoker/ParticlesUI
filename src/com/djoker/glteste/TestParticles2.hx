package com.djoker.glteste;

import flash.utils.ByteArray;
import haxe.ui.toolkit.core.Toolkit;
import haxe.ui.toolkit.core.Root;
import haxe.ui.toolkit.containers.VBox;
import haxe.ui.toolkit.controls.Button;
import haxe.ui.toolkit.controls.Slider;
import haxe.ui.toolkit.controls.HSlider;
import haxe.ui.toolkit.controls.VSlider;
import haxe.ui.toolkit.controls.HScroll;
import haxe.ui.toolkit.controls.VScroll;
import haxe.ui.toolkit.controls.CheckBox;
import haxe.ui.toolkit.controls.Text;

import flash.events.MouseEvent;


import haxe.ui.toolkit.core.Macros;

import com.engine.game.Entity;
import com.engine.game.Screen;
import com.engine.render.SpriteBatch;
import com.engine.render.Texture;
import com.engine.render.BlendMode;

import com.engine.tween.NumTween;
import com.engine.tween.Tween;
import com.engine.tween.Ease;
import com.engine.tween.LinearMotion;

import com.engine.misc.Util;
import haxe.ui.toolkit.controls.Button;
import haxe.ui.toolkit.events.UIEvent;

//import com.engine.particles.ParticleSystemInfo;
import com.engine.particles.ParticleEmitter;


import flash.events.Event;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.Lib;



#if neko
import systools.Dialogs;
import sys.io.File;
import sys.io.FileOutput;
#end
/**
 * ...
 * @author djoker
 */
class TestParticles2 extends Screen
{
	 private var M_PI:Float   = 3.14159265358979323846;
     private var M_PI_2:Float = 1.57079632679489661923;

 var caption:TextField;
 var batch : SpriteBatch;

   var pmanager:ParticleEmitter;
   var root:Root;
   var lifeSlider:HScroll;
   var emissionSlider:HScroll;	
   var angleSlider:HScroll;	
   var spreadSlider:HScroll;	
   
   var siseStartSlider:HScroll;
   var siseEndSlider:HScroll;
   var siseVarSlider:HScroll;
   
   var spinStartSlider:HScroll;
   var spinEndSlider:HScroll;
   var spinVarSlider:HScroll;
   
   var gravityMinSlider:HScroll;
   var gravityMaxSlider:HScroll;
   
   var radialMinSlider:HScroll;
   var radialMaxSlider:HScroll;

   var tanMinSlider:HScroll;
   var tanMaxSlider:HScroll;
   
   var colorVarSlider:HScroll;
   var alphaVarSlider:HScroll;
   
   
   var   SpeedMin:HScroll;
   var   SpeedMax:HScroll;
   
   var   ColorStartR:HScroll;
   var   ColorStartG:HScroll;
   var   ColorStartB:HScroll;
   var   ColorStartA:HScroll;
   
   var   ColorEndR:HScroll;
   var   ColorEndG:HScroll;
   var   ColorEndB:HScroll;
   var   ColorEndA:HScroll;
   
      
   var lifeLoop:CheckBox;
   var continuous:CheckBox;
    var tex:Texture;

   
   public function addHScrol(x:Float, y:Float, w:Float, h:Float, min:Float, max:Float,def:Float,caption:String="label"):HScroll
   {
	   var sl:HScroll = new HScroll();
	   	     sl.x = x;
			 sl.y = y;
			 sl.width = w;
			 sl.height = h;
			 sl.min = min;
			 sl.max = max;
			 sl.pos = def;
			 root.addChild(sl);
			 
			 var lb:Text = new Text();
			 lb.x = x +w;
			 lb.y = -y+h;
			 lb.text = caption;
		
			 lb.inlineStyle.color = 0xffffff;
			 sl.addChild(lb);
			 
			 return sl;
	   
   }   
   public function addHSlider(x:Float, y:Float, w:Float, h:Float, min:Float, max:Float,def:Float):HSlider
   {
	   var sl:HSlider = new HSlider();
	   	     sl.x = x;
			 sl.y = y;
			 sl.width = w;
			 sl.height = h;
			 sl.min = min;
			 sl.max = max;
			 sl.pos = def;
			 root.addChild(sl);
			 return sl;
	   
   }
   public function loadDefaults()
   {
	      emissionSlider.pos = pmanager.FInfo.Emission;
		lifeSlider.pos = pmanager.FInfo.Lifetime;
		angleSlider.pos=pmanager.FInfo.Direction;
		spreadSlider.pos=pmanager.FInfo.Spread ;
		
		siseStartSlider.pos=pmanager.FInfo.SizeStart*tex.width;
		siseEndSlider.pos=pmanager.FInfo.SizeEnd*tex.height;
		siseVarSlider.pos=pmanager.FInfo.SizeVar*255.0 ;
	
		
		spinStartSlider.pos=pmanager.FInfo.SpinStart;
		spinEndSlider.pos=pmanager.FInfo.SpinEnd;
		spinVarSlider.pos = pmanager.FInfo.SpinVar ;
		
		
		gravityMinSlider.pos=pmanager.FInfo.GravityMin ;
		gravityMaxSlider.pos=pmanager.FInfo.GravityMax ;
		
		radialMinSlider.pos=pmanager.FInfo.RadialAccelMin ;
		radialMaxSlider.pos = pmanager.FInfo.RadialAccelMax ;
		
		tanMinSlider.pos=pmanager.FInfo.TangentialAccelMin ;
		tanMaxSlider.pos = pmanager.FInfo.TangentialAccelMax;
		

		SpeedMin.pos=pmanager.FInfo.SpeedMin ;
		SpeedMax.pos = pmanager.FInfo.SpeedMax ;
		
		colorVarSlider.pos=pmanager.FInfo.ColorVar*255.0 ;
		alphaVarSlider.pos = pmanager.FInfo.AlphaVar*255.0;
		
		 
		ColorStartR.pos = pmanager.FInfo.ColorStart.r * 255.0;
		ColorStartG.pos = pmanager.FInfo.ColorStart.g * 255.0;
		ColorStartB.pos = pmanager.FInfo.ColorStart.b * 255.0;
		ColorStartA.pos = pmanager.FInfo.ColorStart.a * 255.0;
		
		ColorEndR.pos = pmanager.FInfo.ColorEnd.r * 255.0;
		ColorEndG.pos = pmanager.FInfo.ColorEnd.g * 255.0;
		ColorEndB.pos = pmanager.FInfo.ColorEnd.b * 255.0;
		ColorEndA.pos = pmanager.FInfo.ColorEnd.a * 255.0;
   }
	override public function show()
	{
				Macros.addStyleSheet("assets/styles/gradient/gradient.css");
		
       Toolkit.init();
        Toolkit.openFullscreen(function(root:Root) 
		{
         this.root = root;
        });
		
		  tex = getTexture("assets/fire_particle.png");
	
//lifetime

var posy:Float = 40;
			lifeSlider    = addHScrol(10, posy, 149, 6, -1, 50, 1, 'Life');
			continuous = new CheckBox();
			continuous.x= game.screenWidth-150;
			continuous.y= game.screenHeight-20;
			root.addChild(continuous);
			continuous.selected = false;
			
			 var lb:Text = new Text();
			 lb.x = 0;
			 lb.y = 0;
			 lb.text = 'Move by Mouse';
			 lb.inlineStyle.color = 0xffffff;
			 continuous.addChild(lb);

			 lifeLoop = new CheckBox();
			lifeLoop.x= game.screenWidth-150;
			lifeLoop.y= game.screenHeight-50;
			root.addChild(lifeLoop);
			lifeLoop.selected = true;
			
			 var lb:Text = new Text();
			 lb.x = 0;
			 lb.y = 0;
			 lb.text = 'Life Loop';
			 lb.inlineStyle.color = 0xffffff;
			 lifeLoop.addChild(lb);
			   
			   posy += 24;
			   emissionSlider=addHScrol(10, posy, 149, 6, 0, 300,100,'Emission');
               posy += 24;			 
			   angleSlider = addHScrol(9, posy, 149, 6, 0, 2 * M_PI, M_PI, 'Angle');
			   posy += 24;
			   spreadSlider = addHScrol(9, posy, 149, 6, 0, 2 * M_PI, M_PI, 'Spread');
			
			   posy += 30;
	         SpeedMin = addHScrol(9, posy, 149, 6, -600, 600, 0,'SpeedMin');
			 posy += 24;
			 SpeedMax = addHScrol(9, posy, 149, 6, -600, 600, 0,'SpeedMax');

			   posy += 35;
			 gravityMinSlider = addHScrol(9, posy, 149, 6, -1000, 1000, 0,'Gravity Min');
			   posy += 24;
			 gravityMaxSlider = addHScrol(9, posy, 149, 6,  -1000, 1000, 0,'Gravity Max');
			 
			 posy += 60;
			 siseStartSlider = addHScrol(9, posy, 149, 6, 0, 200, tex.width,'Size Start');
			 posy += 24;
			 siseEndSlider = addHScrol(9, posy, 149, 6, 0, 200, tex.height,'Size End');
			 posy += 24;
			 siseVarSlider = addHScrol(9, posy, 149, 6, 0, 255, 0, 'Size Var');
			 
			 		 posy += 60;
			 spinStartSlider = addHScrol(9, posy, 149, 6, -50, 50,0,'Spin Start');
			 posy += 24;
			 spinEndSlider = addHScrol(9, posy, 149, 6, -50, 50, 0,'Spin End');
			 posy += 24;
			 spinVarSlider = addHScrol(9, posy, 149, 6, 0, 255, 0,'Spin Var');
			
			 posy += 35;
			 radialMinSlider = addHScrol(9, posy, 149, 6, -900, 900, 0,'RadialAcc Min');
			 posy += 24;
			 radialMaxSlider = addHScrol(9, posy, 149, 6,  -900, 900, 0,'RadialAcc Max');
	
			 posy += 35;
			 tanMinSlider = addHScrol(9, posy, 149, 6, -1000, 1000, 0,'TagentAcc Min');
			 posy += 24;
			 tanMaxSlider = addHScrol(9, posy, 149, 6,  -1000, 1000, 0, 'TangentAcc Max');
			 
			 //********************
			   posy = 0;
			   posy += 24;
			   colorVarSlider =addHScrol(game.screenWidth-200, posy, 149, 6, 0, 255,  0 ,'ColorVar');
               posy += 24;			 
			   alphaVarSlider = addHScrol(game.screenWidth-200, posy , 149, 6, 0,255, 0, 'AlphaVar');
			  
			   posy += 40;			 
			   ColorStartR = addHScrol(game.screenWidth-200, posy , 149, 6, 0,255, 0, 'ColorStart Red');
			   posy += 24;			 
			   ColorStartG = addHScrol(game.screenWidth-200, posy , 149, 6, 0,255, 0, 'ColorStart Green');
			   posy += 24;			 
			   ColorStartB = addHScrol(game.screenWidth-200, posy , 149, 6, 0,255, 0, 'ColorStart Blue');
			   posy += 24;			 
			   ColorStartA = addHScrol(game.screenWidth-200, posy , 149, 6, 0,255, 0, 'ColorStart Alpha');
			  
			   	   posy += 40;			 
			   ColorEndR = addHScrol(game.screenWidth-200, posy , 149, 6, 0,255, 0, 'ColorEnd Red');
			   posy += 24;			 
			   ColorEndG = addHScrol(game.screenWidth-200, posy , 149, 6, 0,255, 0, 'ColorEnd Green');
			   posy += 24;			 
			   ColorEndB = addHScrol(game.screenWidth-200, posy , 149, 6, 0,255, 0, 'ColorEnd Blue');
			   posy += 24;			 
			   ColorEndA = addHScrol(game.screenWidth-200, posy , 149, 6, 0,255, 0, 'ColorEnd Alpha');
			   
posy += 50;	
var but:Button = new Button();
but.x = game.screenWidth-180;
but.y = posy;
but.height = 20;
but.width = 140;
but.addEventListener(UIEvent.CLICK, function(e:UIEvent) 
{ 

	ColorStartR.pos = Util.randf(0, 255);
	ColorStartG.pos = Util.randf(0, 255);
	ColorStartB.pos = Util.randf(0, 255);
	ColorStartA.pos = Util.randf(0, 255);
	
	
});
but.text = 'Random Start Color';
root.addChild(but);
//*******

posy += 25;	
var but:Button = new Button();
but.x = game.screenWidth-180;
but.y = posy;
but.height = 20;
but.width = 140;
but.addEventListener(UIEvent.CLICK, function(e:UIEvent) 
{ 

	ColorEndR.pos = Util.randf(0, 255);
	ColorEndG.pos = Util.randf(0, 255);
	ColorEndB.pos = Util.randf(0, 255);
	ColorEndA.pos = Util.randf(0, 255);
	
	
});
but.text = 'Random End Color';
root.addChild(but);

//*******

posy += 25;	
var but:Button = new Button();
but.x = game.screenWidth-180;
but.y = posy;
but.height = 20;
but.width = 140;
but.addEventListener(UIEvent.CLICK, function(e:UIEvent) 
{ 

        spinStartSlider.pos=Util.randf(-50, 50);
		spinEndSlider.pos  =Util.randf(-50, 50);
		spinVarSlider.pos  = Util.randf(0, 255);
	
	
});
but.text = 'Random Spin';
root.addChild(but);		


	 	
//*******
posy += 25;	
var but:Button = new Button();
but.x = game.screenWidth-180;
but.y = posy;
but.height = 20;
but.width = 140;
but.addEventListener(UIEvent.CLICK, function(e:UIEvent) 
{ 

        siseStartSlider.pos=Util.randf(0, 200);
		siseEndSlider.pos  =Util.randf(0, 200);
		siseVarSlider.pos  = Util.randf(0, 255);
	
			 
			 
});
but.text = 'Random Size';
root.addChild(but);		
//**
posy += 25;	
var but:Button = new Button();
but.x = game.screenWidth-180;
but.y = posy;
but.height = 20;
but.width = 140;
but.addEventListener(UIEvent.CLICK, function(e:UIEvent) 
{ 

        radialMinSlider.pos = Util.randf( -900, 900);
		radialMaxSlider.pos=Util.randf(-900, 900);
		tanMinSlider.pos = Util.randf( -1000, 1000);
		tanMaxSlider.pos=Util.randf(-1000, 1000);
		
	
	
});
but.text = 'Random Acc';
root.addChild(but);		

posy += 25;	
var but:Button = new Button();
but.x = game.screenWidth-180;
but.y = posy;
but.height = 20;
but.width = 140;
but.addEventListener(UIEvent.CLICK, function(e:UIEvent) 
{ 

        angleSlider.pos = Util.randf( 0, 2 * M_PI);
		spreadSlider.pos=Util.randf(0, 2 * M_PI);
		
		
	
	
});
but.text = 'Random Angle,Spread';
root.addChild(but);	


posy += 25;	
var but:Button = new Button();
but.x = game.screenWidth-180;
but.y = posy;
but.height = 20;
but.width = 140;
but.addEventListener(UIEvent.CLICK, function(e:UIEvent) 
{ 

        SpeedMin.pos = Util.randf( -600,600);
		SpeedMax.pos=Util.randf(-600, 600);
		
			
	
	
});
but.text = 'Random Speed';
root.addChild(but);	


posy += 25;	
var but:Button = new Button();
but.x = game.screenWidth-180;
but.y = posy;
but.height = 20;
but.width = 140;
but.addEventListener(UIEvent.CLICK, function(e:UIEvent) 
{ 

        angleSlider.pos = Util.randf( 0, 2 * M_PI);
		spreadSlider.pos=Util.randf(0, 2 * M_PI);
		    angleSlider.pos = Util.randf( 0, 2 * M_PI);
		spreadSlider.pos=Util.randf(0, 2 * M_PI);
		    radialMinSlider.pos = Util.randf( -900, 900);
		radialMaxSlider.pos=Util.randf(-900, 900);
		tanMinSlider.pos = Util.randf( -1000, 1000);
		tanMaxSlider.pos=Util.randf(-1000, 1000);
		
        spinStartSlider.pos=Util.randf(-50, 50);
		spinEndSlider.pos  =Util.randf(-50, 50);
		spinVarSlider.pos  = Util.randf(0, 255);
		
		SpeedMin.pos = Util.randf( -600,600);
		SpeedMax.pos=Util.randf(-600, 600);
		
		
	ColorEndR.pos = Util.randf(0, 255);
	ColorEndG.pos = Util.randf(0, 255);
	ColorEndB.pos = Util.randf(0, 255);
	ColorEndA.pos = Util.randf(0, 255);
	
	ColorStartR.pos = Util.randf(0, 255);
	ColorStartG.pos = Util.randf(0, 255);
	ColorStartB.pos = Util.randf(0, 255);
	ColorStartA.pos = Util.randf(0, 255);
	
});
but.text = 'Random';
root.addChild(but);	

//*****
posy += 25;	
var but:Button = new Button();
but.x = game.screenWidth-180;
but.y = posy;
but.height = 20;
but.width = 140;
but.addEventListener(UIEvent.CLICK, function(e:UIEvent) 
{ 
pmanager.FInfo = null;
pmanager.FInfo = new ParticleSystemInfo();
   
		loadDefaults();
			
	
	
});
but.text = 'Reset';
root.addChild(but);	
         batch = new SpriteBatch(1500);
   
	
		  caption = new TextField();
		 caption.x =  game.gameWidth / 2-100;
		 caption.y = 20;
		 caption.width = 200;
		 caption.defaultTextFormat = new TextFormat ("_sans", 12, 0xffff00);
		 caption.text = "Test Particles , parents and tween";
		 caption.selectable = false;
		 game.addChild(caption);
		 
	
	 
		
	 pmanager = new  ParticleEmitter(tex);
	// pmanager.createFire();
	//pmanager.loadInfoFromFile("assets/particle1.psi");
	//pmanager.parceInfoFromFile("assets/particle1.xml");
	 pmanager.FireAt(game.screenWidth / 2, game.screenHeight / 2);

     
		loadDefaults();
		/*
	 
	 var but:Button = new Button();
but.x = game.screenWidth-50;
but.y = game.screenHeight-50;
but.height = 25;

but.addEventListener(UIEvent.CLICK, function(e:UIEvent) 
{
//pmanager.Stop();
pmanager.FAge = 0;



});
but.text = 'Kill';
root.addChild(but);
	*/

	 //
//downloader= new FileReference();
	 #if neko
	 var but:Button = new Button();
but.x = game.screenWidth/2+80;
but.y = game.screenHeight-30;
but.height = 25;

but.addEventListener(UIEvent.CLICK, function(e:UIEvent) 
{

var filters: FILEFILTERS = 
			{ count: 1
			, descriptions: ["Xml files"]
			, extensions: ["*.xml"]			
			};		
		var  result = Dialogs.openFile
			( "Select a file please!"
			, "Please select particle system"
			, filters 
			);
		//trace(result);		
		

		var ba2:ByteArray = ByteArray.readFile(result[0]);
		if (ba2.bytesAvailable > 1)
		{
					pmanager.Stop();
		pmanager.FInfo = null;
        pmanager.FInfo = new ParticleSystemInfo();

		pmanager.FInfo.parseInfoFromString(ba2.toString());
		loadDefaults();
		pmanager.Fire();
		}

		
		

});
but.text = 'Load Particle';
root.addChild(but);
//****************************
 var but:Button = new Button();
but.x = game.screenWidth/2-80;
but.y = game.screenHeight-30;
but.height = 25;

but.addEventListener(UIEvent.CLICK, function(e:UIEvent) 
{

var filters: FILEFILTERS = 
			{ count: 1
			, descriptions: [ "Hge psi files"]
			, extensions: ["*.psi"]			
			};		
		var  result = Dialogs.openFile
			( "Select a file please!"
			, "Please select particle system"
			, filters 
			);
		//trace(result);		
		

		pmanager.Stop();
		pmanager.FInfo = null;
        pmanager.FInfo = new ParticleSystemInfo();
		var ba2:ByteArray = ByteArray.readFile(result[0]);
		pmanager.FInfo.loadInfoFromBytes(ba2);
		loadDefaults();
		pmanager.Fire();

		
		

});
but.text = 'Import PSI';
root.addChild(but);
//*****
 var but:Button = new Button();
but.x = game.screenWidth/2+10;
but.y = game.screenHeight-30;
but.height = 25;

but.addEventListener(UIEvent.CLICK, function(e:UIEvent) 
{

	
		var  result = Dialogs.saveFile
			( "Select Particle as XML"
			, "Particles"
			, "" // initial path, for windows only
			);
		trace(result);		

			  var f:FileOutput = File.write(result);
               f.writeString( pmanager.FInfo.toXml());
               f.close();
			
		

		

});
but.text = 'Save';
root.addChild(but);
#end
		 
		 game.clarColor(0, 0, 0.4);


	}
	
	

	public function onDown():Void
	{
		
	}
	
	override public inline function update(dt:Float) 
	{ 

		
		
		
	}

	override public  inline function render() 
	{ 
  
		pmanager.FInfo.Emission = Std.int( emissionSlider.pos);
		pmanager.FInfo.Lifetime = lifeSlider.pos;
		pmanager.FInfo.Direction = angleSlider.pos;
		pmanager.FInfo.Spread = spreadSlider.pos;
		
		pmanager.FInfo.SizeStart = siseStartSlider.pos/tex.width;
		pmanager.FInfo.SizeEnd = siseEndSlider.pos/tex.height;
		pmanager.FInfo.SizeVar = siseVarSlider.pos/255.0;
		
		pmanager.FInfo.SpinStart = spinStartSlider.pos;
		pmanager.FInfo.SpinEnd = spinEndSlider.pos;
		pmanager.FInfo.SpinVar = spinVarSlider.pos;
		
		
		pmanager.FInfo.GravityMin = gravityMinSlider.pos;
		pmanager.FInfo.GravityMax = gravityMaxSlider.pos;
		
		pmanager.FInfo.RadialAccelMin = radialMinSlider.pos;
		pmanager.FInfo.RadialAccelMax = radialMaxSlider.pos;
		
		pmanager.FInfo.TangentialAccelMin =tanMinSlider.pos/100;
		pmanager.FInfo.TangentialAccelMax= tanMaxSlider.pos/100;

		pmanager.FInfo.SpeedMin = SpeedMin.pos;
		pmanager.FInfo.SpeedMax = SpeedMax.pos;
		
		
		 pmanager.FInfo.ColorVar=colorVarSlider.pos/255.0 ;
		 pmanager.FInfo.AlphaVar = alphaVarSlider.pos / 255.0;
		 
		 pmanager.FInfo.ColorStart.r = ColorStartR.pos / 255.0;
		 pmanager.FInfo.ColorStart.g = ColorStartG.pos / 255.0;
		 pmanager.FInfo.ColorStart.b = ColorStartB.pos / 255.0;
		 pmanager.FInfo.ColorStart.a = ColorStartA.pos / 255.0;
		 
		pmanager.FInfo.ColorEnd.r = ColorEndR.pos / 255.0;
		pmanager.FInfo.ColorEnd.g = ColorEndG.pos / 255.0;
		pmanager.FInfo.ColorEnd.b = ColorEndB.pos / 255.0;
		pmanager.FInfo.ColorEnd.a = ColorEndA.pos / 255.0;
		 
		 
		

    if (lifeLoop.selected==true) 
	{
		pmanager.FAge = -1;

	} else 
	{
	//pmanager.FAge = -2;
	}
   
	
		pmanager.update(game.deltaTime);
		  
	batch.Begin();
	
	

 pmanager.renderBatch(batch);
	 
      batch.End();
	
	 
	   caption.text = "Particles Alive:"+pmanager.nParticlesAlive;

	}

		
		

	override public  function mouseDown(mousex:Float, mousey:Float) 
{
		
	if (continuous.selected)
	{
		 pmanager.FireAt(mousex,mousey);
	} else
	{
	
		 pmanager.FireAt(game.screenWidth / 2, game.screenHeight / 2);
	}
		// pmanager.FAge = 0;

	
	  
}


}