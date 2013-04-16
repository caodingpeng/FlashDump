package com.zynga.modal
{
	import com.zynga.elements.ButtonElement;
	import com.zynga.elements.CheckElement;
	import com.zynga.elements.ElementBase;
	import com.zynga.elements.ImageElement;
	import com.zynga.elements.LabelElement;
	import com.zynga.elements.MovieClipElement;
	import com.zynga.elements.PlaceHolderElement;
	import com.zynga.elements.RadioElement;
	import com.zynga.elements.RadioGroupElement;
	import com.zynga.elements.Scale3Element;
	import com.zynga.elements.Scale9Element;
	import com.zynga.elements.SpriteElement;
	import com.zynga.elements.ZButtonElement;
	import com.zynga.elements.progressbar.ProgressbarElement;
	
	import flash.display.Sprite;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.text.engine.TextElement;
	import flash.utils.Dictionary;
	
	import mx.utils.StringUtil;

	public class CodeGenerater
	{
		public static var typeMapper:Object=  {
            button:"Button",
            image:"Image",
            text:'AlignedTextLabel',
            progress_bar:"ProgressBar",
            movie:"MovieClip",
            sprite:'Sprite',
            placeholder:'LayoutSprite',
            check:'Check',
            radio:'Radio',
            radiogroup:'ToggleGroup',
            scale3:'Scale3Image',
            scale9:'Scale9Image',
			zbtn:'Button'
        };
		
		public var source:String="";
		
		private var variables:String="";
		private var events:String="";
		private var methords:String="";
		private var inits:String="";
		
		private var root:SpriteElement;
		public function CodeGenerater(root:SpriteElement,jsonName:String)
		{
			this.root=root;
			
			this.genCodes(root);
			
			var fs:FileStream=new FileStream();
			fs.open(File.applicationDirectory.resolvePath("code-template.txt"),FileMode.READ);
			var tpl:String=fs.readUTFBytes(fs.bytesAvailable);
			fs.close();
			
			this.source=tpl.replace("${window_file}",jsonName);
			this.source=this.source.replace("${variables}",this.variables);
			this.source=this.source.replace("${inits}",this.inits);
			this.source=this.source.replace("${events}",this.events);
			this.source=this.source.replace("${methords}",this.methords);
		}
		
		private function genCodes(root:ElementBase):void
		{
			if(root is SpriteElement)
			{
				var sp:SpriteElement=root as SpriteElement;
				for(var i:int=0;i<sp.children.length;i++)
				{
					genCodes(sp.children[i] as ElementBase);
				}
			}
			
			if(root!=this.root)
			{
				handleElement(root);
			}
		}
		
		private function handleElement(root:ElementBase):void
		{
			if(hasName(root)==false)
			{
				return;
			}
			switch(root.type)
			{
				case 'button':
					handleButton(root as ButtonElement);
					break;
				case 'image':
					this.handleImage(root as ImageElement);
					break;
				case 'text':
					this.handleText(root as LabelElement);
					break;
				case 'movie':
					this.handleMovie(root as MovieClipElement);
					break;
				case 'progress_bar':
					this.handleProgressbar(root as ProgressbarElement);
					break;
				case 'sprite':
					this.handleSprite(root as SpriteElement);
					break;
				case 'placeholder':
					this.handlePlaceHolder(root as PlaceHolderElement);
					break;
				case 'check':
					this.handleCheck(root as CheckElement);
					break;
				case 'radio':
					this.handleRadio(root as RadioElement);
					break;
				case 'radiogroup':
					this.handleRadioGroup(root as RadioGroupElement);
					break;
				case 'scale3':
					this.handleGrid3(root as Scale3Element);
					break;
                case 'scale9':
                    this.handleGrid9(root as Scale9Element);
                    break;
				case 'zbtn':
					this.handleZyngaButton(root as ZButtonElement);
					break;
				default:
					break;
			}
		}
		
		private function handleButton(btn:ButtonElement):void
		{
			var codeType:String=typeMapper[btn.type];
			this.addVariable(btn.name,codeType);
			
			events+=StringUtil.substitute("\t\t\tthis.{0}.addEventListener(starling.events.Event.TRIGGERED,{1}_onRelease);\n",btn.name,btn.name);
			
			this.methords+=StringUtil.substitute("\t\tprotected function {0}_onRelease(event:Event):void\n" +
				"\t\t{\n" +
				"\t\t\ttrace(\"{2}_onRelease\");\n" +
				"\t\t}\n",btn.name,codeType,btn.name);
		}
		private function handleCheck(check:CheckElement):void
		{
			var codeType:String=typeMapper[check.type];
			this.addVariable(check.name,codeType);
		}
		
		private function handleRadio(radio:RadioElement):void
		{
			var codeType:String=typeMapper[radio.type];
			this.addVariable(radio.name,codeType);
			
			if(radio.radioGroup)
			{
				this.inits+=StringUtil.substitute("\t\t\tthis.{0}.toggleGroup=this.{1};\n",radio.name,radio.radioGroup);
			}
		}
		
		private function handleGrid3(scale3:Scale3Element):void
		{
			var codeType:String=typeMapper[scale3.type];
			this.addVariable(scale3.name,codeType);
		}

        private function handleGrid9(scale9:Scale9Element):void
        {
            var codeType:String=typeMapper[scale9.type];
            this.addVariable(scale9.name,codeType);
        }
		
		private function handleZyngaButton(zbtn:ZButtonElement):void
		{
			var codeType:String=typeMapper[zbtn.type];
			this.addVariable(zbtn.name,codeType);
		}

		private function handleRadioGroup(radioGroup:RadioGroupElement):void
		{
			var codeType:String=typeMapper[radioGroup.type];
			this.addVariable(radioGroup.name,codeType);
		}
		private function handleImage(img:ImageElement):void
		{
			var codeType:String=typeMapper[img.type];
			this.addVariable(img.name,codeType);
		}
		
		private function handleText(txt:LabelElement):void
		{
			var codeType:String=typeMapper[txt.type];
			this.addVariable(txt.name,codeType);
		}
		
		private function handleMovie(movie:MovieClipElement):void
		{
			var codeType:String=typeMapper[movie.type];
			this.addVariable(movie.name,codeType);
		}
		
		private function handleProgressbar(progressbar:ProgressbarElement):void
		{
			var codeType:String=typeMapper[progressbar.type];
			this.addVariable(progressbar.name,codeType);
		}
		
		private function handleSprite(sprite:SpriteElement):void
		{
			var codeType:String=typeMapper[sprite.type];
			this.addVariable(sprite.name,codeType);
		}
		
		private function handlePlaceHolder(holder:PlaceHolderElement):void
		{
			var codeType:String=typeMapper[holder.type];
			this.addVariable(holder.name,codeType);
		}
		
		private function hasName(root:ElementBase):Boolean
		{
			if(root.name && root.name.length>0)
			{
				return true;
			}
			
			return false;
		}
		private function addVariable(name:String, type:String):void
		{
			this.variables+=StringUtil.substitute("\t\tpublic var {0}:{1};\n",name,type);
		}
	}
}