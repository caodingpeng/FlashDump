package com.zynga.elements
{
	
	import flash.display.DisplayObject;
	
	public class RadioElement extends CheckElement
	{
		public var radioGroup:String;
		public function RadioElement(obj:DisplayObject)
		{
			super(obj);
		}
		
		override public function get type():String
		{
			return "radio";
		}

	}
}