package com.djoker.glteste;
 
import flash.display.BlendMode;
import flash.display.Sprite;
import flash.geom.ColorTransform;
import flash.geom.Rectangle;
import flash.geom.Matrix3D;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.events.MouseEvent;



import openfl.display.OpenGLView;
import openfl.gl.GL;
import openfl.gl.GLBuffer;
import openfl.gl.GLProgram;
import openfl.utils.Float32Array;
import openfl.utils.Int16Array;
import openfl.display.FPS;
import openfl.Assets;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.utils.ByteArray;
import flash.Lib;

import flash.system.System;
import flash.system.Capabilities;



import com.engine.game.Game;

import flash.text.TextField;
import flash.text.TextFormat;



class Main extends Game {

   




override function begin() 
{
trace(System.totalMemory * 0.000000954); 
//	fixRatio(480, 320);


//this.setScreen(new TesteBatch());
//this.setScreen(new TesteAtlas());
//this.setScreen(new TesteCloud());
//this.setScreen(new TesteCloudTiles());
//this.setScreen(new TesteBlockTiles());
//this.setScreen(new TesteBlockTilesCache());
//this.setScreen(new TesteTiles());
//this.setScreen(new TestePrimitives());
//this.setScreen(new TesteBitmap());
//this.setScreen(new TestTrasform());
//this.setScreen(new TesteTexRender());
//this.setScreen(new TesteSheet());
//this.setScreen(new TesteSheetSparow());
//this.setScreen(new TesteAnimator());
//this.setScreen(new TesteFonts());
//this.setScreen(new TestParticles());
this.setScreen(new TestParticles2());



		

}




	
 
}