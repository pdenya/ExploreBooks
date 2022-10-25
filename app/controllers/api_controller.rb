class ApiController < ActionController::Base

	around_action :handle_exceptions
	before_action :set_resource, only: [:show, :update, :destroy]

	# pundit
	#include Pundit

	def index
		resources = base_index_query.where(query_params).where(search_params)
								.order(order_args)
								.page(page_params[:page])
								.per(page_params[:page_size])

		instance_variable_set(plural_resource_variable, resources)
		self.before_index

		render_multiple
	end

	def show
		# pundit
		#authorize get_resource
		render json: render_single
	end

	def create
		@resource = resource_class.new(model_params)

		# check for common resources
		@resource.user_id ||= current_user.id if @resource.respond_to?(:user_id) && current_user
		@resource.business_id ||= current_user.business.id if @resource.respond_to?(:business_id) && current_user
		@resource.business_id ||= current_customer.customer_business.business_id if @resource.respond_to?(:business_id) && current_customer
		@resource.customer_id ||= current_customer.id if @resource.respond_to?(:customer_id) && current_customer
		@resource.customer_business_id ||= current_customer.customer_business_id if @resource.respond_to?(:customer_business_id) && current_customer
		self.before_create

		if @resource.save
			self.after_create
			render json: render_single, status: :created
		else
			render json: { error: @resource.errors.full_messages.join(', ')}, status: :unprocessable_entity
		end
	end

	def update
		@resource = resource_class.find(params[resource_name][:id] || params[:id])

		# pundit
		#authorize @resource

		@resource.update!(model_params)

		if get_resource.update(model_params)
			render json: render_single, status: :created
		else
			render json: { error: get_resource.errors }, status: :unprocessable_entity
		end
	end

	def destroy
		# pundit
		#authorize get_resource

		if get_resource.destroy
			render json: render_single
		else
			render json: { error: get_resource.errors }, status: :unprocessable_entity
		end
	end

	# Catch exception and return JSON-formatted error
	# - 404s for record not found
	# - Exception text for `throw "something specific"`
	# - Generic message for everything else
	def handle_exceptions
		begin
			yield
		rescue ActiveRecord::RecordNotFound => e
			render json: { error: "Record not found" }, status: 404
		# pundit
		#rescue Pundit::NotAuthorizedError => e
		#	render json: { error: "Not Authorized" }, status: 403
		rescue StandardError => e
			message = e.message

			if message.include? "uncaught throw"
				# remove the uncaught throw text and return whatever was raised
				message = message[16..-2]
				Rails.logger.error(e.message)
				Rails.logger.error(e.backtrace.first)
			else
				# this is probably an error we didn't explicitly raise so lets return generic text
				message = "Request could not be completed."
				Rails.logger.error(e.message)
				Rails.logger.error(e.backtrace.join("\n"))
			end

			render json: { error: message }, status: 500
		end
	end

	protected

		# OVERRIDE THESE

		def model_params
			throw "model_params is not defined!"
		end

		# OPTIONAL OVERRIDES

		def base_index_query
			policy_scope(resource_class)
		end

		def query_params
			# implement filtering here
			{}
		end

		def search_params
			# implement search here
			{}
		end

		def page_params
			params.permit(:page, :page_size)
		end

		def order_args
			params[:sort] || "updated_at"
		end

		def before_create
			# no-op
		end

		def after_create
			# no-op
		end

		def before_index
			# no-op
		end

		# HELPERS

		def set_resource(resource = nil)
			resource ||= resource_class.find(params[:id])
			instance_variable_set("@#{resource_name}", resource)
		end

		def get_resource
			instance_variable_get("@#{resource_name}")
		end

		def resource_name
			@resource_name ||= self.controller_name.singularize
		end

		def resource_class
			@resource_class ||= resource_name.classify.constantize
		end

		def plural_resource_variable
			"@#{resource_name.pluralize}"
		end

		def render_single
			{ "#{resource_name}": @resource }
		end

		def render_multiple
			resources = instance_variable_get(plural_resource_variable)
			render json: {
				page: resources.current_page,
				total_pages: resources.total_pages,
				page_size: resources.size,
				"#{resource_name.pluralize}" => resources.as_json
			}
		end

		def pundit_user
			current_resource
		end

		def current_resource
			current_user || current_customer
		end

		def authenticate_user_or_customer!
			unless user_signed_in? or customer_signed_in?
				redirect_to new_user_session_url
			end
		end
end
