class ConvosController < ApplicationController

	def index
		@convos = Convo.all.order("created_at DESC")

		if params[:upvotes]
			sum = params[:upvotes].to_i + 1
			Convo.update(params[:id], upvotes: sum)
		end
		if params[:downvotes]
			sum = params[:downvotes].to_i - 1
			Convo.update(params[:id], downvotes: sum)
		end
	end

	def new
		@convo = Convo.new
	end

	def create
		require 'rest_client'
		require 'json'
		@convo = Convo.new(convo_params)
		@convo.upvotes = 0
		@convo.downvotes = 0

		@input = URI.parse(@convo.url).host

		if @input

			@domain = PublicSuffix.parse(@input)
			@api = Kimonoapi.find_by(brand: @domain.sld)

			if @api
				@api_id = @api.api_id
				@api_key = @api.api_key
				@api_token = @api.api_token

				@targeturl = @convo.url

				@payload1 = {
					'apikey' => @api_key,
					'targeturl' => @targeturl
				}
				@headers1 = { 'authorization' => "Bearer #{@api_token}" }
				@api_url1 = "https://www.kimonolabs.com/kimonoapis/#{@api_id}/update"
				r1 = RestClient.post(@api_url1, @payload1, @headers1)

				@payload2 = {
					'apikey' => @api_key
				}
				@headers2 = { 'authorization' => "Bearer #{@api_token}" }
				@api_url2 = "https://www.kimonolabs.com/kimonoapis/#{@api_id}/startcrawl"
				r2 = RestClient.post(@api_url2, @payload2, @headers2)

				sleep 8

				# Figure out how to do this script side
				# if @convo.color
				# 	@send_color = @convo.color.parameterize
				# 	puts @send_color
				# 	@response = RestClient.get "https://www.kimonolabs.com/api/cmvp0t38?apikey=#{@api_key}&color_name=#{@send_color}"

				@response = RestClient.get "https://www.kimonolabs.com/api/cmvp0t38?apikey=#{@api_key}"

				img_url = JSON.parse(@response)

				@convo.img_url = img_url['results']['collection1'][0]['convo_img']['src']

				respond_to do |format|
					if @convo.save
						format.html { redirect_to root_url, notice: 'Convo was successfully created.' }
						format.json { render :show, status: :created, location: @convo }
					else
						format.html { render :new }
		        		format.json { render json: @convo.errors, status: :unprocessable_entity }
					end
				end
			else
				@file_string = @domain.sld
				@file_string += "\n"
				File.open( Rails.root.join('app', 'assets', 'newapis'), "a+") { |file| file.write @file_string }

				respond_to do |format|
					format.html { redirect_to new_convo_url, notice: 'We do not currently have the company you inputted on our service, but will shortly!'  }
				end
			end
		else

			respond_to do |format|
				format.html { redirect_to new_convo_url, notice: 'You did not input a URL.'  }
	      		format.json { render json: @convo.errors, status: :unprocessable_entity }
	    end
		end
	end

	private
		def convo_params
			params.require(:convo).permit(:url, :color)
		end
end
