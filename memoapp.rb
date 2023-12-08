# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'pg'
require 'securerandom'

connection = PG.connect(dbname: 'memo_app')

def new_memo_id
  SecureRandom.uuid
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
  @memos = connection.exec('select * from memos;')
  erb :index
end

get '/memos/new' do
  erb :new_memo
end

get '/memos/:memo_id' do
  memo_id = params[:memo_id]
  memos = connection.exec_params('select * from memos where memo_id = $1;', [memo_id])
  @memo = memos[0]
  erb :show_memo
end

post '/memos' do
  connection.exec('insert into memos(memo_id, title, content) values ($1,$2,$3);',
                  [new_memo_id, params[:title], params[:content]])
  redirect '/memos'
end

get '/memos/:memo_id/edit' do
  memo_id = params[:memo_id]
  memos = connection.exec_params('select * from memos where memo_id = $1;', [memo_id])
  @memo = memos[0]
  erb :edit_memo
end

patch '/memos/:memo_id' do
  memo_id = params[:memo_id]
  connection.exec_params('update memos set title = $1, content = $2 where memo_id = $3;',
                         [params[:title], params[:content], memo_id])
  redirect '/memos'
end

delete '/memos/:memo_id' do
  memo_id = params[:memo_id]
  connection.exec_params('delete from memos where memo_id = $1;', [memo_id])
  redirect '/memos'
end
