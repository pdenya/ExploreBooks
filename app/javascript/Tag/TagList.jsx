import React, { useState, useEffect } from 'react'
import { useQuery } from 'react-query'
import GenreName from 'Book/GenreName'
import BookRow from 'Book/BookRow'

const TagList = (props) => {
	let [genres, setGenres] = useState([])
	let [filtered_genres, setFilteredGenres] = useState([])
	let [required_genres, setRequiredGenres] = useState([])
	let [min_ratings, setMinimumRatings] = useState(0)
	let [max_ratings, setMaxRatings] = useState(0)
	let [min_avg, setMinimumAvg] = useState(0)
	let [max_avg, setMaxAvg] = useState(0)
	let [books, setBooks] = useState({})
	let [total, setTotal] = useState(0)
	const list_id = 1


	const { isLoading, isError, data, error } = useQuery(['books', filtered_genres, required_genres, min_ratings, max_ratings, min_avg, max_avg], async () => {
		const response = await fetch(`/books/tags.json`,{
			method: "post",
			headers: {
				'Accept': 'application/json',
				'Content-Type': 'application/json'
			},

			//make sure to serialize your JSON body
			body: JSON.stringify({
				filtered_genres,
				required_genres,
				min_ratings,
				max_ratings,
				min_avg,
				max_avg
			})
		})
		if (!response.ok) throw new Error('Network response was not ok')

		return response.json()
	}, {
		onSuccess: (books_json) => {
			setTotal(books_json.total)
			setGenres(books_json.genres)
		}
	})

	const removeGenre = (genre_id) => {
		if (filtered_genres.indexOf(genre_id) == -1) {
			setFilteredGenres([...filtered_genres, genre_id])
		} else {
			setFilteredGenres(filtered_genres.filter(g => g != genre_id))
		}
	}

	const requireGenre = (genre_id) => {
		if (required_genres.indexOf(genre_id) == -1) {
			setRequiredGenres([...required_genres, genre_id])
		} else {
			setRequiredGenres(required_genres.filter(g => g != genre_id))
		}
	}

	return <div>
		<p>
			Filtered Genres: {genres.filter(g => filtered_genres.includes(g.id)).map( genre => <GenreName genre={genre} removeGenre={removeGenre} requireGenre={requireGenre} />)}
		</p>
		<p>
			Required Genres: {genres.filter(g => required_genres.includes(g.id)).map( genre => <GenreName genre={genre} removeGenre={removeGenre} requireGenre={requireGenre} />)}
		</p>
		<div className="my-2">
			<div className="row">
				<div className="col-6">
					<div className="row">
						<div className="col-6">
							<div className="border-bottom pb-2">
								<label className="fw-bold">Minimum Ratings</label>
								<input type="text" className="form-control" value={min_ratings} onChange={e => setMinimumRatings(e.target.value)} />
							</div>
						</div>
						<div className="col-6">
							<div className="border-bottom pb-2">
								<label className="fw-bold">Max Ratings</label>
								<input type="text" className="form-control" value={max_ratings} onChange={e => setMaxRatings(e.target.value)} />
							</div>
						</div>
					</div>

					<div className="row">
						<div className="col-6">
							<div className="border-bottom pb-2">
								<label className="fw-bold">Minimum Avg</label>
								<input type="text" className="form-control" value={min_ratings} onChange={e => setMinimumRatings(e.target.value)} />
							</div>
						</div>
						<div className="col-6">
							<div className="border-bottom pb-2">
								<label className="fw-bold">Max Avg</label>
								<input type="text" className="form-control" value={max_ratings} onChange={e => setMaxRatings(e.target.value)} />
							</div>
						</div>
					</div>

					<div className="row">
						{genres && genres.map(genre => {
							return (
								<div className="col-6" key={genre.id}>
									<GenreName genre={genre} removeGenre={removeGenre} requireGenre={requireGenre} />
								</div>
							)
						})}
					</div>
				</div>
				<div className="col-6">
					<h5 className="border-bottom pb-2 mb-2">Books total: { total }</h5>
					{data && data.books && data.books.map( book => {
						return <BookRow book={book} key={book.id} removeGenre={removeGenre} requireGenre={requireGenre} />
					})}
				</div>
			</div>
		</div>
	</div>
}

export default TagList
