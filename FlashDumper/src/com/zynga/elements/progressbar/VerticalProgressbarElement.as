package com.zynga.elements.progressbar
{
	import com.zynga.component.Console;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	
	public class VerticalProgressbarElement extends ProgressbarElement
	{	
		public function VerticalProgressbarElement(obj:DisplayObject)
		{
			super(obj);
			
			this.orientation=ProgressbarElement.VERTICAL;
			
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
			var back_up:DisplayObject=backChilds[0];
			var back_middle:DisplayObject=backChilds[1];
			var back_down:DisplayObject=backChilds[2];
			
			if(back_up==null)
			{
				Console.error("progressbar background up-part not found");
				return;
			}
			
			if(back_middle==null)
			{
				Console.error("progressbar background middle-part not found");
				return;
			}
			
			if(back_down==null)
			{
				Console.error("progressbar background down-part not found");
				return;
			}
			
			this.background_height=back_up.height+back_middle.height+back_down.height;
			this.background_width=back_up.width;
			
			this.background_part_one_size=back_up.height;
			this.background_part_two_size=back_down.height;
			
			this.exportBackground(back,backChilds,this.background_image+'.png');
			
			var front:MovieClip=mc.getChildAt(1) as MovieClip;
			if(front==null)
			{
				Console.error("progressbar foreground not found");
				return;
			}
			
			this.fill_image=this.getSaveImageName()+'_front';
			Helper.drawBitmapAndSave(front,this.fill_image+'.png',this.isSaveImageShared());
			
			var frontChilds:Array=this.analyzeBar(front);
			var front_top:DisplayObject=frontChilds[0];
			if(front_top==null)
			{
				Console.error("progressbar foreground top-part not found");
				return;
			}
			
			var front_middle:DisplayObject=frontChilds[1];
			if(front_middle==null)
			{
				Console.error("progressbar foreground middle-part not found");
				return;
			}
			
			var front_down:DisplayObject=frontChilds[2];
			if(front_down==null)
			{
				Console.error("progressbar foreground dow=-part not found");
				return;
			}
			
			this.fill_part_one_size=front_top.height;
			this.fill_part_two_size=front_down.height;
			
			this.fill_height=front_top.height+front_down.height;
			this.fill_width=front_top.width;
			
			this.top_padding=this.bottom_padding=front.y;
			this.left_padding=this.right_padding=front.x;
		}
		
		override protected function analyzeBar(mc:MovieClip):Array
		{
			var array:Array=new Array();
			Console.log("progressbar has "+mc.numChildren+" children.");
			for(var i:int=0;i<mc.numChildren;i++)
			{
				array.push(mc.getChildAt(i));
			}
			
			//sort
			array.sortOn('y',Array.NUMERIC);
			return array;
		}
	}
}