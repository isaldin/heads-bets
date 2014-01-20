#encoding: utf-8

require 'net/http'
require 'json'

class BetsController < ApplicationController

  def index
    #
  end

  def new
    [@search_results = params[:search_results] || [], @search_string = params[:search_string] || '']
  end

  def search
    @search_string = params[:search_string]

    search_api_url = URI.parse "http://ws.audioscrobbler.com/2.0/?method=artist.search&artist=#{URI.escape @search_string}&api_key=0e7add553b2e3a4e62e655323d407676&format=json"
    req = Net::HTTP::Get.new(search_api_url.to_s)
    res = Net::HTTP.start(search_api_url.host, search_api_url.port) do |http|
      http.request(req)
    end
    artists_json = JSON.parse(res.body)
    @search_results = []
    flash[:error] = nil

    if artists_json.has_key?('error')
      flash[:error] = 'По вашему запросу ничего не найдено :('
    elsif artists_json['results']['opensearch:totalResults'].to_i > 0
      artists_json['results']['artistmatches']['artist'].each do |artist|
        unless artist['mbid'].empty?
          @search_results << {
              mbid:         artist['mbid'],
              name:         artist['name'],
              lastfm_url:   artist['url'],
              image:        artist['image'].select{ |el| el['size'] == 'extralarge' }.first['#text']
          }
        end
      end
      flash[:error] = if @search_results.size == 0
                        'По вашему запросу ничего не найдено :('
                      elsif @search_results.size == 30
                        'Найдено более 30 исполнителей.'
                      end
      flash[:error] << 'Максимальное число ставок - 10 - превышенно.' if current_user.bets.count == 10
    else
      flash[:error] = 'По вашему запросу ничего не найдено :('
    end

    render :new
  end

end
