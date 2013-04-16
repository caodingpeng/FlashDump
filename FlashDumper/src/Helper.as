package
{
	
	import com.juicebeer.component.Console;
	
	import fl.text.TLFTextField;
	
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.IOErrorEvent;
	import flash.events.NativeProcessExitEvent;
	import flash.events.ProgressEvent;
import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.text.TextField;
	import flash.text.engine.TextLine;
	import flash.utils.ByteArray;
	
	import mx.graphics.codec.PNGEncoder;

	import spark.components.TextArea;

	public class Helper
	{
		public var swf:DisplayObjectContainer;
		public var logArea:TextArea;

        public static var needExportATFiOS:Boolean;
        public static var needExportATFAndroid:Boolean;
		
		public static var basePath:String="export/";
        public static var sheetConfig:Object=loadJsonFile('sheet_config.json');
		public var currentBasePath:String;
        public var currentUIName:String;
        public static var findShareFile:Boolean=false;
		
		public var errorDisplayObjectSnapshot:BitmapData;
		
		private static var _instance:Helper;
		public static function instance():Helper
		{
			if(_instance==null)
			{
				_instance = new Helper();
			}
			
			return _instance;
		}

        public static function reloadSheetConfig():void
        {
            sheetConfig = loadJsonFile('sheet_config.json');
        }

        public static function loadJsonFile(path:String):Object
        {
            var file:File=File.userDirectory.resolvePath(path);
            if(file.exists)
            {
                var fs:FileStream=new FileStream();
                fs.open(file, FileMode.READ);
                var jsonStr:String=fs.readUTFBytes(fs.bytesAvailable);
                var jsonObj:Object=JSON.parse(jsonStr);

                fs.close();

                return jsonObj;
            }

            return null;
        }
		
		public static function dump(mc:DisplayObject):void
		{
			if(mc is DisplayObjectContainer)
			{
				var doc:DisplayObjectContainer=mc as DisplayObjectContainer;
				for(var i:int=0;i<doc.numChildren;i++)
				{
					Console.log('container '+doc.name + '  '+ doc.toString());
					dump(doc.getChildAt(i));
				}
			}else{
				Console.log(mc.name + '  '+ mc.toString());
			}
		}
		public static function numberEqual(num1:Number,num2:Number):Boolean
		{
			if(Math.abs(num1-num2)<0.001)
			{
				return true;
			}else{
				return false;
			}
		}
		public static function platform():String
		{
			return Capabilities.os.toLowerCase().substr(0,3);
		}
		
		public static function nativeCall(args:Vector.<String>=null,onOutput:Function=null,onError:Function=null,onExit:Function=null):void
		{	
			var npsi:NativeProcessStartupInfo=new NativeProcessStartupInfo();
			npsi.executable=File.applicationDirectory.resolvePath("/bin/bash");
			npsi.arguments=args;
			
			var process:NativeProcess=new NativeProcess();
			
			if(onOutput!=null)
			{
				process.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA,onOutput);
			}
			if(onError!=null)
			{
				process.addEventListener(ProgressEvent.STANDARD_ERROR_DATA,onError);
			}
			if(onExit!=null)
			{
				process.addEventListener(NativeProcessExitEvent.EXIT, onExit);
			}
			
			process.addEventListener(ProgressEvent.STANDARD_ERROR_DATA, onErrorData);
			process.addEventListener(IOErrorEvent.STANDARD_OUTPUT_IO_ERROR, onIOError);
			process.addEventListener(IOErrorEvent.STANDARD_ERROR_IO_ERROR, onIOError);
			
			process.start(npsi);
		}
		
		public static function onErrorData(event:ProgressEvent):void
		{
			var process:NativeProcess=event.target as NativeProcess;
			Console.error(process.standardError.readUTFBytes(process.standardError.bytesAvailable)); 
		}
		public static function onIOError(event:IOErrorEvent):void
		{
			Console.error(event.toString());
		}
		
		public static function hideLabels(obj:DisplayObject):void
		{	
			var tlf:TLFTextField;
			if((obj is TLFTextField) || (obj is TextLine) || (obj is TextField))
			{
				//tlf=obj as TLFTextField;
				obj.alpha=0;
				obj.visible=false;
				
				//textfield maybe wrapped with movieclip
				if(obj.parent && obj.parent.numChildren==1)
				{
					obj.parent.visible=false;
				}
				
				return;
			}else if(obj is DisplayObjectContainer)
			{
				var doc:DisplayObjectContainer= obj as DisplayObjectContainer;
				for(var i:int=0;i< doc.numChildren;i++)
				{
					hideLabels(doc.getChildAt(i));
				}
			}
		}
		
		public static function drawBitmapRecursive(root:DisplayObject,mc:DisplayObject,bitmapData:BitmapData):BitmapData
		{
			if(mc is DisplayObjectContainer && mc.visible)
			{
				var doc:DisplayObjectContainer=mc as DisplayObjectContainer;
				for(var i:int=0;i<doc.numChildren;i++)
				{
					drawBitmapRecursive(root,doc.getChildAt(i),bitmapData);
				}
			}else{
				
				if(mc.visible==false)
				{
					return bitmapData;
				}
				var offset:Rectangle=mc.getBounds(mc);
				var rect:Rectangle=mc.getBounds(root);
				//point=root.globalToLocal(point);
				var matrix:Matrix=new Matrix();
				
				var scaleX:Number=mc.scaleX;
				var scaleY:Number=mc.scaleY;
				
				var ds:DisplayObject=mc;
				ds.cacheAsBitmap=true;
				
				while(ds!=root){
					ds=ds.parent;
					scaleX*=ds.scaleX;
					scaleY*=ds.scaleY;
				}
				
				//Console.log(mc.name+" scaleX:"+mc.scaleX+" scaleY:"+mc.scaleY+" "+scaleX+" offsetX"+offset.x+" offsetY:"+offset.y+" ");
				//matrix.scale(mc.scaleX,mc.scaleY);
				//matrix.translate(point.x-(offset.x*mc.scaleX),point.y-(offset.y*mc.scaleY));
				
				matrix.scale(scaleX,scaleY);
				matrix.translate(rect.x-(offset.x*scaleX),rect.y-(offset.y*scaleY));
				
				bitmapData.draw(mc,matrix,null,null,null,true);
			}
			
			return bitmapData;
		}
		public static function drawBitmap(mc:DisplayObject):BitmapData
		{
			var width:int=mc.width >= 1?mc.width:1;
			var height:int=mc.height >= 1 ? mc.height:1;
			var bitmapData:BitmapData=new BitmapData(width,height,true,0x00FFFFFF);
			bitmapData.draw(mc,null,null,null,null,true);
			return bitmapData;
		}
		public static function drawBitmapAndSave(mc:DisplayObject,fileName:String,isImageShared:Boolean=false,path:String=null,rect:Rectangle=null):void
		{
			//var bitmapData:BitmapData=drawBitmap(mc);
			var bitmapData:BitmapData;
			if(rect==null)
			{
				bitmapData=new BitmapData(mc.width,mc.height,true,0x00FFFFFF);
			}else{
				bitmapData=new BitmapData(rect.width,rect.height,true,0x00FFFFFF);
			}

			//drawBitmapRecursive(mc,mc,bitmapData);
			
			bitmapData.draw(mc,null,null,null,null,true);
			
			var encoder:PNGEncoder=new PNGEncoder();
			var byteArray:ByteArray = encoder.encode(bitmapData);
			
			if(path==null)
			{
				path=Helper.instance().currentBasePath;
			}
			if(isImageShared)
			{
                //if is not share library images,
                // return directly because sharelin has already has this image
                if(Helper.instance().currentUIName.indexOf('share') != 0)
                {
                    findShareFile=true;
                    return;
                }

                //wo don't need to export shared images since all share images
                //has exported to a shared texture
				path+='/share';
			}
			Helper.saveBinaryToFile(byteArray,fileName,path);
		}
		
		public static function saveStringToFile(str:String,fileName:String,path:String=null):void
		{
			var bytearray:ByteArray=new ByteArray();
			bytearray.writeUTFBytes(str);
			
			Helper.saveBinaryToFile(bytearray,fileName,path);
		}
		public static function saveBinaryToFile(byteArray:ByteArray,fileName:String,path:String=null):void
		{
			if(path==null)
			{
				path=Helper.instance().currentBasePath;
			}
			
			var fpath:File=File.userDirectory.resolvePath(path);
			if(fpath.exists==false)
			{
				fpath.createDirectory();
			}
			
			var fs:FileStream=new FileStream();
			var file:File=File.userDirectory.resolvePath(path+'/'+fileName);
			fs.open(file,FileMode.WRITE);
			fs.writeBytes(byteArray);
			fs.close();
		}
		
	}
}