package com.model
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.xml.XMLNode;

	public class ImageSingleton extends EventDispatcher
	{
		public static const DATA_READY:String = "XMLLoaded";
		
		private static var _instance:ImageSingleton;
				
		private static var _imageArray:Array = [
			"http://www.okbilly.com/test/img_01.png",
			"http://www.okbilly.com/test/img_02.png",
			"http://www.okbilly.com/test/img_03.png",
			"http://www.okbilly.com/test/img_04.png",
			"http://www.okbilly.com/test/img_05.png",
			"http://www.okbilly.com/test/img_06.png",
			"http://www.okbilly.com/test/img_07.png",
			"http://www.okbilly.com/test/img_08.png"
		];
		
		private var imageXMLURL:String = "http://www.okbilly.com/test/imagelist.xml";
		
		private var _loader:URLLoader;
		private var _xml:XML;
		
		public function ImageSingleton(prohibit:Prohibitor)
		{
			
		}
		
		public function loadXML(xmlURL:String):void
		{
			_imageArray = [];
			
			imageXMLURL = xmlURL;
			
			_loader = new URLLoader();
			_loader.addEventListener(Event.COMPLETE, onXMLLoaded);
			_loader.load(new URLRequest(imageXMLURL));
		}
		
		private function onXMLLoaded(e:Event):void
		{
			_xml = new XML(_loader.data);
			
			for each (var image:XML in _xml.image) {
				_imageArray.push(image.toString());
			}
			
			this.dispatchEvent(new Event(DATA_READY));
		}
		
		public static function get instance():ImageSingleton
		{
			if (_instance == null) {
				_instance = new ImageSingleton(new Prohibitor);
			}
			return _instance;
		}
		
		public function get ImageList():Array
		{
			return _imageArray;
		}
	}
}

internal class Prohibitor{}