# RBAC Service v2 API

[The RBAC Service v2 API](https://help.puppet.com/pe/current/topics/rbac_api_v2_endpoints.htm) is useful for:

- Fetch users (with filters).
- Revoking authentication tokens.
- Managing LDAP.

Communicates with Puppet Enterprise on port 4433.

## Users Endpoints

With role-based access control (RBAC), you can manage local users and remote users (created on a directory service).
Use the RBAC API v2 GET /users endpoint to get lists of users and information about users.

### GET /users

[Reference](https://help.puppet.com/pe/current/topics/rbac-api-v2-user-get-users.htm)

Fetches all users, both local and remote (including the superuser) with options for filtering and sorting response content.

```ruby
client.rbac_v2.users.get(
    offset: 0,
    limit: 500,
    order: "asc",
    order_by: "id",
    filter: "example.com",
    include_roles: true
)
# => {
#   "users" => [
#     {
#       "id" => "fe62d770-5886-11e4-8ed6-0800200c9a66",
#       "login" => "Kalo",
#       "email" => "kalohill@example.com",
#       "display_name" => "Kalo Hill",
#       "role_ids" => [1, 2, 3],
#       "is_group" => false,
#       "is_remote" => false,
#       "is_superuser" => true,
#       "is_revoked" => false,
#       "last_login" => "2014-05-04T02:32:00Z"
#     },
#     {
#       "id" => "07d9c8e0-5887-11e4-8ed6-0800200c9a66",
#       "login" => "Jean",
#       "email" => "jeanjackson@example.com",
#       "display_name" => "Jean Jackson",
#       "role_ids" => [2, 3],
#       "inherited_role_ids" => [5],
#       "is_group" => false,
#       "is_remote" => true,
#       "is_superuser" => false,
#       "group_ids" => [
#         "2ca57e30-5887-11e4-8ed6-0800200c9a66"
#       ],
#       "is_revoked" => false,
#       "last_login" => "2014-05-04T02:32:00Z"
#     },
#     {
#       "id" => "1cadd0e0-5887-11e4-8ed6-0800200c9a66",
#       "login" => "Amari",
#       "email" => "amariperez@example.com",
#       "display_name" => "Amari Perez",
#       "role_ids" => [2, 3],
#       "inherited_role_ids" => [5],
#       "is_group" => false,
#       "is_remote" => true,
#       "is_superuser" => false,
#       "group_ids" => [
#         "2ca57e30-5887-11e4-8ed6-0800200c9a66"
#       ],
#       "is_revoked" => false,
#       "last_login" => "2014-05-04T02:32:00Z"
#     }
#   ],
#   "pagination" => {
#     "total" => 1,
#     "limit" => 400,
#     "offset" => 1,
#     "order" => "desc",
#     "filter" => "example.com",
#     "order_by" => "last_login"
#   }
# }
```

## User Groups Endpoints

User groups allow you to quickly assign one or more roles to a set of users by placing all relevant users in the group.
This is more efficient than assigning roles to each user individually.
The v2 POST /groups endpoint has additional optional parameters you can use when creating groups.

### POST /groups (deprecated)

> [!CAUTION]
> DEPRECATED: Use [RBAC Service v1 POST /command/groups/create](rbac_service_v1.md#post-commandgroupscreate) instead.

Create a new remote directory user group.

```ruby
client.rbac_v2.groups.create(
    login: "augmentators",
    role_ids: [1,2,3],
    display_name: "The Augmentators",
    identity_provider_id: "0e1a11bd-658f-4c8e-9a1b-0800200c9a66",
    validate: true
)
# => {}
```

## Tokens Endpoints

Authentication tokens control access to PE services. Use the v2 tokens endpoints to revoke and validate tokens.

### DELETE /tokens

[Reference](https://help.puppet.com/pe/current/topics/rbac_api_v2_revoke_tokens_delete_tokens.htm)

Use this endpoint to revoke one or more authentication tokens, ensuring the tokens can no longer be used with RBAC to access PE services.

```ruby
client.rbac_v2.tokens.delete(
    revoke_tokens: ["<TOKEN>", "<TOKEN>"],
    revoke_tokens_by_labels: ["Workstation Token", "VPS Token"],
    revoke_tokens_by_usernames: ["<USER_NAME>", "<USER_NAME>"],
    revoke_tokens_by_ids: ["76351f96-3d89-4947-bde9-bc3d86542839", "76351f96-3d89-4947-bde9-bc3d86542839"]
)
# => {}
```

### DELETE /tokens/\<token>

[Reference](https://help.puppet.com/pe/current/topics/rbac_api_v2_revoke_tokens_delete_tokens_name.htm)

Use this endpoint to revoke one authentication token, ensuring the token can no longer be used with RBAC to access PE services.

```ruby
client.rbac_v2.tokens.delete(
    token: "<TOKEN>"
)
# => {}
```

### POST /auth/token/authenticate

[Reference](https://help.puppet.com/pe/current/topics/rbac_api_v2_auth_token_auth_post.htm)

Use this endpoint to exchange a token for a map representing an RBAC subject and associated token data.

```ruby
client.rbac_v2.tokens.authenticate(
    "<TOKEN>",
    update_last_activity: false
)
# => {
#  "description" => nil,
#  "creation" => "YYYY-MM-DDT22:24:30Z",
#  "email" => "franz@kafka.com",
#  "is_revoked" => false,
#  "last_active" => "YYYY-MM-DDT22:24:31Z",
#  "last_login" => "YYYY-MM-DDT22:24:31.340Z",
#  "expiration" => "YYYY-MM-DDT22:29:30Z",
#  "is_remote" => false,
#  "client" => nil,
#  "login" => "franz@kafka.com",
#  "is_superuser" => false,
#  "label" => nil,
#  "id" => "c84bae61-f668-4a18-9a4a-5e33a97b716c",
#  "role_ids" => [1, 2, 3],
#  "user_id" => "c84bae61-f668-4a18-9a4a-5e33a97b716c",
#  "timeout" => nil,
#  "display_name" => "Franz Kafka",
#  "is_group" => false
# }
```

## LDAP Endpoints

Use the v2 ldap endpoints to get information about your LDAP directory service connections.

### GET /ldap

[Reference](https://help.puppet.com/pe/current/topics/rbac-api-v2-ldap-get-ldap.htm)

Get details of configured LDAP connections.

```ruby
client.rbac_v2.ldap.get
# => [
#   {
#     "help_link" => "",
#     "ssl" => false,
#     "group_name_attr" => "name",
#     "group_rdn" => "ou=groups",
#     "connect_timeout" => 10,
#     "user_display_name_attr" => "*",
#     "disable_ldap_matching_rule_in_chain" => false,
#     "ssl_hostname_validation" => true,
#     "hostname" => "ldap.internal",
#     "base_dn" => "dc=glauth,dc=com",
#     "user_lookup_attr" => "cn",
#     "port" => 3893,
#     "login" => "cn=serviceuser,ou=svcaccts,dc=glauth,dc=com",
#     "group_lookup_attr" => "cn",
#     "group_member_attr" => "uniqueMember",
#     "id" => "e97188aa-9573-413b-945e-07f5f261613e",
#     "ssl_wildcard_validation" => false,
#     "user_email_attr" => "mail",
#     "user_rdn" => "ou=users",
#     "group_object_class" => "groupOfUniqueNames",
#     "display_name" => "ldap.internal",
#     "search_nested_groups" => true,
#     "start_tls" => false
#   }
# ]
```

### GET /ldap/\<id>

[Reference](https://help.puppet.com/pe/current/topics/rbac-api-v2-ldap-get-ldap-id.htm)

Get details of a specific configured LDAP connection.

```ruby
client.rbac_v2.ldap.get(uuid: "e97188aa-9573-413b-945e-07f5f261613e")
# => {
#     "help_link" => "",
#     "ssl" => false,
#     "group_name_attr" => "name",
#     "group_rdn" => "ou=groups",
#     "connect_timeout" => 10,
#     "user_display_name_attr" => "*",
#     "disable_ldap_matching_rule_in_chain" => false,
#     "ssl_hostname_validation" => true,
#     "hostname" => "ldap.internal",
#     "base_dn" => "dc=glauth,dc=com",
#     "user_lookup_attr" => "cn",
#     "port" => 3893,
#     "login" => "cn=serviceuser,ou=svcaccts,dc=glauth,dc=com",
#     "group_lookup_attr" => "cn",
#     "group_member_attr" => "uniqueMember",
#     "id" => "e97188aa-9573-413b-945e-07f5f261613e",
#     "ssl_wildcard_validation" => false,
#     "user_email_attr" => "mail",
#     "user_rdn" => "ou=users",
#     "group_object_class" => "groupOfUniqueNames",
#     "display_name" => "ldap.internal",
#     "search_nested_groups" => true,
#     "start_tls" => false
# }
```

### GET /ds (deprecated)

[Reference](https://help.puppet.com/pe/current/topics/rbac-api-v2-directory-get-ds.htm)

Get information about your directory service.

> [!CAUTION]
> DEPRECATED: Use [GET /ldap](#get-ldap) instead.

```ruby
client.rbac_v2.ldap.ds
# => [
#   {
#     "id" => "6e33eb78-820f-463a-a65c-e1ef291d59a8",
#     "help_link" => "https://help.example.com",
#     "ssl" => true,
#     "group_name_attr" => "name",
#     "group_rdn" => nil,
#     "connect_timeout" => 15,
#     "user_display_name_attr" => "cn",
#     "disable_ldap_matching_rule_in_chain" => false,
#     "ssl_hostname_validation" => true,
#     "hostname" => "ldap.example.com",
#     "base_dn" => "dc=example,dc=com",
#     "user_lookup_attr" => "uid",
#     "port" => 636,
#     "login" => "cn=ldapuser,ou=service,ou=users,dc=example,dc=com",
#     "group_lookup_attr" => "cn",
#     "group_member_attr" => "uniqueMember",
#     "ssl_wildcard_validation" => false,
#     "user_email_attr" => "mail",
#     "user_rdn" => "ou=users",
#     "group_object_class" => "groupOfUniqueNames",
#     "display_name" => "Acme Corp Ldap server",
#     "search_nested_groups" => true,
#     "start_tls" => false
#   }
# ] 
```
