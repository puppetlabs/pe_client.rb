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

require_relative "../base"

module PEClient
  module Resource
    class PuppetV3
      # Manages the contents of files in the file bucket.
      # All access to files is managed with the md5 checksum of the file contents, represented as `:md5`.
      # Where used, `:filename` means the full absolute path of the file on the client system.
      # This is usually optional and used as an error check to make sure correct file is retrieved.
      # The environment is required in all requests but ignored, as the file bucket does not distinguish between environments.
      #
      # @see https://help.puppet.com/core/current/Content/PuppetCore/server/http_api/http_file_bucket_file.htm
      class FileBucket < Base
        # The base path for Puppet API v3 File Bucket endpoints.
        BASE_PATH = "#{PuppetV3::BASE_PATH}/file_bucket_file".freeze

        # Common headers for file bucket requests
        HEADERS = {"Content-Type": "application/octet-stream", Accept: "application/octet-stream"}

        # Retrieve the contents of a file.
        #
        # @param md5 [String] The MD5 checksum of the file.
        # @param environment [String] Required but ignored.
        # @param filename [String] The full absolute path of the file on the client system.
        #
        # @return [String]
        def get(md5:, environment:, filename: nil)
          @client.get path(md5, filename), params: {environment:}.merge(HEADERS)
        end

        # Check if a file is present in the filebucket
        # This behaves identically to {#get}, only returning headers.
        #
        # @param md5 [String] The MD5 checksum of the file.
        # @param environment [String] Required but ignored.
        # @param filename [String] The full absolute path of the file on the client system.
        #
        # @return [Hash]
        def head(md5:, environment:, filename: nil)
          @client.head path(md5, filename), params: {environment:}.merge(HEADERS)
        end

        # Save a file to the filebucket
        # The body should contain the file contents. This saves the file using the md5 sum of the file contents.
        # If `:filename` is provided, it adds the path to a list for the given file.
        # If the md5 sum in the request is incorrect, the file will be instead saved under the correct checksum.
        #
        # @param md5 [String] The MD5 checksum of the file.
        # @param file [String] The contents of the file to save.
        # @param environment [String] Required but ignored.
        # @param filename [String] The full absolute path of the file on the client system
        #
        # @return [String]
        def save(md5:, file:, environment:, filename: nil)
          @client.put path(md5, filename), body: file, params: {environment:}.merge(HEADERS)
        end

        private

        # Construct the path for file bucket operations
        #
        # @param md5 [String]
        # @param filename [String]
        #
        # @return [String]
        def path(md5, filename = nil)
          if filename
            "#{File.join(BASE_PATH, md5)}/#{filename}"
          else
            File.join(BASE_PATH, md5)
          end
        end
      end
    end
  end
end
