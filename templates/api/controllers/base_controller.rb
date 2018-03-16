class BaseController < Sinatra::Base

  include Shaf::Errors

  configure do
    disable :static
    enable :logging
    enable :method_override
    mime_type :hal, 'application/hal+json'
    set :views, VIEWS_DIR
    set :static, !production?
    set :public_folder, ASSETS_DIR
    disable :dump_errors
    set :show_exceptions, :after_handler
    enable :current_user
    set :auth_token_header, AUTH_TOKEN_HEADER
  end

  use Rack::Deflater

  def self.inherited(controller)
    super
    Shaf::App.use controller
  end

  def self.log
    $logger
  end

  def log
    self.class.log
  end

  register(*Shaf.extensions)
  helpers(*Shaf.helpers)

  before do
    log.info "Processing: #{request.request_method} #{request.path_info}"
    log.debug "Payload: #{payload || 'empty'}"
  end

  error StandardError do
    err = env['sinatra.error']
    log.error err.message
    err.backtrace.each(&log.method(:error))

    api_error = to_api_error(err)

    respond_with api_error,
      status: api_error.http_status,
      serializer: ErrorSerializer
  end

  def to_api_error(err)
    case err
    when Shaf::Authorize::PolicyViolationError
      ForbiddenError.new
    when ServerError
      err
    else
      ServerError.new(err.message)
    end
  end
end
