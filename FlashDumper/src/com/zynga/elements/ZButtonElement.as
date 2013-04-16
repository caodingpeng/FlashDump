/**
 *
 * User: cdingpeng
 * Date: 12/10/12
 * Time: 4:41 PM
 *
 */
package com.zynga.elements {
    import flash.display.DisplayObject;
    import flash.display.MovieClip;
    import flash.geom.Point;
    
    import mx.controls.Button;
    import mx.controls.Image;
    import mx.utils.StringUtil;

    public class ZButtonElement extends ElementBase{
		
		public var icon:ImageElement;
		public var label1:LabelElement;
		public var label2:LabelElement;
		public var btn:ButtonElement;
		
        public function ZButtonElement(obj:DisplayObject) {
            super(obj);
			
			this.export();
        }
		
		override public function get type():String
		{
			return 'zbtn';
		}
		
		override public function export():void
		{
			var mc:MovieClip=this._obj as MovieClip;
			if(mc.numChildren!=4)
			{
				this.throwError(StringUtil.substitute("SubElements count should be 4, {0} found.",mc.numChildren));
			}
			
			var children:Array=[];
			
			for(var i:int=1;i<mc.numChildren;i++)
			{
				children.push(mc.getChildAt(i));
			}
			children.sortOn('x',Array.NUMERIC);
			
			this.btn=new ButtonElement(mc.getChildAt(0));
			
			this.label1=new LabelElement(children[0]);
			
			this.label2=new LabelElement(children[2]);
			
			this.icon=new ImageElement(children[1]);
		}
    }
}
