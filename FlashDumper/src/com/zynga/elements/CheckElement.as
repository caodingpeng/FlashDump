package com.zynga.elements
{
	import com.zynga.component.Console;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	
	import mx.utils.StringUtil;
	
	public class CheckElement extends ButtonElement
	{
		public var background_selected_normal:String;
		public var background_selected_pressed:String;
		public function CheckElement(obj:DisplayObject)
		{
			super(obj);
		}
		
		override public function get type():String
		{
			return "check";
		}
		
		override public function export():void
		{
			var mc:MovieClip=this._obj as MovieClip;
			
			Console.log(StringUtil.substitute('exporting {0} normal state',this.type));
			mc.gotoAndStop(1);
			
			var txt:LabelElement=new LabelElement(mc);
			this.font=txt.font;
			this.font_size=txt.font_size;
			this.font_color=txt.font_color;
			this.text=txt.text;
			
			Helper.hideLabels(mc);
			
			var rect:Rectangle=this.getContainerTrueSize(mc);
			
			this.background_normal=this.getSaveImageName() +'_normal';
			Helper.drawBitmapAndSave(mc,this.background_normal+'.png',this.isSaveImageShared(),null,rect);
			
			if(mc.framesLoaded!=4)
			{
				this.throwError("has only {1} frames, need 4 frames");
			}
			
			if(mc.framesLoaded>1)
			{
				Console.log(StringUtil.substitute('exporting {0} pressed state',this.type));
				mc.gotoAndStop(2);
				//this.selectText=new LabelElement(mc);
				Helper.hideLabels(mc);
				
				this.background_pressed=this.getSaveImageName()+'_pressed';
				Helper.drawBitmapAndSave(mc,this.background_pressed+'.png',this.isSaveImageShared(),null,rect);
			}else{
				Console.warning(StringUtil.substitute("{0} only has normal state, be sure it's what you want",this.type));
			}
			
			if(mc.framesLoaded>2)
			{
				Console.log(StringUtil.substitute('exporting {0} selected normal state',this.type));
				mc.gotoAndStop(3);
				//this.selectText=new LabelElement(mc);
				Helper.hideLabels(mc);
				
				this.background_selected_normal=this.getSaveImageName()+'_selected_normal';
				Helper.drawBitmapAndSave(mc,this.background_selected_normal+'.png',this.isSaveImageShared(),null,rect);
			}
			
			if(mc.framesLoaded>3)
			{
				Console.log(StringUtil.substitute('exporting {0} selected pressed state',this.type));
				trace(mc.numChildren);
				//this.selectText=new LabelElement(mc);
				Helper.hideLabels(mc);
				
				this.background_selected_pressed=this.getSaveImageName()+'_selected_pressed';
				Helper.drawBitmapAndSave(mc,this.background_selected_pressed+'.png',this.isSaveImageShared(),null,rect);
			}
			else{
				Console.warning(StringUtil.substitute("{0} only has selected normal state, be sure it's what you want",this.type));
			}
		}
	}
}