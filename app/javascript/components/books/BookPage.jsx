import React from "react";
import PropTypes from "prop-types";
import BookRow from "books/BookRow";

const BookPage = (props) => {
	let { book } = props;
	let cover_url = book.openlibrary_cover_ids
						? `https://covers.openlibrary.org/b/id/${book.openlibrary_cover_ids}-L.jpg`
						: `https://covers.openlibrary.org/b/olid/${book.openlibrary_id}-L.jpg`;

	return (
		<div className="card-view rounded p-3 m-3 bg-purple">
			<div className="card bg-option-1 text-white c-pointer">
				<div className="row">
					<div className="col-auto pe-0">
						<img width="378" src={cover_url} />
					</div>
					<div className="col p-2 px-3">
						<h1 className="fw-bold mb-0">{book.title}</h1>
						{book.subtitle && <h5 className="fw-bold mb-0">{book.subtitle}</h5>}

						<p>Written By: {book.authors}</p>

						<p className="mb-2 mt-1 h6">
							{book.description}
						</p>
						
						<div>
							{book.genre_names.split("|").map((genre_name) => (
								<div className="badge genre-badge me-1" key={genre_name}>
									{genre_name}
								</div>
							))}
						</div>
					</div>
				</div>
			</div>
		</div>
  	);
};

BookPage.propTypes = {
  book: PropTypes.object
};

export default BookPage;
