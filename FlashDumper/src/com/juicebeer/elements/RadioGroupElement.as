package com.juicebeer.elements
{
	import com.juicebeer.component.Console;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	
	public class RadioGroupElement extends ElementBase
	{
		private var _children:Array;
		public function RadioGroupElement(obj:DisplayObject)
		{
			super(obj);
			
			_children=new Array();
			this.exportChilds();
		}
		
		override public function get type():String
		{
			return "radiogroup";
		}
		
		public function getAllRadios():Array
		{
			return this._children;
		}
		
		private function exportChilds():void
		{
			var mc:MovieClip=this._obj as MovieClip;
			
			for(var i:int=0;i<mc.numChildren;i++)
			{
				var child:DisplayObject=mc.getChildAt(i);
				if(child.name)
				{
					var type:String=child.name.substring(0,child.name.indexOf('_'));
					
					switch(type)
					{
						case 'radio':
							var radio:RadioElement=new RadioElement(child);
							
							//ajust x y
							radio.x=radio.x+this.x;
							radio.y=radio.y+this.y;
							radio.radioGroup=this.name;
							
							_children.push(radio);
							break;
						default:
							Console.error("Radiogroup can only contain radio");
							break;
					}
				}else{
					Console.error("radio has no name");
				}
			}
		}
		
	}
}