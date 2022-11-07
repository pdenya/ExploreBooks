import React from 'react'

const GenreName = ({ genre,requireGenre, removeGenre, className }) => {
	return <div className={className}>
				{genre.name} {genre.book_count && <span className="text-secondary">({genre.book_count})</span>}
				<span role="button" onClick={() => requireGenre(genre.id)} className="px-1">+</span>
				<span role="button" onClick={() => removeGenre(genre.id)} className="px-1">-</span>
			</div>
}


export default GenreName
