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
      # This endpoint returns select metadata for a single file or many files.
      # Although the term "file_path" is used generically in the endpoint name and documentation, each returned item can be one of the following three types:
      #   - File
      #   - Directory
      #   - Symbolic link
      #
      # @see https://help.puppet.com/core/current/Content/PuppetCore/server/http_api/http_file_metadata.htm
      class FileMetadata < Base
        # The base path for Puppet API v3 File Metadata endpoints.
        BASE_PATH = "#{PuppetV3::BASE_PATH}/file_metadata".freeze
        # Search base path for Puppet API v3 File Metadata endpoints.
        SEARCH_BASE_PATH = "#{BASE_PATH}s".freeze

        # Get file metadata for a single file
        #
        # @param mount [String] One of the following types:
        #   - Custom file serving mounts as specified in fileserver.conf
        #   - `modules/<MODULE>` --- a semi-magical mount point which allows access to the files subdirectory of <MODULE>
        #   - `plugins` --- a highly magical mount point which merges the lib directory of every module together.
        #     Used for syncing plugins; not intended for general consumption.
        #     Per-module sub-paths can not be specified.
        #   - `pluginfacts` --- a highly magical mount point which merges the facts.d directory of every module together.
        #     Used for syncing external facts; not intended for general consumption.
        #     Per-module sub-paths can not be specified.
        #   - `tasks/<MODULE>` --- a semi-magical mount point which allows access to files in the tasks subdirectory of <MODULE>
        # @param file_path [String] The path to the file.
        # @param environment [String] The environment to use when retrieving the file metadata.
        # @param links [String] either "manage" (default) or "follow".
        # @param checksum_type [String] the checksum type to calculate the checksum value for the result metadata; one of "md5" (default), "md5lite", "sha256", "sha256lite", "mtime", "ctime", and "none".
        # @param source_permissions [String] whether (and how) Puppet should copy owner, group, and mode permissions; one of
        #   - "ignore" (the default) will never apply the owner, group, or mode from the source when managing a file.
        #     When creating new files without explicit permissions, the permissions they receive will depend on platform-specific behavior.
        #     On POSIX, Puppet will use the umask of the user it is running as.
        #     On Windows, Puppet will use the default DACL associated with the user it is running as.
        #   - "use" will cause Puppet to apply the owner, group, and mode from the source to any files it is managing.
        #   - "use_when_creating" will only apply the owner, group, and mode from the source when creating a file; existing files will not have their permissions overwritten.
        #
        # @return [Hash]
        def find(mount:, file_path:, environment:, links: nil, checksum_type: nil, source_permissions: nil)
          @client.get File.join(BASE_PATH, mount, file_path), params: {environment:, links:, checksum_type:, source_permissions:}.compact
        end

        # Get a list of metadata for multiple files
        #
        # @param file_path [String] The path to the file.
        # @param environment [String] The environment to use when retrieving the file metadata.
        # @param recurse [String] Should always be set to "yes"; unfortunately the default is "no", which causes a search to behave like a find operation.
        # @param ignore [Array<String>] File or directory regex to ignore.
        # @param links [String] either "manage" (default) or "follow".
        # @param checksum_type [String] the checksum type to calculate the checksum value for the result metadata; one of "md5" (default), "md5lite", "sha256", "sha256lite", "mtime", "ctime", and "none".
        # @param source_permissions [String] whether (and how) Puppet should copy owner, group, and mode permissions; one of
        #   - "ignore" (the default) will never apply the owner, group, or mode from the source when managing a file.
        #     When creating new files without explicit permissions, the permissions they receive will depend on platform-specific behavior.
        #     On POSIX, Puppet will use the umask of the user it is running as.
        #     On Windows, Puppet will use the default DACL associated with the user it is running as.
        #   - "use" will cause Puppet to apply the owner, group, and mode from the source to any files it is managing.
        #   - "use_when_creating" will only apply the owner, group, and mode from the source when creating a file; existing files will not have their permissions overwritten.
        #
        # @return [Array<Hash>]
        def search(file_path:, environment:, recurse: "yes", ignore: nil, links: nil, checksum_type: nil, source_permissions: nil)
          @client.get File.join(SEARCH_BASE_PATH, file_path), params: {environment:, recurse:, ignore:, links:, checksum_type:, source_permissions:}.compact
        end
      end
    end
  end
end
