package com.zynga.elements
{
	import com.hexagonstar.util.debug.Debug;
	import com.zynga.component.Console;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.text.TextField;
	import flash.utils.getQualifiedClassName;
	
	import mx.utils.ObjectUtil;
	import mx.utils.StringUtil;
	
	import fl.text.TLFTextField;
	
	public class LabelElement extends ElementBase
	{
		public var font:String;
		public var font_size:int;
		public var font_color:int=0;
		public var text:String;
		public var alignment:String;
		
		public static var AlignmentMap:Object={start:"left",center:"center",end:"right"};
		public function LabelElement(obj:DisplayObject)
		{
			super(obj);
			
			this.export();
		}
		
		override public function export():void
		{
			var obj:DisplayObject=this._obj;
			
			Console.log("searching label "+obj.toString());
			
			var label:TLFTextField=getLabel(obj) as TLFTextField;
			if(label!=null)
			{
				if(Helper.numberEqual(label.scaleX,1)==false || Helper.numberEqual(label.scaleY,1)==false)
				{
					this.throwError("Label is scaled, current scalex:"+label.scaleX+" scaleY:"+label.scaleY);
				}
				
				this.alignment=AlignmentMap[label.textFlow.hostFormat.textAlign];
				this.font=label.textFlow.hostFormat.fontFamily;
				if(this.font=="Times New Roman")
				{
					var xml:XML=new XML(label.htmlText);
					var target:XML;
					if(xml.BODY.P.FONT[0].@FACE=="Times New Roman")
					{
						target=xml.BODY.P.FONT.FONT[0];
					}else{
						target=xml.BODY.P.FONT[0];
					}
					if(target==null)
					{
						this.throwError("Text font cann't detected");
					}
					var color:String=target.@COLOR;
					this.font_color=int(color.replace("#",'0x'));
					
					this.font_size= target.@SIZE;
					
					this.font=target.@FACE;
				}else{
					this.font_size=label.textFlow.hostFormat.fontSize;
					this.font_color=label.textColor;
				}
				
				if(this.font.indexOf("Myriad")==-1 && this.font.indexOf("Rockwell")==-1 && this.font.indexOf('Monotype ')==-1)
				{
					this.throwError("Only support MyriadPro and Rockwell font, Current font is "+this.font);
					return;
				}
				
				this.text=label.text;
				
				Console.log("label found:");
				if(this.font_size!=0)
				{
					Console.log('text: '+this.text+' font:'+this.font+' font_size:'+this.font_size);
				}else{
					Console.error('tlftextfield must be wrapper with movieclip.');
				}
				
			}else{
				
				if(obj.name.indexOf("txt_")==0)
				{
					this.throwError(" label not found,tlf text must be editable.");
				}else{
					Console.warning('label not found,tlf text must be editable.');
				}
			}
		}
		override public function get type():String
		{
			return "text";
		}
		
		public static function getLabel(obj:DisplayObject):Object
		{
			if(getQualifiedClassName(obj)=='fl.text::TLFTextField')
			{
				return obj ;
			}else if(obj is DisplayObjectContainer)
			{
				var doc:DisplayObjectContainer= obj as DisplayObjectContainer;
				for(var i:int=0;i<doc.numChildren;i++)
				{
					var result:Object=getLabel(doc.getChildAt(i));
					if(result!=null)
					{
						return result;
					}
				}
			}
			
			return null;
		}
		
	}
}