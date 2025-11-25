# frozen_string_literal: true

# Copyright 2025 Perforce Software Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

module PEClient
  # Base error class
  class Error < StandardError; end

  # Generic HTTP errors
  #
  # @attr_reader response [Faraday::Response] The HTTP response that caused the error.
  class HTTPError < Error
    attr_reader :response

    # @param response [Faraday::Response] The HTTP response that caused the error.
    # @param message [String] An optional custom error message.
    def initialize(response, message = nil)
      @response = response
      super(message || "HTTP #{@response.status} Error: #{@response.body}")
    end
  end

  # HTTP 400 errors
  class BadRequestError < HTTPError; end
  # HTTP 401 errors
  class UnauthorizedError < HTTPError; end
  # HTTP 403 errors
  class ForbiddenError < HTTPError; end
  # HTTP 404 errors
  class NotFoundError < HTTPError; end
  # HTTP 409 errors
  class ConflictError < HTTPError; end
  # HTTP 500-599 errors
  class ServerError < HTTPError; end
end
