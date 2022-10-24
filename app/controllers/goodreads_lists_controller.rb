class GoodreadsListsController < ApplicationController
	before_action :set_goodreads_list, only: %i[ show edit update destroy ]

	# GET /goodreads_lists or /goodreads_lists.json
	def index
		@goodreads_lists = GoodreadsList.all.page(params[:page] || 1).per(50)
	end

	# GET /goodreads_lists/1 or /goodreads_lists/1.json
	def show
	end

	# GET /goodreads_lists/new
	def new
		@goodreads_list = GoodreadsList.new
	end

	# GET /goodreads_lists/1/edit
	def edit
	end

	# POST /goodreads_lists or /goodreads_lists.json
	def create
		@goodreads_list = GoodreadsList.new(goodreads_list_params)

		respond_to do |format|
			if @goodreads_list.save
				format.html { redirect_to goodreads_list_url(@goodreads_list), notice: "Goodreads list was successfully created." }
				format.json { render :show, status: :created, location: @goodreads_list }
			else
				format.html { render :new, status: :unprocessable_entity }
				format.json { render json: @goodreads_list.errors, status: :unprocessable_entity }
			end
		end
	end

	# PATCH/PUT /goodreads_lists/1 or /goodreads_lists/1.json
	def update
		respond_to do |format|
			if @goodreads_list.update(goodreads_list_params)
				format.html { redirect_to goodreads_list_url(@goodreads_list), notice: "Goodreads list was successfully updated." }
				format.json { render :show, status: :ok, location: @goodreads_list }
			else
				format.html { render :edit, status: :unprocessable_entity }
				format.json { render json: @goodreads_list.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /goodreads_lists/1 or /goodreads_lists/1.json
	def destroy
		@goodreads_list.destroy

		respond_to do |format|
			format.html { redirect_to goodreads_lists_url, notice: "Goodreads list was successfully destroyed." }
			format.json { head :no_content }
		end
	end

	def import
		url = params[:url]
		goodreads_list_id = url.split('/').last.to_i

		list = GoodreadsList.where(goodreads_id: goodreads_list_id).first
		if list
			render json: list
			return
		end

		list = GoodreadsList.create(goodreads_id: goodreads_list_id)

		list.import

		render json: list
	end

	private
		# Use callbacks to share common setup or constraints between actions.
		def set_goodreads_list
			@goodreads_list = GoodreadsList.find(params[:id])
		end

		# Only allow a list of trusted parameters through.
		def goodreads_list_params
			params.require(:goodreads_list).permit(:goodreads_id, :name, :description)
		end
end
