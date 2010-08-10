package com.visual
{
	import com.greensock.TweenNano;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	public class ImageHolder extends Sprite
	{
		public static const READY:String = "ReadyEvent";
		
		private var _loader:Loader;
		
		private var _centerHolder:Sprite;
		
		private var _depth:Number;
		private var _needsSorting:Boolean = false;
		
		private var _imageURL:String;
		
		public function ImageHolder(imageURL:String = "http://www.google.com/intl/en_ALL/images/srpr/logo1w.png")
		{
			super();
			
			_imageURL = imageURL 
			
			_centerHolder = new Sprite();
			this.addChild(_centerHolder);
			
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaded);
			_loader.load(new URLRequest(imageURL), new LoaderContext());
		}
		
		private function onLoaded(e:Event):void
		{
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoaded);
			
			//RESIZE
			//MAXHEIGHT=183;
			var image:Sprite = new Sprite();
			if (_imageURL.toLowerCase().indexOf(".swf") < 0) {
				var ditty:Bitmap =_loader.content as Bitmap 
				image.addChild( ditty);
				ditty.smoothing =true;
				ditty.cacheAsBitmap = true;
			} else {
				image.addChild( _loader.content as MovieClip);
			}
			
			/*
			var ratio:Number = image.width/image.height;
			image.width = 183 * ratio;
			image.height = 183;
			
			if (image.width > 290) {
				ratio = image.height/image.width;
				image.height = 290*ratio;
				image.width = 290;
			}
			*/
			
			//image.x = - (image.width  * image.scaleX)/2;
			//image.y = - (image.height * image.scaleY)/2;
			image.x = - (image.width )/2 - (image.width )/5;
			image.y = - (image.height )/2;
			_centerHolder.addChild(image);
			
			//_centerHolder.x = (image.width * image.scaleX)/2;
			//_centerHolder.y = (image.height * image.scaleY)/2;
			_centerHolder.x = (image.width )/2;
			_centerHolder.y = (image.height )/2;
			
			this.dispatchEvent(new Event(READY));
			
			image.alpha = 0;
			TweenNano.to(image, 1, {alpha: 1});
		}
		
		public function get depth():Number { return _depth; }
		public function set depth(n:Number):void
		{
			_depth = n;
			if(parent is ImageHolder) ImageHolder(parent)._needsSorting = true;
		}
	}
}