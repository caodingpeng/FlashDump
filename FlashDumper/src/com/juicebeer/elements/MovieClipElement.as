package com.juicebeer.elements
{
	import com.juicebeer.component.Console;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import mx.utils.StringUtil;
	
	import spark.formatters.NumberFormatter;
	
	public class MovieClipElement extends ElementBase
	{
		public var animation_image:String;
		public var frame_count:int;
		public function MovieClipElement(obj:DisplayObject)
		{
			super(obj);
			this.getTrueSize();
			//this.visitIt(obj);
			this.exportImages();
		}
		
		override public function get type():String
		{
			return "movie";
		}
		
		/**
		 * mc.width return the width of all children's bound width, which includes invisiable objects
		 * such as mask object,
		 * so we should get the real visiable size
		 * 
		 * methord: draw the mc to a bitmap, find each fram's color rectangle and calculate the max size
		 **/
		private function getTrueSize():void
		{
			var mc:MovieClip=this._obj as MovieClip;
			var tempBounds:Rectangle;
			
			var maxBounds:Rectangle = new Rectangle();
			for (var k:uint = 1; k <= mc.totalFrames; k++)
			{
				mc.gotoAndStop(k);
				
				tempBounds = mc.getBounds(mc);
				maxBounds = maxBounds.union(tempBounds); 
				
				if(maxBounds.x<0 || maxBounds.y<0)
				{
					//this.throwError(StringUtil.substitute("frame={0} movie bound rect x={1} or y={2} is negetive",k,maxBounds.x,maxBounds.y));
				}
				//trace(maxBounds.x+" "+maxBounds.y+" "+maxBounds.width+" "+maxBounds.height);
			}
			
			var bitmapData:BitmapData;
			var trueBounds:Rectangle=new Rectangle();
			for(var i:int=1;i<=mc.totalFrames;i++)
			{
				mc.gotoAndStop(i);
				
				bitmapData=new BitmapData(maxBounds.x+maxBounds.width,maxBounds.y+maxBounds.height,true,0);
				
				bitmapData.draw(mc);								              
				tempBounds=bitmapData.getColorBoundsRect(0xFF000000,0x00000000,false);
				trueBounds = trueBounds.union(tempBounds); 
				//trace(i+" "+mc.width+" "+mc.height+" "+tempBounds.x+" "+tempBounds.y+" "+tempBounds.width+" "+tempBounds.height);
				bitmapData.dispose();
			}
			
			this.width=trueBounds.x+trueBounds.width;
			this.height=trueBounds.y+trueBounds.height;
		}
		private function visitIt(mc:DisplayObject):void
		{
			if(mc is DisplayObjectContainer)
			{
				var doc:DisplayObjectContainer=mc as DisplayObjectContainer;
				for(var i:int=0;i<doc.numChildren;i++)
				{
					this.visitIt(doc.getChildAt(i));
				}
			}else{
				Console.log(mc.toString()+ ' scaleX:'+mc.scaleX);
			}
		}
		private function exportImages():void
		{
			var mc:MovieClip=this._obj as MovieClip;
			
			var maxBounds:Rectangle = new Rectangle(0,0,this.width,this.height);
			mc.gotoAndStop(1);
			
			this.frame_count=mc.framesLoaded;
			this.animation_image=this.getSaveImageName()+'_';
			var saveImageName:String=this.getSaveImageName();
			var path:String=Helper.instance().currentBasePath;
			if(this.isSaveImageShared())
			{
				path+='/share';
			}
			path+='/mc_'+saveImageName;
			if(mc.framesLoaded>=100)
			{
				Console.error("MovieClip exceed 99 frames");
			}
			

			for(var i:int=1;i<=mc.totalFrames;i++)
			{
				mc.gotoAndStop(i);
				//trace(i);
				Helper.drawBitmapAndSave(mc,this.animation_image+addLeadingZero(i,2)+'.png',false,path,maxBounds);
			}
		}
		
		private function addLeadingZero(n:Number,maxLength:int):String
		{
			var out:String=n.toString();
			
			for(var i:int=out.length;i<maxLength;i++)
			{
				out='0'+out;
			}
			//trace(out);
			return out;
		}
	}
}