package
{
	import com.greensock.TweenNano;
	import com.greensock.easing.Quint;
	import com.model.ImageSingleton;
	import com.visual.ImageHolder;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.utils.setInterval;
	
	public class FlashGallery extends Sprite
	{
		private var _model:ImageSingleton;
		private var _rotateTime:Number = 1;
		private var _counter:int = 0;
		
		private var _pointer:int = 0;
		
		private var _xmlURL:String;
		
		//Negetive is closer to us, and Positive Z is further away
		private var _zPoints:Array =
		[
			150, 100, 0, 100, 150
		];
		
		private var _yPoints:Array = 
		[
			-200, -10, 150, 400, 600
		];
		
		private var _alphaPoints:Array = 
		[
			.1, .5, 1, .5, .1	
		];
		
		private var _arrayOfPics:Array = [];
		private var _arrayOfAllPics:Array = [];
		
		private var _holder:Sprite;
		
		public function FlashGallery()
		{
			stage.scaleMode = StageScaleMode.SHOW_ALL;
			stage.align = StageAlign.TOP;    
			
			_holder = new Sprite();
			_holder.y = 100;
			_holder.alpha = 0;
			this.addChild(_holder);
			
			if (this.loaderInfo.parameters.xmlURL) {
				_xmlURL = this.loaderInfo.parameters.xmlURL;
			} else {
				_xmlURL = "http://media.socialvi.be/m/svnetwork/homepage.xml";
			}
			
			_model = ImageSingleton.instance;
			_model.loadXML(_xmlURL);
			_model.addEventListener(ImageSingleton.DATA_READY, onDataReady);
		}
		
		private function onDataReady(e:Event):void
		{
			_model.removeEventListener(ImageSingleton.DATA_READY, onDataReady);
			
			for (var i:int = 0; i < 5; i++) {
				_counter++;
				var temp:ImageHolder = new ImageHolder(_model.ImageList[i]);
				temp.addEventListener(ImageHolder.READY, onImageReady);
				temp.filters = [new GlowFilter(0x000000, 1, 6, 6, 1, 1)];
				_arrayOfPics.push(temp);
			}
			
			_pointer = 5;
		}
		
		private function onImageReady(e:Event):void
		{
			e.currentTarget.removeEventListener(ImageHolder.READY, onImageReady);
			_counter--;
			if (_counter <= 0) {
				prePopulate();
				setInterval(rotate, 3000);
			}
		}
		
		private function prePopulate():void
		{
			var previous:DisplayObject;
			
			for (var i:int = 0; i < _arrayOfPics.length; i++) {
				
				var temp:ImageHolder = _arrayOfPics[i];
				temp.y = _yPoints[i];
				temp.z = _zPoints[i];
				temp.alpha = _alphaPoints[i];
				_holder.addChildAt(temp, i);
				
				if (i < 3) {
					_holder.addChild(temp);
					temp.depth = i+5;
				} else if (i ==3) {
					_holder.addChild(temp);
					temp.depth = 2;
				} else {
					_holder.addChild(temp);
					temp.depth = 0;
				}
				
				previous = temp;
			}
			
			TweenNano.to(_holder, 1, {alpha:1});
			
			sortDisplayList();
		}
		
		private function rotate():void
		{
			var temp:ImageHolder = _arrayOfPics[0];
			TweenNano.to(temp, _rotateTime, {y:_yPoints[1], z:_zPoints[1], ease:Quint.easeOut, alpha:_alphaPoints[1]});
			
			for (var i:int = 1; i < _arrayOfPics.length-1; i++) {
				temp = _arrayOfPics[i];
				TweenNano.to(temp, _rotateTime, {y:_yPoints[i+1], z:_zPoints[i+1], ease:Quint.easeOut, alpha:_alphaPoints[i+1]});
			}
			
			temp = _arrayOfPics[_arrayOfPics.length-1];
			TweenNano.to(temp, _rotateTime, {alpha:0, y: 500, z:200, ease:Quint.easeOut, onComplete:onRoateComplete});
			
			for (i = 0; i < _arrayOfPics.length; i++) {
				temp = _arrayOfPics[i];
				if (i == 1) {
					temp.depth = 30;
				} else if (i < 3) {
					temp.depth = i+5;
				} else if (i == 3) {
					temp.depth = 2;
				} else {
					temp.depth = 0;
				}
			}
			
			sortDisplayList();
		}
		
		private function onRoateComplete():void
		{
			//Push everythiing over one
			_holder.removeChild(_arrayOfPics.pop());
			if (_pointer > _model.ImageList.length-1) {
				_pointer = 0;
			}
			var temp:ImageHolder =new ImageHolder(_model.ImageList[_pointer++]) 
			temp.filters = [new GlowFilter(0x000000, 1, 6, 6, 1, 1)];
			_arrayOfPics.push(temp);
			_holder.addChild(_arrayOfPics[_arrayOfPics.length-1]);
			
			_arrayOfPics.unshift(_arrayOfPics.pop());
			
			//depth managment
			for (var i:int = 0; i < _arrayOfPics.length; i++) {
				temp = _arrayOfPics[i];
				if (i < 3) {
					temp.depth = i+5;
				} else if (i == 3) {
					temp.depth = 2;
				} else {
					temp.depth = 0;
				}
			}
			
			sortDisplayList();
			
			temp = _arrayOfPics[0];
			temp.alpha = 0;
			temp.y = 200;
			temp.z = 150;
			TweenNano.to(temp, _rotateTime, {alpha:_alphaPoints[0], y:_yPoints[0], z:_zPoints[0], ease:Quint.easeOut});
		}
		
		protected function sortDisplayList():void
		{
			// sort my children based on their depths
			// (bubble sort)
			// I should improce this!
			var len:uint = _holder.numChildren;
			for (var i:int=0; i < len-1; i++)
			{
				for (var j:int=i+1; j < len; j++)
				{
					if ( ImageHolder( _holder.getChildAt(i) ).depth > ImageHolder( _holder.getChildAt(j) ).depth )
						_holder.swapChildrenAt( i, j );
				}
			}
		}
	}
}