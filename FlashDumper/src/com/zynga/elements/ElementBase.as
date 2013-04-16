package com.zynga.elements
{
    import com.zynga.component.Console;
    import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Rectangle;
    import flash.utils.Dictionary;
    import flash.utils.getTimer;
	
	import mx.utils.StringUtil;
	
	import spark.core.SpriteVisualElement;

	public class ElementBase extends Object
	{
        public static var VALIDATE_COORDIDATE:String='validate_coordidate';
        public static var VALIDATE_SCALE:String='validate_scale';
        public static var VALIDATE_FILTERS:String='validate_filters';


		public var x:int;
		public var y:int;
		
		public var width:int;
		public var height:int;
		
		public var scale_x:Number;
		public var scale_y:Number;
		
		public var opacity:Number;
		public var rotation:Number;
		
		//public var type:String;
		public var name:String;
		
		protected var _obj:DisplayObject;
		
		protected var nameParams:Array;

        protected var validators:Object;
		//protected var frameJobQueue:Array;
		private var skipFrames:int=0;
		public function ElementBase(obj:DisplayObject)
		{
			//frameJobQueue=new Array();var c
            this.validators={"validate_coordidate":[],"validate_scale":[],"validate_filters":[]};
			
			this._obj=obj;
			
			this.nameParams=obj.name.split('_');
			
			this.x=obj.x;
			this.y=obj.y;
			
			this.scale_x=obj.scaleX;
			this.scale_y=obj.scaleY;
			
			this.width=obj.width;
			this.height=obj.height;
			
			this.opacity=obj.alpha;
			this.rotation=obj.rotation;
			this.name=this.getVariableName();
			
			Console.log('');
			Console.log('Exporting '+this.type+' with name '+this.getTrueName());

            this.beforeValidate();
			this.validate();
			this.afterValidate();
		}
		
		public function get type():String
		{
			return "";
		}
		public function getVariableName():String
		{
			if(nameParams.length>=2)
			{
				return '_'+nameParams[1];
			}
			return "";
		}
		
		public function getTrueName():String
		{
			if(nameParams.length>=2)
			{
				return nameParams[1];
			}
			return "";
		}
		
		public function getSaveImageName():String
		{
			
			if(isSaveImageShared())
			{
				if(nameParams.length>=4)
				{
					return getFullImgNames(3,this.nameParams);
				}else{
					Console.error('Shared Image has no name, use default name "error"');
					this.throwError("Shared Image has no name");
					return "error_"+getTimer().toString();
				}
			}else{
				if(nameParams.length>=3)
				{
					return getFullImgNames(2,this.nameParams);;
				}else{
					Console.error('Control has no export image name, forgot to use AutoInstanceName script??');
					this.throwError("has no export image name, forgot to use AutoInstanceName script??");
					return "error_"+getTimer().toString();
				}
			}
		}
		
		public function isSaveImageShared():Boolean
		{
			if(nameParams.length>=3 && nameParams[2].toLowerCase()=='share')
			{
				return true;
			}
			
			return false;
		}
		
		/**
		 * Currently we only calculate one layer
		 **/
		public function getContainerTrueSize(mc:DisplayObjectContainer):Rectangle
		{
			var maxBounds:Rectangle = new Rectangle();
			for (var k:uint = 0; k < mc.numChildren; k++)
			{
				var child:DisplayObject=mc.getChildAt(k);
				if(child.visible && child.alpha> 0)
				{
					var tempBounds:Rectangle = child.getBounds(child);
					maxBounds = maxBounds.union(tempBounds); 
				}
			}
			
			return maxBounds;
		}
		
		public function export():void
		{
			
		}
		
//		public function addFrameJob(mc:MovieClip,frame:int,callback:Function,...paramers):void
//		{
//			var job:FrameJob=new FrameJob(mc,frame,callback,paramers);
//			this.frameJobQueue.push(job);
//		}

		
		protected function get chainName():String
		{
			var target:DisplayObject=this._obj;
			var name:String="";
			do{
				name=target.parent.name+" -> "+name;
				target=target.parent;
			}while(target && target.parent && (target.parent.parent is SpriteVisualElement)==false);
			
			return name+this._obj.name;
		}

    protected function beforeValidate():void
    {

    }

    protected function validate():void
    {
        for (var key:String in this.validators)
        {
            var params:Array=this.validators[key];
            var func:Function=this[key] as Function;
            func.apply(null,params);
        }
    }

    protected function afterValidate():void
    {

    }

    /**
     * validators
     * this.validators={validate_coordidate:[],validate_scale:[],validate_filters:[]};
     */

    protected function validate_coordidate():void
    {

        if(this._obj.x<0 || this._obj.y<0)
        {
            this.throwError(StringUtil.substitute("x={0} or y={1} is negative, fix it",this._obj.x,this._obj.y));
        }
    }

    protected  function validate_filters():void
    {
        if(this._obj.filters && this._obj.filters.length>0)
        {
            this.throwError("has filters, remove them");
        }
    }

    protected  function validate_scale():void
    {
        if(Helper.numberEqual(this._obj.scaleX,1)==false || Helper.numberEqual(this._obj.scaleY,1)==false)
        {
            this.throwError("is scaled, current scalex:"+this._obj.scaleX+" scaleY:"+this._obj.scaleY);
        }
    }
		
		protected function throwError(msg:String):void
		{
			//snapshor error target
			Helper.instance().errorDisplayObjectSnapshot=Helper.drawBitmap(this._obj);
			throw new Error(StringUtil.substitute("[x:{0},y:{1}]{2}: {3}",this._obj.x,this._obj.y,this.chainName,msg));
		}
		
		private function getFullImgNames(start:int,array:Array):String
		{
			var name:String="";
			for(var i:int=start;i<array.length;i++)
			{
				name+=array[i]+'_';
			}
			
			return name.substr(0,name.length-1);
		}
		
		protected function doFrameJob():void
		{
			//this._obj.addEventListener(
			//this._obj.addEventListener(Event.ENTER_FRAME,onEnterFrame);
		}
		
//		private function onEnterFrame(event:Event):void
//		{
//			//trace("exit frame");
//			if(this.frameJobQueue.length>0)
//			{
//				var job:FrameJob = this.frameJobQueue[0];
//				if(job.mc.currentFrame==job.frame)
//				{
//					if(this.skipFrames>=3)
//					{
//						trace("children: "+job.mc.numChildren);
//						job.callback.apply(null,job.params);
//					
//						this.frameJobQueue.shift();
//						this.skipFrames=0;
//					}else{
//						trace("skip this frame");
//						this.skipFrames++;
//					}
//				}else{
//					trace("current frame "+job.mc.currentFrame +" goto frame "+job.frame);
//					job.mc.gotoAndStop(job.frame);
//				}
//			}
//		}
	}
}
import flash.display.MovieClip;

class FrameJob
{
	public var mc:MovieClip;
	public var frame:int;
	public var callback:Function;
	public var params:Array;
	public function FrameJob(mc:MovieClip,frame:int,callback:Function,params:Array)
	{
		this.mc=mc;
		this.frame=frame;
		this.callback=callback;
		this.params=params;
	}
}