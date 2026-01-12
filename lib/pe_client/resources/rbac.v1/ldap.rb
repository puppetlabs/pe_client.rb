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
    class RBACV1
      # Use the v1 LDAP endpoints to test and configure LDAP directory service connections.
      #
      # @see https://help.puppet.com/pe/current/topics/rbac_api_v1_directory.htm
      class LDAP < Base
        # The base path for RBAC API v1 LDAP endpoints.
        # @deprecated Use {COMMAND_BASE_PATH} methods instead.
        BASE_PATH = "#{RBACV1::BASE_PATH}/ds".freeze

        # The base path for RBAC API v1 LDAP command endpoints.
        COMMAND_BASE_PATH = "#{RBACV1::BASE_PATH}/command/ldap".freeze

        # Configure a new LDAP connection.
        #
        # @param attributes [Hash] The attributes for the new LDAP connection.
        # @option attributes [String] :display_name Directory name.
        # @option attributes [String] :"help-link" Login help.
        # @option attributes [String] :hostname Hostname.
        # @option attributes [Integer] :port Port.
        # @option attributes [String] :login Lookup user.
        # @option attributes [String] :password Lookup password.
        # @option attributes [Integer] :connect_timeout Connection timeout in seconds.
        # @option attributes [Boolean] :ssl Connect using SSL. Cannot be set to true if :start_tls is true.
        # @option attributes [Boolean] :start_tls Connect using StartTLS. Cannot be set to true if :ssl is true.
        # @option attributes [String] :cert_chain Certificate Chain.
        # @option attributes [String] :ssl_hostname_validation Validate the hostname.
        # @option attributes [String] :ssl_wildcard_validation Allow wildcards in SSL certificate.
        # @option attributes [String] :base_dn Base distinguished name.
        # @option attributes [String] :user_lookup_attr User login attribute.
        # @option attributes [String] :user_email_attr User email address field.
        # @option attributes [String] :user_display_name_attr User full name.
        # @option attributes [String] :user_rdn User relative distinguished name.
        # @option attributes [String] :group_object_class Group object class.
        # @option attributes [String] :group_member_attr Group membership field.
        # @option attributes [String] :group_name_attr Group name attribute.
        # @option attributes [String] :group_lookup_attr Group lookup attribute.
        # @option attributes [String] :group_rdn Group relative distinguished name.
        # @option attributes [String] :disable_ldap_matching_rule_in_chain Turn off LDAP_MATCHING_RULE_IN_CHAIN.
        # @option attributes [String] :search_nested_groups Search nested groups.
        #
        # @return [Hash]
        #
        # @see https://help.puppet.com/pe/current/topics/rbac_ldap_ext_directory_settings.htm
        def create(attributes)
          @client.post("#{COMMAND_BASE_PATH}/create", body: attributes)
        end

        # Replace an existing directory service connection's settings.
        #
        # @param attributes [Hash] The attributes for the new LDAP connection.
        #
        # @return [Hash]
        #
        # @see https://help.puppet.com/pe/current/topics/rbac_ldap_ext_directory_settings.htm
        def update(attributes)
          @client.put "#{COMMAND_BASE_PATH}/update", body: attributes
        end

        # Delete an existing directory service connection.
        #
        # @param id [String] The ID of the LDAP connection to delete.
        #
        # @return [Hash] If successful, returns an empty JSON object.
        def delete(id)
          @client.post "#{COMMAND_BASE_PATH}/delete", body: {id:}
        end

        # Test a directory service connection based on supplied settings.
        #
        # @param attributes [Hash] The attributes for the new LDAP connection.
        #
        # @return [Hash]
        #
        # @see https://help.puppet.com/pe/current/topics/rbac_ldap_ext_directory_settings.htm
        def test(attributes)
          @client.post "#{COMMAND_BASE_PATH}/test", body: attributes
        end

        # Test the connection to the connected directory service.
        #
        # @deprecated Use {#test} instead.
        #
        # @param attributes [Hash] The attributes for the new LDAP connection.
        #
        # @return [Hash]
        #
        # @see https://help.puppet.com/pe/current/topics/rbac_ldap_ext_directory_settings.htm
        def ds_test(attributes = nil)
          PEClient.deprecated "ds_test", "test"
          if attributes.nil?
            @client.get "#{BASE_PATH}/test"
          else
            @client.put "#{BASE_PATH}/test", body: attributes
          end
        end

        # Replace current directory service connection settings.
        # You can update the settings or disconnect the service (by removing all settings).
        #
        # @deprecated Use {#create}, {#update}, {#delete} instead.
        #
        # @param attributes [Hash] The attributes for the new LDAP connection.
        #
        # @return [Hash]
        #
        # @see https://help.puppet.com/pe/current/topics/rbac_ldap_ext_directory_settings.htm
        def ds(attributes)
          PEClient.deprecated "ds", "create, update, or delete"
          @client.put("#{BASE_PATH}/ds", body: attributes)
        end
      end
    end
  end
end
