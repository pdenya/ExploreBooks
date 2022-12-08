import React, { useState, useEffect } from 'react'
import { QueryClient, QueryClientProvider, useQuery } from 'react-query'
import BookList from 'Book/BookList'
import TagList from 'Tag/TagList'
import GenreExplorer from 'Genre/GenreExplorer'

// React Query (fetch/cache)
const queryClient = new QueryClient()

const ExploreApp = (props) => {
	return 	<QueryClientProvider client={queryClient}>
				<div className="container">
					<div className="row border p-1 text-center my-4">
						<div className="col"><a href="/books/explore?tags" className="btn btn-primary">Tags</a></div>
						<div className="col"><a href="/books/explore?book_list" className="btn btn-primary">BookList</a></div>
						<div className="col"><a href="/books/explore?genres" className="btn btn-primary">Genres</a></div>
					</div>
					{ window.location.href.indexOf('tags') != -1 && <TagList /> }
					{ window.location.href.indexOf('book_list') != -1 && <BookList /> }
					{ window.location.href.indexOf('genres') != -1 && <GenreExplorer /> }
				</div>
			</QueryClientProvider>
}

export default ExploreApp
