package junlas.bitmap {
    import flash.geom.*;
    import flash.display.*;

    public class BmpTool {

        private static var bitmapData:BitmapData;
        private static var rectangle:Rectangle;
        private static var matrix:Matrix = new Matrix();

        public function BmpTool(){
            super();
            this.initBmpTool();
        }
        public static function cutBmp(_mc:DisplayObject, _bmpDataWidth:int, _bmpDataHeight:int, _cutStartX:int, _cutStartY:int, _cutBmpWidth:int, _cutBmpHeight:int):BitmapData{
            matrix.tx = -(_cutStartX);
            matrix.ty = -(_cutStartY);
            rectangle = new Rectangle(0, 0, _cutBmpWidth, _cutBmpHeight);
            bitmapData = new BitmapData(_bmpDataWidth, _bmpDataHeight, true, 0);
            bitmapData.draw(_mc, matrix, null, null, rectangle, true);
            return (bitmapData);
        }

        private function initBmpTool():void{
        }

    }
}