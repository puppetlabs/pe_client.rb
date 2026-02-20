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

require_relative "../../base"

module PEClient
  module Resource
    class PuppetDB
      class AdminV1
        # The archive endpoint can be used for importing and exporting PuppetDB archives.
        #
        # @see https://help.puppet.com/pdb/current/topics/archive.htm
        class Archive < Base
          # The base path for PuppetDB Admin v1 Archive endpoints.
          BASE_PATH = "#{AdminV1::BASE_PATH}/archive".freeze

          # This endpoint can be used for streaming a PuppetDB archive into PuppetDB.
          #
          # @param archive [String] The archive file to import to the PuppetDB.
          #   This should be a path to the local file.
          #   This archive must have a file called `puppetdb-bak/metadata.json` as the first entry in the tarfile with a key `command_versions` which is a JSON object mapping PuppetDB command names to their version.
          #
          # @return [Hash]
          #
          # @see https://help.puppet.com/pdb/current/topics/archive.htm#post-pdbadminv1archive
          def import(archive:)
            @client.post BASE_PATH,
              body: {archive: Faraday::Multipart::FilePart.new(archive, "application/octet-stream", File.basename(archive))}
          end

          # This endpoint can be used to stream a tarred, gzipped backup archive of PuppetDB to your local machine.
          #
          # @param path [String] The local file path where the archive will be saved.
          # @param anonymization_profile [String] The level of anonymization applied to the archive files.
          #
          # @return [String] The tarred, gzipped backup archive of PuppetDB.
          #
          # @see https://help.puppet.com/pdb/current/topics/archive.htm#get-pdbadminv1archive
          def export(path:, anonymization_profile: nil)
            File.open(path, "wb") do |file|
              # Using the Connection object directly to stream the response to a file.
              @client.connection.get BASE_PATH, {anonymization_profile:}.compact, {Accepts: "application/octet-stream"} do |req|
                req.options.on_data = proc do |chunk, _overall_received_bytes|
                  file.write(chunk)
                end
              end
            end

            path
          end
        end
      end
    end
  end
end
