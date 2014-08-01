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
import mmvc.api.IViewContainer;
import msignal.Signal;
import rottensearch.core.View;
import rottensearch.view.ButtonView;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import openfl.text.TextFieldType;

enum SearchBoxViewAction
{
	Search(term:String);
}

/**
	The view encompassing all components that make up a search box
	including input text area and search button.
**/
class SearchBoxView extends View implements mmvc.api.IViewContainer
{
	public var viewAdded:Dynamic -> Void;
	public var viewRemoved:Dynamic -> Void;

	public var actioned(default, null):Signal1<SearchBoxViewAction>;

	var inputText:TextField;
	var searchButton:ButtonView;

	public function new()
	{
		super();

		actioned = new Signal1(SearchBoxViewAction);

		sprite.x = 20;
		sprite.y = 20;

		// Create and setup the back of the input area
		var back = new Sprite();
		back.y = 25;
		back.graphics.beginFill(0xFFFFFF, 1);
		back.graphics.lineStyle(1, 0xDDDDDD, 1);
		back.graphics.drawRect(0, 0, 500, 40);
		sprite.addChild(back);

		// Create and setup the label text
		var text = new TextField();
		text.width = back.width;
		text.height = 20;
		text.selectable = false;
		sprite.addChild(text);

		var format = new TextFormat("arial", 16, 0xAAAAAA);
		text.defaultTextFormat = format;

		text.text = "Enter search below:";

		// Create and setup input text field
		inputText = new TextField();
		inputText.y = back.y + back.height * 0.5 - 14;
		inputText.x = 5;
		inputText.width = back.width;
		inputText.height = 28;
		inputText.type = TextFieldType.INPUT;
		sprite.addChild(inputText);

		format.size = 20;
		format.color = 0x666666;
		inputText.defaultTextFormat = format;

		inputText.text = "Toy Story";

		// Set the input text in focus
		openfl.Lib.current.stage.focus = inputText;
		inputText.setSelection(0, inputText.text.length);
	}

	function searchButtonActioned(action:ButtonViewAction)
	{
		switch (action)
		{
			case Clicked:
			{
				actioned.dispatch(Search(inputText.text));
			}

			default:
			{

			}
		}
	}

	public function isAdded(view)
	{
		return true;
	}

	override function remove()
	{
		if (searchButton != null)
			searchButton.actioned.remove(searchButtonActioned);
	}

	public function createViews()
	{
		searchButton = new ButtonView();
		searchButton.actioned.add(searchButtonActioned);
		addChild(searchButton);
	}	
}