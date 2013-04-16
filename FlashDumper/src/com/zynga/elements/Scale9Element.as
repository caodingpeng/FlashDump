/**
 *
 * User: cdingpeng
 * Date: 12/4/12
 * Time: 1:51 PM
 *
 */
package com.zynga.elements {
    import flash.display.DisplayObject;
    import flash.display.DisplayObject;
    import flash.display.MovieClip;
    import flash.geom.Rectangle;

    public class Scale9Element extends ElementBase {

        /**
         * The grid representing the nine sub-regions of the texture.
         */
        public var gridX:int;
        public var gridY:int;
        public var gridWidth:int;
        public var gridHeight:int;

        public var image:String;

        public function Scale9Element(obj:DisplayObject) {
            super(obj);

            this.exportData();
        }

        override public function get type():String
        {
            return 'scale9';
        }

        override protected function beforeValidate():void
        {
            delete this.validators[ElementBase.VALIDATE_SCALE];
        }

        protected function exportData():void
        {
            var mc:MovieClip=this._obj as MovieClip;
            if(mc.numChildren!=2)
            {
                this.throwError("Not validate scale9 format");
            }
            var grid:DisplayObject=mc.getChildAt(1);

            this.gridX=grid.x;
            this.gridY=grid.y;
            this.gridWidth=grid.width;
            this.gridHeight=grid.height;

            mc.visible=false;

            this.image=this.getSaveImageName();
            Helper.drawBitmapAndSave(mc.getChildAt(0), this.image+'.png',this.isSaveImageShared());
        }
    }
}
