package com.engine.render;

import openfl.utils.Float32Array;

/**
 * ...
 * @author djoker
 */
class VertexData
{
	    public static var ELEMENTS_PER_VERTEX:Int = 9;
        public static var POSITION_OFFSET:Int = 0;
        public static var TEXCOORD_OFFSET:Int = 3;
		public static var COLOR_OFFSET:Int = 5;
       
   private var mNumVertices:Int;
   private var mRawData:Float32Array;
   
	public function new(capacity:Int) 
	{
		 mRawData = new Float32Array(capacity);
		 this.mNumVertices = capacity;

	}
	     public function getOffset(vertexID:Int):Int
        {
            return vertexID * ELEMENTS_PER_VERTEX;
        }
	       public function setPosition(vertexID:Int, x:Float, y:Float,?z:Float=0):Void
        {
            var offset:Int = getOffset(vertexID) + POSITION_OFFSET;
            mRawData[offset] = x;
            mRawData[offset + 1] = y;
			mRawData[offset + 2] = z;
        }
		public function setColor(vertexID:Int, r:Float,g:Float,b:Float,a:Float):Void
        {   
            var offset:Int = getOffset(vertexID) + COLOR_OFFSET;
            
            mRawData[offset]        = r;
			mRawData[offset+1]        = g;
			mRawData[offset+2]        = b;
			mRawData[offset+3]        = a;
            
        }
		  public function setTexCoords(vertexID:Int, u:Float, v:Float):Void
        {
            var offset:Int = getOffset(vertexID) + TEXCOORD_OFFSET;
            mRawData[offset]   = u;
            mRawData[offset+1] = v;
        }
}