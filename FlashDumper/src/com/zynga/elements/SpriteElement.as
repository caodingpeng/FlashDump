package com.zynga.elements
{	
	import com.zynga.component.Console;
    import com.zynga.elements.Scale9Element;
    import com.zynga.elements.progressbar.HorizonalProgressbarElement;
	import com.zynga.elements.progressbar.VerticalProgressbarElement;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.filesystem.File;
	
	public class SpriteElement extends ElementBase
	{
		
		public var children:Array;
		public function SpriteElement(obj:DisplayObject)
		{
			super(obj);
			
			children=new Array();
			this.exportChilds();
		}
		
		override public function get type():String
		{
			return "sprite";
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
						case "txt":
							var label:LabelElement=new LabelElement(child);
							this.children.push(label);x
							break;
						case 'img':
							var img:ImageElement=new ImageElement(child);
							this.children.push(img);
							break;
						case 'btn':
							var btn:ButtonElement=new ButtonElement(child);
							this.children.push(btn);
							break;
						case 'sprite':
							var sprite:SpriteElement=new SpriteElement(child);
							this.children.push(sprite);
							break;
						case 'mc':
							var mce:MovieClipElement=new MovieClipElement(child);
							this.children.push(mce);
							break;
						case 'progress':
						case 'progressh':
							Console.log("progressh");
							var hpb:HorizonalProgressbarElement=new HorizonalProgressbarElement(child);
							this.children.push(hpb);
							break;
						case 'progressv':
							Console.log("progressv");
							var vpb:VerticalProgressbarElement=new VerticalProgressbarElement(child);
							this.children.push(vpb);
							break;
						case 'holder':
							var phe:PlaceHolderElement=new PlaceHolderElement(child);
							this.children.push(phe);
							break;
						case 'check':
							var check:CheckElement=new CheckElement(child);
							this.children.push(check);
							break;
						case 'radio':
							var radio:RadioElement=new RadioElement(child);
							this.children.push(radio);
							break;
						case 'radiogroup':
							var radiogroup:RadioGroupElement=new RadioGroupElement(child);
							this.children.push(radiogroup);
							this.children=this.children.concat(radiogroup.getAllRadios());
							break;
						case 'scale3v':
							var scale3v:Scale3Element=new Scale3Element(child,Scale3Element.DIRECTION_VERTICAL);
							this.children.push(scale3v);
							break;
						case 'scale3h':
							var scale3h:Scale3Element=new Scale3Element(child,Scale3Element.DIRECTION_HORIZONTAL);
							this.children.push(scale3h);
							break;
                        case 'scale9':
                            var scale9:Scale9Element=new Scale9Element(child);
                            this.children.push(scale9);
                            break;
                        case 'zbtn':
                            var zbtn:ZButtonElement=new ZButtonElement(child);
                            this.children.push(zbtn);
                            break;
                        case "ignore":
                            break;
						default:
							Console.warning('unknow type '+child.toString()+ ",export as image");
							var dimg:ImageElement=new ImageElement(child);
							this.children.push(dimg);
							break;
					}
				}
			}
		}
	}
}