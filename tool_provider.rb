class ExampleTool < Sinatra::Base
  enable :sessions
  set :protection, :except => :frame_options
  set :session_secret, "change me please"

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
    create_tp

    if @tp.outcome_service?
      # It's a launch for grading
      erb :assessment
    else
      # normal tool launch without grade write-back
      @tp.lti_msg = "Sorry that tool was so boring"
      erb :launched
    end
  end

  # post the assessment results
  post '/assessment' do
    create_tp

    if !@tp.outcome_service?
      return show_error "This tool wasn't lunched as an outcome service"
    end

    # post the given score to the TC
    res = @tp.post_replace_result!(params['score'])

    if res.success?
      @score = params['score']
      @tp.lti_msg = "Message shown when arriving back at Tool Consumer."
      erb :assessment_finished
    else
      @tp.lti_errormsg = "The Tool Consumer failed to add the score."
      show_error "Your score was not recorded: #{res.description}"
    end
  end

  private

  def create_tp
    @tp = IMS::LTI::ToolProvider.new('test', 'secret', session['launch_params'])
  end

  def show_error(message)
    @message = message
    erb :error
  end
end