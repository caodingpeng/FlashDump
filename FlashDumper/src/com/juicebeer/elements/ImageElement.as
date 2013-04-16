package com.juicebeer.elements
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;

	public class ImageElement extends ElementBase
	{
		public var image:String;
		public function ImageElement(obj:DisplayObject)
		{
			super(obj);
			this.exportImages();
		}

        override protected function beforeValidate():void
        {
            delete this.validators[ElementBase.VALIDATE_SCALE]
        }
		override public function get type():String
		{
			return "image";
		}
		
		private function exportImages():void
		{
			this.image=this.getSaveImageName();
			this._obj.cacheAsBitmap=true;
			
			Helper.drawBitmapAndSave(this._obj,this.getSaveImageName()+'.png',this.isSaveImageShared());
		}
	}
}