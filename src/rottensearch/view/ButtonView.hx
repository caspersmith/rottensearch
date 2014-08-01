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

import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import openfl.events.MouseEvent;
import msignal.Signal;
import rottensearch.core.View;

enum ButtonViewAction
{
	Clicked;
}

/**
	A simple rectangular clickable button
**/
class ButtonView extends View
{
	inline public static var CLICKED = "clicked";

	public var actioned(default, null ):Signal1<ButtonViewAction>;

	public function new()
	{
		super();

		actioned = new Signal1(ButtonViewAction);

		// Offset whole button sprite to correct position
		sprite.y = 80;

		// Draw the back
		var back = new Sprite();
		back.graphics.beginFill(0xC3C3C8, 1);
		back.graphics.drawRect(0, 0, 100, 40);
		sprite.addChild(back);

		// Draw the text
		var text = new TextField();
		text.y = back.height * 0.5 - 10;
		text.width = back.width;
		text.height = 20;
		text.selectable = false;
		sprite.addChild(text);

		var format = new TextFormat("arial", 16, 0xFFFFFF);
		format.align = TextFormatAlign.CENTER;
		text.defaultTextFormat = format;

		text.text = "SEARCH";

		// Add flash/openfl click event
		sprite.addEventListener(MouseEvent.CLICK, onClick);
	}

	override function remove()
	{
		sprite.removeEventListener(MouseEvent.CLICK, onClick);
	}

	function onClick(event:MouseEvent)
	{
		actioned.dispatch(ButtonViewAction.Clicked);
	}
}