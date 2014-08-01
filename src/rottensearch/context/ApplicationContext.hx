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

package rottensearch.context;

import rottensearch.view.*;
import rottensearch.mediator.*;
import rottensearch.command.*;
import rottensearch.signal.*;
import rottensearch.model.*;
import mmvc.api.IViewContainer;
import rottensearch.api.RottenTomatoes;

/**
	The main application context manages injection mappings.
**/
class ApplicationContext extends mmvc.impl.Context
{
	public function new(?contextView:IViewContainer=null)
	{
		super(contextView);
	}

	override public function startup()
	{
		// Map the RottenTomatoes class as a singleton
		injector.mapSingleton(RottenTomatoes);

		// Model singleton mappings
		injector.mapSingleton(MovieListModel);

		// Model class mappings
		injector.mapClass(MovieItemModel, MovieItemModel);

		// Map Signals -> Commands
		commandMap.mapSignalClass(SearchSignal, SearchCommand);

		// Map the views to their mediators		
		mediatorMap.mapView(SearchBoxView, SearchBoxViewMediator);
		mediatorMap.mapView(MovieListView, MovieListViewMediator);

		// Wiring for main application module
		mediatorMap.mapView(ApplicationView, ApplicationViewMediator);
	}

	override public function shutdown()
	{
		
	}
}