import React, { useState, useEffect } from 'react'
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
		const response = await fetch('/books.json?goodreads_list_id=1')

		if (!response.ok) {
			throw new Error('Network response was not ok')
		}

		return response.json()
	})

	let [genre_counts, setGenreCounts] = useState({})

	useEffect(() => {
		if (data) {
			let genre_count_map = { 'Genres not known': 0 }
			data.forEach(book => {
				book.genre_names && book.genre_names.split('|').map(genre_name => {
					if (!genre_count_map[genre_name]) genre_count_map[genre_name] = 0
					genre_count_map[genre_name] += 1
				})

				if(!book.genre_names) genre_count_map['Genres not known'] += 1
			})

			setGenreCounts(genre_count_map)
		}
	}, [data])

	return <div>
		<p>Books Loaded: { data && data.length }</p>
		<div className="my-2">
			<div className="row">
				{Object.keys(genre_counts).sort().map(genre_name => (
					<div className="col-3" key={genre_name}>{genre_name} <span className="text-secondary">({genre_counts[genre_name]})</span></div>
				))}
			</div>
		</div>
		<hr />
		{ data && data.map( book => (
			<div className="border-bottom" key={book.id}>
				 <h5 className="mb-0">{book.title}</h5>
				 <p className="text-sm">{book.authors}</p>
				 <p className="text-sm">{
				 	book.genre_names && book.genre_names.split('|').map((g, i) => <span className="badge text-bg-primary me-1" key={i}>{g}</span>)
				 }</p>
			</div>
		))}
	</div>
}
