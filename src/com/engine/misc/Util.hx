package com.engine.misc;


import com.engine.render.Texture;
import com.engine.render.Clip;
import openfl.Assets;

import flash.Lib;
import flash.geom.Matrix;
import flash.geom.Matrix3D;
import flash.display.Bitmap;
import flash.display.BitmapData;

import flash.display.Bitmap;
import flash.utils.ByteArray;
import flash.display.BitmapData;
import flash.geom.Point;

#if neko
import sys.io.File;
import sys.io.FileOutput;
#end


/**
 * ...
 * @author djoker
 */
 class Util
 
 {
public static var ALIGN_LEFT:Int = 0;
public static var ALIGN_RIGHT:Int = 1;
public static var ALIGN_CENTER:Int = 2;
public static var point:Point = new Point();

		 static public var DEG:Float = -180 / Math.PI;
		 static public  var  RAD:Float = Math.PI / -180;
		 static public var EPSILON:Float = 0.00000001;
		 
public static inline function getTime():Int
{
	return Lib.getTimer();
}


public static inline function randf(max:Float, min:Float ):Float
{	
     return Math.random() * (max - min) + min;
}
public static inline function randi(max:Int, min:Int ):Int
{
	return Std.int(Math.random() * (max - min) + min);
     
}

public static inline function WithinEpsilon(a:Float, b:Float):Bool {
        var num:Float = a - b;
        return -1.401298E-45 <= num && num <= 1.401298E-45;
    }
public static inline function getColorValue(color:Int):Float
	{
		var h:Int = (color >> 16) & 0xFF;
		var s:Int = (color >> 8) & 0xFF;
		var v:Int = color & 0xFF;

		return Std.int(Math.max(h, Math.max(s, v))) / 255;
	}
public static inline function deg2rad(deg:Float):Float
    {
        return deg / 180.0 * Math.PI;   
    }
public static inline function rad2deg(rad:Float):Float
    {
        return rad / Math.PI * 180.0;            
    }

public static inline function convertTo3D(matrix:Matrix,mat:Matrix3D )
        {
            
			
         
            mat.rawData[0] = matrix.a;
            mat.rawData[1] = matrix.b;
            mat.rawData[4] = matrix.c;
            mat.rawData[5] = matrix.d;
            mat.rawData[12] = matrix.tx;
            mat.rawData[13] = matrix.ty;
            
            
        
		}

	
public static inline function deepCopy<T>( arr : Array<T> ) : Array<T>
     {
         var r = new Array<T>();
         for( i in 0...arr.length )
             r.push(copy(arr[i]));
         return r;
     }

public static inline function copy<T>( value : Dynamic) : T {
         if( Std.is( value, Array ) )
             return cast deepCopy( value );
         else
             return value;
     }
public static inline function getExponantOfTwo(value:Int, max:Int):Int {
        var count:Int = 1;

        do {
            count *= 2;
        } while (count < value);

        if (count > max)
            count = max;

        return count;
    }
	
public static inline function getNextPowerOfTwo(number:Int):Int
    {
        if (number > 0 && (number & (number - 1)) == 0) // see: http://goo.gl/D9kPj
            return number;
        else
        {
            var result:Int = 1;
            while (result < number) result <<= 1;
            return result;
        }
    }
	
		
public static inline function getScaled(source:BitmapData, newWidth:Int, newHeight:Int):BitmapData 
	{
		var m:flash.geom.Matrix = new flash.geom.Matrix();
		m.scale(newWidth / source.width, newHeight / source.height);
	
		var bmp:BitmapData = new BitmapData(newWidth, newHeight, true,0);
	
		bmp.draw(source, m);
		return bmp;
	}
	
public static inline function flipBitmapData(original:BitmapData, axis:String = "y"):BitmapData
{
     var flipped:BitmapData = new BitmapData(original.width, original.height, true, 0);
     var matrix:Matrix;
     if(axis == "x"){
          matrix = new Matrix( -1, 0, 0, 1, original.width, 0);
     } else {
          matrix = new Matrix( 1, 0, 0, -1, 0, original.height);
     }
     flipped.draw(original, matrix, null, null, null, true);
     return flipped;
}
public static inline function setBitmapDataCK(original:String, color:Int):BitmapData
{

         var image:BitmapData = getBitmap(original);
		 replaseColorBitmapData(image, color, 0);
		 return image;
}
public static inline function convertImageCK(original:String,savefile:String, color:Int)
{

         var image:BitmapData = getBitmap(original);
		 replaseColorBitmapData(image, color, 0);
		 saveBitmapData(image, savefile);
}
public static inline function removeColorBitmapData(original:BitmapData,color:Int)
{
 if (original == null)
 {
	 throw("Bitmap is NULL dum ass");
 }
for(x in 0...original.width)
{
    for(y in 0...original.height)
    {
		
        if(original.getPixel(x,y) == color)
        {
            
            original.setPixel32(x, y, 0xFF000000);
        }
    }
	
}
}
public static inline function replaseColorBitmapData(original:BitmapData,src:Int,dst:Int)
{
 
for(x in 0...original.width)
{
    for(y in 0...original.height)
    {
		
        if(original.getPixel(x,y) == src)
        {
             original.setPixel32(x, y, dst);
        }
    }
	
}
}
public static inline function getBitmap( filename:String):BitmapData
{
	      return  Assets.getBitmapData(filename);
}
public static inline function saveBitmapData(data:BitmapData,filename:String)
{
#if neko
  var b:ByteArray = data.encode("png");
  var f:FileOutput = File.write(filename);
  f.writeString(b.toString());
  f.close();
#end
}
public static inline function skew(matrix:Matrix, skewX:Float, skewY:Float)
        {
            var sinX:Float = Math.sin(skewX);
            var cosX:Float = Math.cos(skewX);
            var sinY:Float = Math.sin(skewY);
            var cosY:Float = Math.cos(skewY);
           
            setTo(matrix,matrix.a  * cosY - matrix.b  * sinX,
                         matrix.a  * sinY + matrix.b  * cosX,
                         matrix.c  * cosY - matrix.d  * sinX,
                         matrix.c  * sinY + matrix.d  * cosX,
                         matrix.tx * cosY - matrix.ty * sinX,
                         matrix.tx * sinY + matrix.ty * cosX);
        }
public static inline function setTo (matrix:Matrix, a:Float, b:Float, c:Float, d:Float, tx:Float, ty:Float):Void 
   {
		
		matrix.a = a;
		matrix.b = b;
		matrix.c = c;
		matrix.d = d;
		matrix.tx = tx;
		matrix.ty = ty;
		
	}
	
public static inline function fillMatrix3DArrayTo(mat:Matrix3D,array:Array<Float>) 
	{
		for (index in 0...16) 
		{
		
         //   mat.rawData[index] = array[index];
        }
	}
public static inline function createOrtho(x0:Float, x1:Float,  y0:Float, y1:Float, zNear:Float, zFar:Float) :Matrix3D
   {
      var sx = 1.0 / (x1 - x0);
      var sy = 1.0 / (y1 - y0);
      var sz = 1.0 / (zFar - zNear);

      return new Matrix3D([
         2.0*sx,       0,          0,                 0,
         0,            2.0*sy,     0,                 0,
         0,            0,          -2.0*sz,           0,
         - (x0+x1)*sx, - (y0+y1)*sy, - (zNear+zFar)*sz,  1,
      ]);
   }
public static inline function setMatrixOrtho(mat:Matrix3D,x0:Float, x1:Float,  y0:Float, y1:Float, zNear:Float, zFar:Float) 
   {
      var sx = 1.0 / (x1 - x0);
      var sy = 1.0 / (y1 - y0);
      var sz = 1.0 / (zFar - zNear);

      fillMatrix3DArrayTo(mat,[
         2.0*sx,       0,          0,                 0,
         0,            2.0*sy,     0,                 0,
         0,            0,          -2.0*sz,           0,
         - (x0+x1)*sx, - (y0+y1)*sy, - (zNear+zFar)*sz,  1,
      ]);
   }
	
public static inline function set2Dtransformation(mat:Matrix3D,x:Float, y:Float, scale:Float = 1, rotation:Float = 0) 
   {
      var theta = rotation * Math.PI / 180.0;
      var c = Math.cos(theta);
      var s = Math.sin(theta);
/*
	 fillMatrix3DArrayTo(mat,[
        c*scale,  -s*scale, 0,  0,
        s*scale,  c*scale , 0,  0,
        0,        0,        1,  0,
        x,        y,        0,  1
      ]);
	  */
   }
	
public static inline function createMtrix2D(x:Float, y:Float, scale:Float = 1, rotation:Float = 0):Matrix3D 
   {
      var theta = rotation * Math.PI / 180.0;
      var c = Math.cos(theta);
      var s = Math.sin(theta);

	  var mat:Matrix3D = new Matrix3D([
        c*scale,  -s*scale, 0,  0,
        s*scale,  c*scale, 0,  0,
        0,        0,        1,  0,
       x,        y,        0,  1
      ]);/*
	  return Matrix.FromArray([
        c*scale,  -s*scale, 0,  0,
        s*scale,  c*scale, 0,  0,
        0,        0,        1,  0,
       x,        y,        0,  1
      ]);
	  */
	  return mat;
   }

public static inline function createClipSheets( img:Texture,frameWidth:Int, frameHeight:Int):Array<Clip>
	{
		if (img == null) return null;
	    var keyFrames:Array<Clip> = [];
		var columns:Int =Std.int( img.width  / frameWidth );
		var rows:Int    =Std.int( img.height / frameHeight ); 
	    for ( y in 0...rows)
	    {
		 for (x in 0...columns)
		 {
		  var rect:Clip = new Clip(x * frameWidth, y * frameHeight, frameWidth, frameHeight, 0, 0);
	      keyFrames.push(rect);	
		}
	}
	return keyFrames;
	}
public static inline function createClipSheetsEx( img:Texture,countx:Int,county:Int):Array<Clip>
	{
		if (img == null) return null;
	    var keyFrames:Array<Clip> = [];
		var frameWidth:Int  = Std.int(img.width  / countx);
		var frameHeight:Int = Std.int(img.height / county);
		var columns:Int =Std.int( img.width  / frameWidth );
		var rows:Int    =Std.int( img.height / frameHeight ); 

	for ( y in 0...rows)
	{
		for (x in 0...columns)
		{
		var rect:Clip = new Clip(x * frameWidth, y * frameHeight, frameWidth, frameHeight, 0, 0);
	   keyFrames.push(rect);	
		}
	}
	return keyFrames;
	}
	
public static inline function createClipSheetsBorder( img:Texture,frameWidth:Int, frameHeight:Int,margin:Int,spacing:Int):Array<Clip>
	{
		if (img == null) return null;
	    var keyFrames:Array<Clip> = [];
		var columns:Int =Std.int( img.width  / frameWidth );
		var rows:Int    = Std.int( img.height / frameHeight ); 
		var count = (columns * rows);
		for (num in 0...count)
		{
			
			var rect:Clip=new  Clip(
			margin + (frameWidth  + spacing) * num % columns,
			margin + (frameHeight + spacing) * Std.int(num / columns),
			frameWidth, frameHeight);
			keyFrames.push(rect);
		}
     return keyFrames;
	}
	
public static inline function anglerad(x1:Float, y1:Float, x2:Float, y2:Float):Float
		{
			return Math.atan2(y2 - y1, x2 - x1) ;
	
		}
		
public static inline function VectorAngle(a:Point, b:Point): Float
{
return 	anglerad(a.x, a.y, b.x, b.y);
}
public static inline function VectorAnglTan(a:Point): Float
{
return Math.atan2(a.y,a.x);
}

public static inline function VectorNormalize( v: Point) :Point
{
 return VectorDivS(v,VectorMagnitude(v));
}
public static inline function VectorMagnitude(v: Point):Float
        {return Math.sqrt((v.x*v.x) + (v.y*v.y));}
   
public static inline function VectorDivS(v:Point, s: Float):Point
{

  point.x = v.x/s;
  point.y = v.y / s;
  return point;
}


public static inline function VectorScale( v: Point, Scalar: Float):Point
{
  v.x = v.x * Scalar;
  v.y = v.y * Scalar;
  return v;
}
public static inline function VectorIncrement( a:Point,b:Point):Point
{
  a.x = a.x + b.x;
  a.y = a.y + b.y;
  return a;
}

  	public static inline function isValidElement(element:Xml):Bool
	{
		return Std.string(element.nodeType) == "element";
	}
	

}