require_relative 'framework'
require_relative 'database'
require_relative 'queries'
require_relative 'templates'

DB = Database.connect('postgres://localhost/web_framework', QUERIES)
TEMPLATES = Templates.new('views')

APP =
  APP.new do
    get '/' do
      'This is the root'
    end

    get '/users/:username' do |params|
      "This is #{params.fetch('username')}!"
    end

    get '/submissions' do |params|
      DB.all_submissions
    end

    get '/submissions/:name' do |params|
      name = params.fetch('name')
      user = DB.find_submissions_by_name(name: name).fetch(0)
      TEMPLATES.submissions_show(user: user)
    end
  end
