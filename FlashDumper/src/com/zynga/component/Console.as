package com.zynga.component
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import rl.dev.SWFConsole;
	
	public class Console extends Sprite
	{
		private static var COLORS:Array=new Array('A0D0A0','FF7777','FF2222');
		private static var LEVEL_NAMES:Array=new Array('Info','Warn','Error');
		
		public static function clear():void
		{
			SWFConsole.clear();
		}
		
		public static function info(obj:Object):void
		{
			SWFConsole.output(obj.toString());
		}
		
		public static function log(obj:Object):void
		{
			logIt(obj,0);
		}
		
		public static function warning(obj:Object):void
		{
			logIt(obj,1);
		}
		public static function error(obj:Object):void
		{
			logIt(obj,2);
		}
		
		private static function logIt(obj:Object,level:int=0):void
		{
			SWFConsole.output('<font color="#'+COLORS[level]+'">'+LEVEL_NAMES[level]+': '+obj.toString()+'</font>');
		}
	}
}