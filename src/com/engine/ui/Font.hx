package com.engine.ui;


import com.engine.render.Texture;
import flash.geom.Point;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;

import openfl.Assets;

import com.engine.misc.Util;
import com.engine.render.Clip;
import com.engine.render.SpriteBatch;
import com.engine.game.Game;


/**
 * ...
 * @author djoker
 */
class Font
{
public var align:Int;
public var customSpacingX:Int;
public var customSpacingY:Int;
public var image:Texture;
private var offsetX:Int;
private var offsetY:Int;
private var scale:Float;
private var characterWidth:Int;
private var characterHeight:Int;
private var characterSpacingX:Int;
private var characterSpacingY:Int;
private var characterPerRow:Int;
private var glyphs:Array<Clip>;





public function new(filename:String,?trim:Int):Void
{
align = 0;
customSpacingX = trim;
customSpacingY = 0;

scale = 1;




image = new Texture();
image.load(filename);


characterWidth  =  Std.int( image.width / 16);
characterHeight =  Std.int( image.height / 16);
characterSpacingX = 0;
characterSpacingY = 0;
characterPerRow =  Std.int(image.width / characterWidth);
offsetX = 0;
offsetY = 0;

glyphs = new Array<Clip>();


var currentX:Int = offsetX;
var currentY:Int = offsetY;
var r:Int = 0;
var index:Int = 0;

//for(c in 0...255)
for(c in 30...150)
{
glyphs[index++] = new Clip(currentX, currentY, characterWidth, characterHeight);
r++;
if (r == characterPerRow)
{
r = 0;
currentX = offsetX;
currentY += characterHeight + characterSpacingY;
}
else
{
currentX += characterWidth + characterSpacingX;
}
}

}


public function getTextWidth(caption:String):Int 
	{
		var w:Int = 0;
		var textLength:Int = caption.length;
		for (i in 0...(textLength)) 
		{
        var glyph = glyphs[caption.charCodeAt(i)];
		if (glyph != null) 
			{
				w += glyph.width;
			}
		w = Math.round(w * scale);
		if (textLength > 1)
		{
			w += (textLength - 1) * characterSpacingX;
		}
		}
		return w;
	}

public function print(batch:SpriteBatch,caption:String, x:Float, y:Float,?align:Int=0)
{

	var cx:Int = 0;
    var cy:Int = 0;
	var X:Float = x;
	var Y:Float = y;
	var newLine:Float = characterHeight + characterSpacingY;

	   switch (align) 
       { 
       case 0:
       cx = 0;
       case 1:
       cx = getTextWidth(caption);
       case 2:
       cx = Std.int(getTextWidth(caption) / 2);
       }
	   


  for (c in 0...caption.length)   
   {
    if(caption.charAt(c) == " ")
    {
       X += characterWidth + customSpacingX;
    }
    else
	  if(caption.charAt(c) == "\n")
    {
	   Y += newLine;	
       X = x-characterWidth + customSpacingX;
    } else
      {
        var glyph = glyphs[caption.charCodeAt(c)];
        X += characterWidth + customSpacingX;
        if(glyph!=null) batch.RenderFont(image,(X-cx)-characterWidth, Y,scale, glyph, false, true, 0);
     }
  }
}

  public function dispose()
{
	for (i in 0...glyphs.length)
	{
		glyphs[i] = null;
	}
	glyphs = null;

}
	
}