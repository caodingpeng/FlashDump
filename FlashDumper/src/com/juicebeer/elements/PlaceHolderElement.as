package com.juicebeer.elements
{
	import flash.display.DisplayObject;
	
	public class PlaceHolderElement extends ElementBase
	{
		public function PlaceHolderElement(obj:DisplayObject)
		{
			
			super(obj);
			
		}

        override protected function beforeValidate():void
        {
            delete this.validators[ElementBase.VALIDATE_SCALE]
        }
        
		override public function get type():String
		{
			return "placeholder";
		}
	}
}