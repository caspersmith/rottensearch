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

package rottensearch.command;

import rottensearch.model.MovieListModel;
import rottensearch.model.MovieItemModel;
import rottensearch.api.RottenTomatoes;
import mmvc.impl.Command;

/**
	Responds to and acts on the SearchSignal which is dispatched by the
	SearchBoxViewMediator. Updates the MovieListModel with any new movie
	data that is found in the search.
**/
class SearchCommand extends mmvc.impl.Command
{
	@inject public var searchTerm:String;
	@inject public var rottenTomatoes:RottenTomatoes;
	@inject public var movieListModel:MovieListModel;

	override public function execute():Void
	{
		rottenTomatoes.searchSignal.addOnce(onSearch);
		rottenTomatoes.search(searchTerm, 10);
	}

	function onSearch(action:RottenTomatoesAction)
	{
		switch (action)
		{
			case SearchComplete(results):
				processResults(cast results);

			case SearchFailed(error):
				trace(error);
		}
	}

	function processResults(results:Dynamic)
	{
		var numMoviesFound:Int = results.total;

		movieListModel.clear();

		if (numMoviesFound > 0) 
		{
			var moviesToAdd = new Array<MovieItemModel>();

			for (movie in cast(results.movies, Array<Dynamic>)) 
			{
				var newMovie = new MovieItemModel();
				newMovie.id = movie.id;
				newMovie.title = movie.title;
				newMovie.year = movie.year;
				newMovie.synopsis = movie.synopsis;
				newMovie.criticsRating = movie.ratings.critics_score;
				newMovie.audienceRating = movie.ratings.audience_score;
				newMovie.imageUrl = StringTools.replace(
					movie.posters.detailed, "_tmb.jpg", "_det.jpg");
				newMovie.websiteUrl = movie.links.alternate;

				moviesToAdd.push(newMovie);
			}

			movieListModel.addAll(moviesToAdd);
		}
	}
}