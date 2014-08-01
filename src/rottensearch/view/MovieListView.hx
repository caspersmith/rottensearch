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

import mmvc.api.IViewContainer;
import rottensearch.model.MovieItemModel;
import rottensearch.view.MovieItemView;
import rottensearch.core.DataView;
import openfl.Lib;

class MovieListView extends DataView<MovieItemView> implements mmvc.api.IViewContainer
{
	public var viewAdded:Dynamic -> Void;
	public var viewRemoved:Dynamic -> Void;

	public function new()
	{
		super();

		// Offset sprite position
		sprite.x = 0;
		sprite.y = 160;

		// Draw background
		sprite.graphics.lineStyle(2, 0xDDDDDD, 1);
		sprite.graphics.beginFill(0x000000, 1);
		sprite.graphics.drawRect(0, 0, Lib.current.stage.stageWidth, 540);
	}

	public function isAdded(view:Dynamic):Bool
	{
		return true;
	}

	public function addMovieView(movieModel:MovieItemModel) {
		var movieView = 
			new MovieItemView(movieModel);
		addChild(movieView);

		movieView.sprite.x = 20 + (500 + 20) * (children.length - 1);
		movieView.sprite.y = 20;
	}
}