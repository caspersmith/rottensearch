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

package rottensearch.core;

import openfl.display.Sprite;
import msignal.Signal;

/**
	Cross platform View class using the Sprite view from Openfl.
**/
class View
{
	/**
		Event types dispatched when view is added/removed
	**/
	inline public static var ADDED:String = "added";
	inline public static var REMOVED:String = "removed";

	public var parent(default, null):View;
	public var signal(default, null):Signal2<String, View>;

	var sprite:Sprite;
	var children:Array<View>;

	public function new()
	{
		children = [];
		signal = new Signal2<String, View>();
		sprite = new Sprite();
	}

	/**
		Dispatches a view event via the signal
		@param event string event type
		@param view originating view object
	**/
	public function dispatch(event:String, view:View)
	{
		if (view == null) 
			view = this;
		signal.dispatch(event, view);
	}

	/**
		Adds a child view to the display heirachy.
		
		Dispatches an ADDED event on completion.

		@param view child to add
	**/
	public function addChild(view:View)
	{
		view.signal.add(this.dispatch);
		view.parent = this;

		children.push(view);

		sprite.addChild(view.sprite);

		dispatch(ADDED, view);
	}

	/**
		Removes an existing child view from the display heirachy.
		Dispatches a REMOVED event on completion.
		@param view child to remove
	**/
	public function removeChild(view:View)
	{
		var removed = children.remove(view);

		if (removed)
		{
			view.signal.remove(this.dispatch);
			view.remove();

			sprite.removeChild(view.sprite);

			dispatch(REMOVED, view);
		}
	}

	public function removeAllChildViews()
	{
		for (child in children.concat([]))
		{
			removeChild(child);
		}
	}

	function remove()
	{
		parent = null;
	}

	function update()
	{
		// Handle updating of view in override
	}
}
