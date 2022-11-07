import React, { useState, useEffect } from 'react'
import { useQuery } from 'react-query'
import GenreName from 'Book/GenreName'

const BookList = (props) => {
	let [genre_counts, setGenreCounts] = useState({})
	let [filtered_genres, setFilteredGenres] = useState([])
	let [required_genres, setRequiredGenres] = useState([])
	let [books, setBooks] = useState({})
	let [lists, setLists] = useState({})
	const list_id = 1


	const { isLoading, isError, data, error } = useQuery(['books'], async () => {
		const response = await fetch(`/books.json?goodreads_list_id=${list_id}`)
		if (!response.ok) throw new Error('Network response was not ok')

		return response.json()
	}, {
		onSuccess: (books_json) => {
			setBooks(
				Object.assign(
					{},
					books,
					books_json.reduce((obj, book) => ({ ...obj, [book.id]: book }))
				)
			)

			const book_test_obj = books_json.reduce((obj, book) => ({ ...obj, [book.id]: book }))
			console.log(Object.keys(book_test_obj).length, books_json.length)

			setLists(
				Object.assign({}, lists, {
					[list_id]: books_json.map(book => book.id)
				})
			)
		}
	})

	const { data: list_data } = useQuery([`lists-${list_id}`], async () => {
		const response = await fetch(`/goodreads_lists/${list_id}.json`)
		if (!response.ok) throw new Error('Network response was not ok')
		return response.json()
	})

	useEffect(() => {
		if (data) {
			let genre_count_map = { 'Genres not known': 0 }
			data.forEach(book => {
				let genre_names = book?.genre_names ? book.genre_names.split('|') : []

				if (filtered_genres.length > 0 && genre_names.filter(g => !filtered_genres.includes(g)).length > 0) return null
				if (required_genres.length > 0 && required_genres.find(rg => !genre_names.includes(rg)) !== undefined) return null

				genre_names.map(genre_name => {
					if (!genre_count_map[genre_name]) genre_count_map[genre_name] = 0
					genre_count_map[genre_name] += 1
				})

				if(!book.genre_names) genre_count_map['Genres not known'] += 1
			})

			setGenreCounts(genre_count_map)
		}
	}, [data, filtered_genres, required_genres])

	const removeGenre = (genre_name) => {
		if (filtered_genres.indexOf(genre_name) == -1) setFilteredGenres([...filtered_genres, genre_name])
	}

	const requireGenre = (genre_name) => {
		if (required_genres.indexOf(genre_name) == -1) setRequiredGenres([...required_genres, genre_name])
	}

	return <div>
		<p>Primary List: { list_data && list_data.name }</p>
		<p>Books Loaded: { data && data.length }</p>
		<p>Filtered Genres: {filtered_genres.join(', ')}</p>
		<p>Required Genres: {required_genres.join(', ')}</p>
		<div className="my-2">
			<div className="row">
				{Object.keys(genre_counts).sort().map(genre_name => {
					if (!genre_counts[genre_name] || genre_counts[genre_name] < 3) return null;

					return (
						<div className="col-3" key={genre_name}>
							<GenreName genre_name={genre_name} genre_counts={genre_counts} removeGenre={removeGenre} requireGenre={requireGenre} />
						</div>
					)
				})}
			</div>
		</div>
		<hr />
		{ lists && lists[list_id] && lists[list_id].map( book_id => {
			const book = books[book_id]
			if (!book) return null
			let genre_names = book?.genre_names ? book.genre_names.split('|') : []
			if (filtered_genres.length > 0 && genre_names.filter(g => !filtered_genres.includes(g)).length > 0) return null
			if (required_genres.length > 0 && required_genres.find(rg => !genre_names.includes(rg)) !== undefined) return null

			return <div className="border-bottom" key={book.id}>
				 <h5 className="mb-0">{book.title}</h5>
				 <p className="text-sm">{book.authors}</p>
				 <p className="text-sm">{
				 	genre_names.map((g, i) => <span className="badge text-bg-primary me-1" key={i}>{g}</span>)
				 }</p>
			</div>
		})}
	</div>
}

export default BookList
