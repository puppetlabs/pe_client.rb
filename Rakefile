# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

require "standard/rake"

task :yard_lint do
  sh "yard-lint ."
end

desc "Validates all @see URLs"
task :validate_urls do
  require "uri"
  require "net/http"

  # ANSI color codes
  green = "\e[32m"
  red = "\e[31m"
  blue = "\e[34m"

  def message(text, colour_code)
    puts "#{colour_code}#{text}\e[0m"
  end

  # Extract URLs from lib directory
  def extract_urls(lib_dir)
    urls = Set.new
    Dir.glob(File.join(lib_dir, "**", "*.rb")).each do |file|
      File.readlines(file).each do |line|
        urls.add(Regexp.last_match(1)) if line =~ /@see\s+(https?:\/\/[^\s]+)/
      end
    end
    urls.to_a.sort
  end

  # Validate a single URL
  def validate_url(url, max_redirects: 5)
    uri = URI.parse(url)
    redirect_count = 0

    loop do
      response = make_request(uri, :head)

      case response
      when Net::HTTPSuccess
        return {status: :success, code: response.code, message: "OK"}
      when Net::HTTPRedirection
        return {status: :error, code: response.code, message: "Too many redirects"} if redirect_count >= max_redirects

        location = response["location"]
        uri = URI.parse(location)
        redirect_count += 1
        next
      when Net::HTTPMethodNotAllowed, Net::HTTPNotImplemented
        # Some servers don't support HEAD, try GET
        response = make_request(uri, :get)
        if response.is_a?(Net::HTTPSuccess)
          return {status: :success, code: response.code, message: "OK (via GET)"}
        else
          return {status: :error, code: response.code, message: response.message}
        end
      else
        return {status: :error, code: response.code, message: response.message}
      end
    end
  rescue => e
    {status: :error, code: nil, message: e.message}
  end

  # Make HTTP request
  def make_request(uri, method = :head)
    Net::HTTP.start(uri.host, uri.port,
      use_ssl: uri.scheme == "https",
      open_timeout: 10,
      read_timeout: 10,
      verify_mode: OpenSSL::SSL::VERIFY_PEER) do |http|
      request_class = (method == :head) ? Net::HTTP::Head : Net::HTTP::Get
      request = request_class.new(uri.request_uri)
      request["User-Agent"] = "PEClient Ruby/#{RUBY_VERSION}"
      http.request(request)
    end
  end

  lib_dir = File.expand_path("lib", __dir__)

  message("Extracting @see URLs from #{lib_dir}...", blue)
  urls = extract_urls(lib_dir)

  message("Found #{urls.length} unique URLs", blue)
  puts "\n"

  results = {
    success: [],
    error: [],
    total: urls.length
  }

  urls.each_with_index do |url, index|
    print "[#{index + 1}/#{urls.length}] Checking #{url}... "

    result = validate_url(url)

    if result[:status] == :success
      message(" #{result[:code]} #{result[:message]}", green)
      results[:success] << {url: url, result: result}
    else
      message(" #{result[:code] || "N/A"} #{result[:message]}", red)
      results[:error] << {url: url, result: result}
    end

    sleep 0.1
  end

  # Print summary
  message("\n#{"=" * 20}", blue)
  message("Summary", blue)
  message("=" * 20, blue)
  puts "Total URLs: #{results[:total]}"
  message("Success: #{results[:success].length}", green)
  message("Errors: #{results[:error].length}", red)

  if results[:error].any?
    message("\nFailed URLs:", red)
    results[:error].each do |item|
      puts "  #{item[:url]}"
      puts "    #{item[:result][:code] || "N/A"} - #{item[:result][:message]}"
    end

    abort "URL validation failed!"
  else
    message("\nAll URLs are valid!", green)
  end
end

task default: %i[spec standard yard_lint]
