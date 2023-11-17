# frozen_string_literal: true

require 'sinatra'
require 'json'
require 'sinatra/reloader'

def read_json_file
  FileTest.zero?('public/memos.json') ? [] : JSON.parse(File.read('public/memos.json'))
end

def col_memo_id
  json_data = read_json_file
  memo_id = json_data.empty? ? 0 : json_data.last['id']
  memo_id + 1
end

def write_json_file(file_data)
  File.open('public/memos.json', 'w') do |file|
    file.write(JSON.pretty_generate(file_data))
  end
end

not_found do
  erb :not_found
end

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

get '/memos' do
  @json_data = read_json_file
  erb :index
end

get '/new' do
  erb :new_memo
end

get '/memos/:memo_id' do
  json_data = read_json_file
  memo_id = params[:memo_id].to_i
  @found_memo = json_data.find { |data| data['id'] == memo_id }
  pass unless @found_memo
  erb :show_memo
end

post '/memos' do
  memo_id = col_memo_id
  json_data = read_json_file
  new_memo = { 'id' => memo_id, 'title' => params[:title], 'content' => params[:content] }
  json_data << new_memo
  write_json_file(json_data)
  redirect '/memos'
end

get '/memos/:memo_id/edit' do
  json_data = read_json_file
  memo_id = params[:memo_id].to_i
  @found_memo = json_data.find { |data| data['id'] == memo_id }
  pass unless @found_memo
  erb :edit_memo
end

patch '/memos/:memo_id' do
  memo_id = params[:memo_id].to_i
  json_data = read_json_file
  found_memo = json_data.find { |data| data['id'] == memo_id }
  found_memo['title'] = params[:title]
  found_memo['content'] = params[:content]
  write_json_file(json_data)
  redirect '/memos'
end

delete '/memos/:memo_id' do
  memo_id = params[:memo_id].to_i
  json_data = read_json_file
  json_data.delete_if { |data| data['id'] == memo_id }
  write_json_file(json_data)
  redirect '/memos'
end
