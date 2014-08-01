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

package rottensearch.api;

import msignal.Signal;
import mloader.JsonLoader;
import mloader.Loader;
import mcore.util.Strings;
import mcore.exception.Exception;

enum RottenTomatoesAction
{
	SearchComplete(results:Dynamic);
	SearchFailed(error:LoaderErrorType);
}

/**
	Implementation of the RottenTomatoes API allowing for searching keywords
	and parsing the returned JSON data.
**/
class RottenTomatoes
{
	public static inline var API_KEY:String = "7gch9yq6hf8syux4fmv2jtrn";

	static inline var BASE_URL:String = 
		"http://api.rottentomatoes.com/api/public/v1.0/movies.json";

	static inline var QUERY_URL:String = 
		BASE_URL + "?apikey={0}&q={1}&page_limit={2}";

	public var searchSignal(default, null):Signal1<RottenTomatoesAction>;

	var loader:JsonLoader<Dynamic>;

	public function new()
	{
		searchSignal = new Signal1(RottenTomatoesAction);
	}

	/**
		Takes a search term and parameters for the search and initiates a
		loader request to obtain the JSON data.

		@param term The term to search for
		@param pageLimit The maximum number of items to show on each page
		@param pageNumber The page number you want to load
	**/
	public function search(term:String, pageLimit:Int=1, pageNumber:Int=1)
	{
		var url:String = 
			Strings.substitute(QUERY_URL, [API_KEY, cleanTerm(term), pageLimit, pageNumber]);
		loader = new JsonLoader<Dynamic>(url);
		loader.loaded.add(onLoaded);
		loader.load();
	}

	function onLoaded(event:LoaderEvent<Dynamic>)
	{
		switch (event.type)
		{
			case Complete:
			{
				searchSignal.dispatch(SearchComplete(event.target.content));
			}

			case Fail(error):
			{
				searchSignal.dispatch(SearchFailed(error));
			}

			default:
			{
			}
		}
	}

	/**
		Cleans a search term string by removing excess whitespace and converting
		whitespace characters to +
	**/
	function cleanTerm(term:String):String
	{
		return StringTools.replace(StringTools.trim(term), " ", "+");
	}
}