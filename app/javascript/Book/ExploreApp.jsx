import React from 'react'
import { QueryClient, QueryClientProvider, useQuery } from 'react-query'

// React Query (fetch/cache)
const queryClient = new QueryClient()

const ExploreApp = (props) => {
	return 	<QueryClientProvider client={queryClient}>
				<div className="container">
					<BookList />
				</div>
			</QueryClientProvider>
}

export default ExploreApp


const BookList = (props) => {
	const { isLoading, isError, data, error } = useQuery(['books'], async () => {
		const response = await fetch('/books.json')

		if (!response.ok) {
			throw new Error('Network response was not ok')
		}

		return response.json()
	})

	return <div>
		{
			data && data.map( book => (
				<div className="border-bottom">
					 <h5 className="mb-0">{book.title}</h5>
					 <p className="text-sm">{book.authors}</p>
					 <p className="text-sm">{book.genres.split('|').map(g => <span className="badge text-bg-primary me-1">{g}</span>)}</p>
				</div>
			))
		}
	</div>
}
