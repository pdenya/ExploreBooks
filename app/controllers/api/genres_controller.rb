class Api::GenresController < ApiController

	#before_action :authenticate_user_or_customer!

	def search_params

	end

	def query_params
		{}
	end

	protected

		def model_params
			params.require(:genre).permit(:name)
		end
end
