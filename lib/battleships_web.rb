require 'sinatra/base'

class BattleshipsWeb < Sinatra::Base

  set :views, proc { File.join(root, '..', 'views') }

  get '/' do
    erb :index
  end

  get '/start' do
    @visitor = params[:name]
    if @visitor
      erb :welcome
    else
       erb :start
     end
  end

  run! if app_file == $0
end
