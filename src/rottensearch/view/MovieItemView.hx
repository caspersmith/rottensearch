/*
Copyright (c) 2012 Massive Interactive

Permission is hereby granted, free of charge, to any person obtaining a copy of 
this software and associated documentation files (the "Software"), to deal in 
the Software without restriction, including without limitation the rights to 
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies 
of the Software, and to permit persons to whom the Software is furnished to do 
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all 
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE 
SOFTWARE.
*/

package rottensearch.view;

import rottensearch.core.View;
import rottensearch.model.MovieItemModel;
import mloader.Loader;
import mloader.ImageLoader;
import mloader.LoadableImage;
import mcore.util.Ints;
import mmvc.api.IViewContainer;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import openfl.text.TextFieldType;

class MovieItemView extends View implements IViewContainer
{
	public static inline var BACK_WIDTH:Int = 500;
	public static inline var BACK_HEIGHT:Int = 500;
	public static inline var IMAGE_WIDTH:Int = 120;
	public static inline var IMAGE_HEIGHT:Int = 180;
	public static inline var MAX_SYNOPSIS_LEN:Int = 700;

	static var tmpBitmapData:BitmapData;

	public var viewAdded:Dynamic -> Void;
	public var viewRemoved:Dynamic -> Void;

	public var model(default, set_model):MovieItemModel;

	var imageLoader:ImageLoader;
	var image:Bitmap;
	var title:TextField;
	var details:TextField;

	public function new(model:MovieItemModel)
	{
		super();

		// Draw background
		sprite.graphics.beginFill(0xCCCCCC, 1);
		sprite.graphics.drawRect(0, 0, BACK_WIDTH, BACK_HEIGHT);

		// Draw title
		title = new TextField();
		title.x = 20 + IMAGE_WIDTH + 20;
		title.y = 20;
		title.width = BACK_WIDTH - (20 + IMAGE_WIDTH + 20 + 20);
		title.height = 150;
		title.selectable = false;
		title.multiline = true;
		title.wordWrap = true;
		sprite.addChild(title);

		var format = new TextFormat("arial", 28, 0x333333);
		title.defaultTextFormat = format;

		// Draw details text
		details = new TextField();
		details.x = 20;
		details.y = 20 + IMAGE_HEIGHT + 20;
		details.width = BACK_WIDTH - (20 + 20);
		details.height = BACK_HEIGHT - 20 - details.y;
		details.selectable = false;
		details.multiline = true;
		details.wordWrap = true;
		sprite.addChild(details);

		var format = new TextFormat("arial", 16, 0x555555);
		details.defaultTextFormat = format;

		// Draw image
		if (tmpBitmapData == null)
			tmpBitmapData = new BitmapData(4, 4, false, 0x000000);

		image = new Bitmap(null);
		image.smoothing = true;
		image.x = 20;
		image.y = 20;
		setImageBitmapData(tmpBitmapData);
		sprite.addChild(image);

		imageLoader = new ImageLoader("");
		imageLoader.loaded.add(imageLoaded);

		// Set the model
		this.model = model;
	}

	function set_model(model:MovieItemModel):MovieItemModel
	{
		if (this.model != model)
		{
			this.model = model;

			if (this.model != null)
			{
				title.text = this.model.title + " (" + this.model.year + ")";
				
				var shortSynopsis = this.model.synopsis; 
				if (shortSynopsis.length > MAX_SYNOPSIS_LEN)
					shortSynopsis = shortSynopsis.substr(0, MAX_SYNOPSIS_LEN) + "...";
				
				details.text =
					"Critics Rating: " + this.model.criticsRating + "%" + "\n" +
					"Audience Rating: " + this.model.audienceRating + "%" + "\n" +
					"\n" + shortSynopsis;
				
				loadImage();
			}
		}
		return this.model;
	}

	function loadImage()
	{
		if (imageLoader != null)
			imageLoader.cancel();

		// Start loading the image
		// setting a new url for the image loader will cancel previous loading
		imageLoader.url = model.imageUrl;
		imageLoader.load();
	}

	function imageLoaded(event:LoaderEvent<LoadableImage>)
	{
		switch (event.type)
		{
			case Fail(error):
			{
				trace(error);
			}

			case Complete:
			{
				setImageBitmapData(event.target.content);
			}

			default:
		}
	}

	function setImageBitmapData(bitmapData:BitmapData)
	{
		image.bitmapData = bitmapData;
		image.width = IMAGE_WIDTH;
		image.height = IMAGE_HEIGHT;
	}

	public function isAdded(view:Dynamic):Bool
	{
		return true;
	}
}