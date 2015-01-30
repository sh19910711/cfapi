require "sawyer"
require "logger"
require "addressable/uri"
require "codeforces/client/contest"
require "codeforces/client/problem_set"
require "codeforces/client/user"

class Codeforces::Client

  DEFAULT_ENDPOINT = "http://codeforces.com/api/"
  DEFAULT_PAGE_COUNT = 50

  attr_reader :endpoint

  def initialize(endpoint = DEFAULT_ENDPOINT)
    @endpoint = endpoint
  end

  def logger
    @logger ||= new_logger
  end

  private def new_logger
    logger = ::Logger.new(STDOUT)
    logger.level = ::Logger::INFO
    logger
  end

  def agent
    @agent ||= ::Sawyer::Agent.new(DEFAULT_ENDPOINT)
  end

  def last_response
    @last_response
  end

  def get(path, options = {})
    request_uri = ::Addressable::URI.new
    options[:query] ||= {}
    request_uri.query_values = options[:query]
    request(:get, "#{path}#{request_uri.query.empty? ? "" : "?#{request_uri.query}"}", options[:data], options).result
  end

  def request(method, path, data, options = {})
    logger.debug "#{method.upcase} #{URI.join endpoint, path}"
    @last_response = agent.call(method, path, data)

    unless last_response.data.status === "OK"
      raise "Error: #{last_response.data.status}"
    end

    last_response.data
  end

  def paginate(offset)
    offset = 0 if offset.nil?
    result = {
      :from => DEFAULT_PAGE_COUNT * offset + 1,
      :count => DEFAULT_PAGE_COUNT,
    }
  end

  def multi_values(values)
    values.join ";"
  end

  def contest
    @contest ||= ::Codeforces::Client::Contest.new(self)
  end

  def problemset
    @problem_set ||= ::Codeforces::Client::ProblemSet.new(self)
  end

  def user
    @user ||= ::Codeforces::Client::User.new(self)
  end

end
