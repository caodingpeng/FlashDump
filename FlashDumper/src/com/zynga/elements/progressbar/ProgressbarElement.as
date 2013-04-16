/**
 * 
 */
package com.zynga.elements.progressbar
{
	import com.zynga.component.Console;
	import com.zynga.elements.ElementBase;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	
	import spark.components.mediaClasses.VolumeBar;
	import spark.primitives.Rect;
	
	public class ProgressbarElement extends ElementBase
	{
		public static const VERTICAL:String="vertical";
		public static const HORIZONTAL:String="horizontal";
		
		public var background_image:String;
		public var background_part_one_size:int;
		public var background_part_two_size:int;
		public var fill_image:String;
		public var fill_part_one_size:int;
		public var fill_part_two_size:int;
		public var top_padding:int;
		public var bottom_padding:int;
		public var left_padding:int;
		public var right_padding:int;
		
		public var background_width:int;
		public var background_height:int;
		public var fill_width:int;
		public var fill_height:int;
		
		public var orientation:String;
		public function ProgressbarElement(obj:DisplayObject)
		{
			super(obj);
		}
		
		override public function get type():String
		{
			return "progress_bar";
		}
		
		protected function exportImages(obj:DisplayObject):void
		{
			
		}
		
		protected function analyzeBar(mc:MovieClip):Array
		{
			return null;
		}
		
		protected function exportBackground(mc:MovieClip,childrens:Array,filename:String):void
		{
			var a:DisplayObject=childrens[0];
			var b:DisplayObject=childrens[1];
			var c:DisplayObject=childrens[2];
			
			var rect:Rectangle;
			if(this.orientation==ProgressbarElement.HORIZONTAL)
			{
				b.scaleX=b.scaleX * 0.1;
				
				b.x=a.x+a.width;
				c.x=b.x+b.width;
				rect=new Rectangle(0,0,a.width+b.width+c.width,a.height);
			}else{

				b.scaleY=b.scaleY*0.1;
				
				b.y=a.y+a.height;
				c.y=b.y+b.height;
				
				rect=new Rectangle(0,0,a.width,a.height+b.height+c.height);
			}
			
			Helper.drawBitmapAndSave(mc,filename,this.isSaveImageShared(),Helper.instance().currentBasePath,rect);
		}
	}
}