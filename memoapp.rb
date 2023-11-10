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

not_found do
  erb :not_found
end

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

get '/' do
  @json_data = read_json_file
  erb :index
end

get '/memos' do
  erb :new_memo
end

get '/memos/:memo_id' do
  json_data = read_json_file
  memo_id = params[:memo_id].to_i
  pass unless json_data.find { |data| data['id'] == memo_id }
  @finded_memo = json_data.find { |data| data['id'] == memo_id }
  erb :show_memo
end

post '/memos' do
  memo_id = col_memo_id
  json_data = read_json_file
  input_title = params[:title] == '' ? params[:title] = '未入力' : params[:title]
  new_memo = { 'id' => memo_id, 'title' => h(input_title), 'content' => h(params[:content]) }
  json_data << new_memo
  File.open('public/memos.json', 'w') do |file|
    file.write(JSON.pretty_generate(json_data))
  end
  redirect '/'
end

get '/edit_memos/:edit_memo_id' do
  json_data = read_json_file
  memo_id = params[:edit_memo_id].to_i
  pass unless json_data.find { |data| data['id'] == memo_id }
  @finded_memo = json_data.find { |data| data['id'] == memo_id }
  erb :edit_memo
end

patch '/edit_memos/:edit_memo_id' do
  memo_id = params[:edit_memo_id].to_i
  json_data = read_json_file
  finded_memo = json_data.find { |data| data['id'] == memo_id }
  input_title = params[:title] == '' ? params[:title] = '未入力' : params[:title]
  finded_memo['title'] = h(input_title)
  finded_memo['content'] = h(params[:content])
  File.open('public/memos.json', 'w') do |file|
    file.write(JSON.pretty_generate(json_data))
  end
  redirect '/'
end

delete '/memos/:memo_id' do
  memo_id = params[:memo_id].to_i
  json_data = read_json_file
  json_data.delete_if { |data| data['id'] == memo_id }
  File.open('public/memos.json', 'w') do |file|
    file.write(JSON.pretty_generate(json_data))
  end
  redirect '/'
end
