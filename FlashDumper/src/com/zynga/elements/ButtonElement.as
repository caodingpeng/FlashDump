package com.zynga.elements
{
	import com.zynga.component.Console;
	
	import fl.text.TLFTextField;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.utils.setTimeout;
	
	import mx.utils.StringUtil;
	
	import spark.effects.easing.EaseInOutBase;
	
	public class ButtonElement extends ElementBase
	{
		public var font:String;
		public var font_size:int;
		//public var fontStyle:String;
		public var font_color:int=0;
		public var text:String;
		
		
		public var background_normal:String;
		public var background_pressed:String;
		public var background_disabled:String;
		public function ButtonElement(obj:DisplayObject)
		{
			super(obj);
			
			this.export();
		}
		
		override public function get type():String
		{
			return "button";
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
			this.background_normal=this.getSaveImageName() +'_normal';
			Helper.drawBitmapAndSave(mc,this.background_normal+'.png',this.isSaveImageShared());
			
			if(mc.framesLoaded<2)
			{
				this.throwError("button need at least 2 state,only find "+mc.framesLoaded);
			}
			
			Console.log(StringUtil.substitute('exporting {0} pressed state',this.type));
			mc.gotoAndStop(2);
			Helper.hideLabels(mc);	
			this.background_pressed=this.getSaveImageName()+'_pressed';
			Helper.drawBitmapAndSave(mc,this.background_pressed+'.png',this.isSaveImageShared());
			
			if(mc.framesLoaded >=3)
			{
				Console.log(StringUtil.substitute('exporting {0} disabled state',this.type));
				mc.gotoAndStop(3);
				Helper.hideLabels(mc);	
				this.background_disabled=this.getSaveImageName()+'_disabled';
				Helper.drawBitmapAndSave(mc,this.background_disabled+'.png',this.isSaveImageShared());
			}
		}
	}
}