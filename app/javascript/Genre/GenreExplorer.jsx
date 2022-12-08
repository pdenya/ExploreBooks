import React, { useState, useEffect } from 'react'
import { useQuery } from 'react-query'
import GenreName from 'Book/GenreName'


const GenreExplorer = () => {

	const [search_str, setSearch] = useState('')
	const [genres, setGenres] = useState([])


	const { isLoading, isError, data, error } = useQuery(['genres', search_str], async () => {
		const response = await fetch(`/genres/search.json`,{
			method: "post",
			headers: {
				'Accept': 'application/json',
				'Content-Type': 'application/json'
			},

			//make sure to serialize your JSON body
			body: JSON.stringify({
				search_str
			})
		})
		if (!response.ok) throw new Error('Network response was not ok')

		return response.json()
	}, {
		onSuccess: (genre_response) => {
			setGenres(genre_response)
		}
	})


	return <div>

		<input type="text" className="form-control" onChange={e => setSearch(e.currentTarget.value)} placeholder="Genre Search" />

		{
			genres.map(g => <div key={g.id}>{g.name}</div>)
		}
	</div>
}

export default GenreExplorer
