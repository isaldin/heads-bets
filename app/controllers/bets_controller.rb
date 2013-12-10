require 'net/http'
require 'json'

class BetsController < ApplicationController

  def index
    #
  end

  def new
    #
  end

  def search
    #search_string = URI.escape params[:search_string]
    #
    #search_api_url = URI.parse "http://ws.audioscrobbler.com/2.0/?method=artist.search&artist=#{search_string}&api_key=0e7add553b2e3a4e62e655323d407676&format=json"
    #req = Net::HTTP::Get.new(search_api_url.to_s)
    #res = Net::HTTP.start(search_api_url.host, search_api_url.port) do |http|
    #  http.request(req)
    #end
    #course_json = JSON.parse(res.body)
    #
    #course_json['results']['artistmatches']['artist'].each do |artist|
    #  puts "==#{artist['name']}== #{artist['url']}" unless artist['mbid'].empty?
    #end
    #
    #redirect_to action: :index
  end

end
