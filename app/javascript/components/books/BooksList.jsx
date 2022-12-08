import React from "react"
import PropTypes from "prop-types"
import BookRow from 'books/BookRow'
import Pagination from 'ui/Pagination'
import Masonry, { ResponsiveMasonry } from "react-responsive-masonry";


const BooksList = (props) => {

	const goToPage = () => {
		console.log('load page with javascript and return false')
	}

	return (
		<div className="card-view rounded p-3 m-3">
			<div className="row mb-2" style={{ marginBottom: "-5px" }}>
				<div className="col"></div>
				<div className="col-auto">
					<Pagination
						pageCount={props.page_count}
						pageIndex={props.current_page}
						urlForPage={(i) => {
							let url = new URLSearchParams(window.location.href);
							url.set('page', i);
							return url.href;
						}}
						goToPage={goToPage}
					/>
				</div>
			</div>
			<div className="row g-4">
				<ResponsiveMasonry
					columnsCountBreakPoints={{ 350: 1, 750: 2, 1300: 3 }}
				>
					<Masonry gutter="15px">
						{props.books.map((book) => (
							<BookRow book={book} className="" key={book.id} />
						))}
					</Masonry>
				</ResponsiveMasonry>
			</div>
		</div>
	);
}

BooksList.propTypes = {
	books: PropTypes.array,
	page_count: PropTypes.number,
	current_page: PropTypes.number,
}

export default BooksList
