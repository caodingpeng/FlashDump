package com.zynga.view
{
	import mx.core.IToolTip;
	
	import spark.components.Image;
	
	public class ImageToolTip extends Image implements IToolTip
	{
		[Bindable]
		public var data:Object;
		public function ImageToolTip()
		{
			super();
		}
		
		public function get text():String
		{
			return " ";
		}
		
		public function set text(value:String):void
		{
		}
	}
}