package com.zynga.elements
{
	import com.zynga.component.Console;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	
	public class Scale3Element extends ElementBase
	{
		public var direction:String;
		public var image:String;
		
		public var firstRegionSize:int;
		public var secondRegionSize:int;
		
		public static const DIRECTION_HORIZONTAL:String="horizontal";
		public static const DIRECTION_VERTICAL:String="vertical";
		
		public function Scale3Element(obj:DisplayObject,direction:String)
		{
			super(obj);
			
			this.direction=direction;
			
			this.export();
        }

        override protected function beforeValidate():void
        {
            delete this.validators[ElementBase.VALIDATE_SCALE];
        }
		
		override public function get type():String
		{
			return 'scale3';
		}
		
		override public function export():void
		{
			var obj:DisplayObject=this._obj;
			
			this.image=this.getSaveImageName();
			Helper.drawBitmapAndSave(obj,this.image+'.png',this.isSaveImageShared());
			
			var childrens:Array;
			if(this.direction==DIRECTION_HORIZONTAL)
			{
				childrens=this.sortChildren(obj as MovieClip,'x');
				
				this.firstRegionSize=childrens[0].width;
				this.secondRegionSize=childrens[1].width;
			}else{
				childrens=this.sortChildren(obj as MovieClip,'y');
				this.firstRegionSize=childrens[0].height;
				this.secondRegionSize=childrens[0].height;
			}
		}
		
		private function sortChildren(mc:MovieClip,soryKey:String):Array
		{
			var array:Array=new Array();
			for(var i:int=0;i<mc.numChildren;i++)
			{
				array.push(mc.getChildAt(i));
			}
			
			//sort
			array.sortOn(soryKey,Array.NUMERIC);
			return array;
		}
	}
}