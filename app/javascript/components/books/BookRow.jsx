import React from "react";
import PropTypes from "prop-types";
import cn from 'classnames';

class BookRow extends React.Component {
	render () {
		let { book, addGenre, removeGenre } = this.props;

		const genreClicked = (e) => {
			console.log(e)

			if (e.shiftKey) {
				addGenre && addGenre()
			}
		}

		return (
			<div className={cn("card text-body", this.props.className)}>
				<div className="row">
					<div className="col-auto bg-purple-light pe-0">
						<a href={`/books/${book.id}`}>
							<img
								width="100"
								height="147"
								src={
									book.openlibrary_cover_ids
										? `https://covers.openlibrary.org/b/id/${book.openlibrary_cover_ids}-M.jpg`
										: `https://covers.openlibrary.org/b/olid/${book.openlibrary_id}-M.jpg`
								}
							/>
						</a>
					</div>
					<div className="col p-2 px-3">
						<a href={`/books/${book.id}`}>
							<h4 className="fw-bold mb-0">{book.title}</h4>
							{book.subtitle && (
								<h5 className="fw-bold mb-0">{book.subtitle}</h5>
							)}
						</a>
						<div className="book-description mb-2 mt-1">
							{book.authors}{" "}
							{book.publication_date &&
								book.publication_date.split("-")[0] + " - "}
							{book.description}
						</div>
						<div>
							{book.genre_names && book.genre_names.split("|").map((genre_name) => (
								<GenreTag key={genre_name} genre_name={genre_name} />
							))}
						</div>
					</div>
				</div>
			</div>
		);
	}
}

BookRow.propTypes = {
	book: PropTypes.object,
	className: PropTypes.string,
	addGenre: PropTypes.func,
	removeGenre: PropTypes.func
}

export default BookRow


function GenreTag({ genre_name, onClick }) {
	let url = new URL(window.location.href);
	url.searchParams.append('genres[]', genre_name);
	url.searchParams.set('page', 1);

	return (
		<a href={url.href} onClick={(e) => (onClick && onClick(e, genre_name))} className="badge genre-badge me-1">
			{genre_name}
		</a>
	)
}

GenreTag.propTypes = {
	genre_name: PropTypes.string
}
