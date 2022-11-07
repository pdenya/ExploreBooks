import React from 'react'
import GenreName from 'Book/GenreName'

const BookRow = ({ book, removeGenre, requireGenre }) => {
	if (!book) return null
	let genre_names = book?.genre_names ? book.genre_names.split('|') : []

	return <div className="border-bottom" key={book.id}>
		 <h5 className="mb-0">{book.title}</h5>
		 <div className="row">
		 	<div className="col text-sm">
			 	{book.authors}
		 	</div>
		 	<div className="col">
		 		Avg. {book.average_rating}
		 	</div>
		 	<div className="col">
		 		Num Ratings {book.ratings_count}
		 	</div>
		 	<div className="col">
		 		<a href={`https://www.goodreads.com/book/show/${book.goodreads_id}`} target="_blank">GoodReads</a>
		 	</div>
		 </div>

		 <p className="text-truncate mb-1">{book.description}</p>

		 <p className="">{
		 	book.genres.map((genre) => <GenreName genre={genre} removeGenre={removeGenre} requireGenre={requireGenre} key={genre.id} className="badge text-bg-primary me-2" />)
		 }</p>
	</div>
}

export default	BookRow
