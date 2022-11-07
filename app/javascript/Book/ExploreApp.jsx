import React, { useState, useEffect } from 'react'
import { QueryClient, QueryClientProvider, useQuery } from 'react-query'
import BookList from 'Book/BookList'
import TagList from 'Tag/TagList'

// React Query (fetch/cache)
const queryClient = new QueryClient()

const ExploreApp = (props) => {
	return 	<QueryClientProvider client={queryClient}>
				<div className="container">
					{
						window.location.href.indexOf('tags') == -1
						? <BookList />
						: <TagList />
					}
				</div>
			</QueryClientProvider>
}

export default ExploreApp
