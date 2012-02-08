package junlas.flash {
    import flash.events.*;
    import flash.display.*;

    public class ExtButton extends MovieClip {

        private var _enable:Boolean;

        public function ExtButton(){
            this.stop();
            this.buttonMode = true;
            this.mouseChildren = false;
            _enable = true;
            initEvent();
        }
        public function set enable(_arg1:Boolean):void{
            _enable = _arg1;
            if (((_enable) && ((this.currentFrame > 3)))){
                this.gotoAndStop((this.currentFrame - 3));
            };
            if (((!(_enable)) && ((this.currentFrame <= 3)))){
                this.gotoAndStop((this.currentFrame + 3));
            };
        }
        private function mouseUpHandler(_arg1:MouseEvent):void{
            if (_enable){
                this.gotoAndStop(2);
            } else {
                this.gotoAndStop(5);
            };
        }
        private function rollOverHandler(_arg1:MouseEvent):void{
            if (_enable){
                this.gotoAndStop(2);
            } else {
                this.gotoAndStop(5);
            };
        }
        private function mouseDownHandler(_arg1:MouseEvent):void{
            if (_enable){
                this.gotoAndStop(3);
            } else {
                this.gotoAndStop(6);
            };
        }
        private function initEvent():void{
            this.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
            this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
            this.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
            this.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
            this.addEventListener(Event.REMOVED_FROM_STAGE, removeFromStageHandler);
        }
        private function delEvent():void{
            this.removeEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
            this.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
            this.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
            this.removeEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
            this.removeEventListener(Event.REMOVED_FROM_STAGE, removeFromStageHandler);
        }
        public function get enable():Boolean{
            return (_enable);
        }
        private function rollOutHandler(_arg1:MouseEvent):void{
            if (_enable){
                this.gotoAndStop(1);
            } else {
                this.gotoAndStop(4);
            };
        }
        private function removeFromStageHandler(_arg1:Event):void{
            delEvent();
        }

    }
}
