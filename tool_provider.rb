class ExampleTool < Sinatra::Base
  enable :sessions
  set :protection, :except => :frame_options
  
  use Rack::LTI,
      consumer_key: 'test',
      consumer_secret: 'secret',
  
      app_path: '/launched',
      config_path: '/tool_config.xml',
      launch_path: '/lti_tool',
  
      title: 'Example middleware LTI Tool',
      description: 'Because',
  
      nonce_validator: ->() { true },
      time_limit: 60*60,
  
      custom_params: {
              rack_is_great: true
      }

  get '/' do
    erb :index
  end
  
  get '/launched' do
    # I need the launch data to do interesting stuff
    erb :launched
  end
  
  
end