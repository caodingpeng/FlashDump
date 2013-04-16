package com.juicebeer.elements.progressbar
{
	import com.juicebeer.component.Console;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	
	public class HorizonalProgressbarElement extends ProgressbarElement
	{	
		public function HorizonalProgressbarElement(obj:DisplayObject)
		{
			super(obj);
			
			this.orientation=ProgressbarElement.HORIZONTAL;
			
			this.exportImages(obj);
		}
		
		override protected function exportImages(obj:DisplayObject):void
		{
			var mc:MovieClip=obj as MovieClip;
			
			var back:MovieClip=mc.getChildAt(0) as MovieClip;
			if(back==null)
			{
				Console.error("progressbar background not found");
				return;
			}
			this.background_image=this.getSaveImageName()+'_back';
			
			var backChilds:Array=this.analyzeBar(back);
			var back_left:DisplayObject=backChilds[0];
			if(back_left==null)
			{
				this.throwError("progressbar background left-part not found");
				return;
			}
			
			this.background_height=back_left.height;
			this.background_part_one_size=back_left.width;
			
			var back_right:DisplayObject=backChilds[2];
			if(back_right==null)
			{
				this.throwError("progressbar background right-part not found");
				
				return;
			}
			this.background_part_two_size=back_right.width;
			
			var back_middle:DisplayObject=backChilds[1];
			if(back_middle==null)
			{
				this.throwError("progressbar background middle-part not found");
				return;
			}
			this.background_width=back_left.width+back_middle.width+back_right.width;
			
			var front:MovieClip=mc.getChildAt(1) as MovieClip;
			if(front==null)
			{
				Console.error("progressbar foreground not found");
				return;
			}
			
			this.exportBackground(back,backChilds,this.background_image+'.png');
			
			this.fill_image=this.getSaveImageName()+'_front';
			Helper.drawBitmapAndSave(front,this.fill_image+'.png');
			
			var frontChilds:Array=this.analyzeBar(front);
			var front_left:DisplayObject=frontChilds[0];
			if(front_left==null)
			{
				Console.error("progressbar foreground left-part not found");
				return;
			}
			
			var front_middle:DisplayObject=frontChilds[1];
			if(front_middle==null)
			{
				Console.error("progressbar foreground middle-part not found");
				return;
			}
			
			var front_right:DisplayObject=frontChilds[2];
			if(front_right==null)
			{
				Console.error("progressbar foreground right-part not found");
				return;
			}
			
			this.fill_part_one_size=front_left.width;
			this.fill_part_two_size=front_right.width;
			
			this.fill_width=front_left.width+front_right.width;
			this.fill_height=front_left.height;
			
			this.top_padding=this.bottom_padding=front.y;
			this.left_padding=this.right_padding=front.x;
		}
		
		override protected function analyzeBar(mc:MovieClip):Array
		{
			var array:Array=new Array();
			for(var i:int=0;i<mc.numChildren;i++)
			{
				array.push(mc.getChildAt(i));
			}
			
			//sort
			array.sortOn('x',Array.NUMERIC);
			return array;
		}
	}
}