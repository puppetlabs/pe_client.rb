# RBAC Service v1 API

[The RBAC Service v1 API](https://help.puppet.com/pe/current/topics/rbac_api_v1.htm) is useful for:

- Managing access to PE.
- Connecting to external directories.
- Generating authentication tokens.
- Managing users, user roles, user groups, and user permissions.

Communicates with Puppet Enterprise on port 4433.

## Users Endpoints

With role-based access control (RBAC), you can manage local users and remote users (created on a directory service).
Use the users endpoints to get lists of users, create local users, and delete, revoke, and reinstate users in PE.

### GET /users

[Reference](https://help.puppet.com/pe/current/topics/rbac_api_v1_user_get_users.htm)

Get a list of all local and remote users.

```ruby
client.rbac_v1.users.get
# => [{
#   "id" => "fe62d770-5886-11e4-8ed6-0800200c9a66",
#   "login" => "Kalo",
#   "email" => "kalohill@example.com",
#   "display_name" => "Kalo Hill",
#   "role_ids" => [1, 2, 3],
#   "is_group" => false,
#   "is_remote" => false,
#   "is_superuser" => true,
#   "is_revoked" => false,
#   "last_login" => "2014-05-04T02:32:00Z"
# },{
#   "id" => "07d9c8e0-5887-11e4-8ed6-0800200c9a66",
#   "login" => "Jean",
#   "email" => "jeanjackson@example.com",
#   "display_name" => "Jean Jackson",
#   "role_ids" => [2, 3],
#   "inherited_role_ids" => [5],
#   "is_group" => false,
#   "is_remote" => true,
#   "is_superuser" => false,
#   "group_ids" => ["2ca57e30-5887-11e4-8ed6-0800200c9a66"],
#   "is_revoked" => false,
#   "last_login" => "2014-05-04T02:32:00Z"
# },{
#   "id" => "1cadd0e0-5887-11e4-8ed6-0800200c9a66",
#   "login" => "Amari",
#   "email" => "amariperez@example.com",
#   "display_name" => "Amari Perez",
#   "role_ids" => [2, 3],
#   "inherited_role_ids" => [5],
#   "is_group" => false,
#   "is_remote" => true,
#   "is_superuser" => false,
#   "group_ids" => ["2ca57e30-5887-11e4-8ed6-0800200c9a66"],
#   "is_revoked" => false,
#   "last_login" => "2014-05-04T02:32:00Z"
# }]
```

### GET /users/\<sid>

[Reference](https://help.puppet.com/pe/current/topics/rbac_api_v1_user_get_users_name.htm)

Get details for a specific user.

```ruby
client.rbac_v1.users.get("fe62d770-5886-11e4-8ed6-0800200c9a66")
# => {
#   "id" => "fe62d770-5886-11e4-8ed6-0800200c9a66",
#   "login" => "Kalo",
#   "email" => "kalohill@example.com",
#   "display_name" => "Kalo Hill",
#   "role_ids" => [1, 2, 3],
#   "is_group" => false,
#   "is_remote" => false,
#   "is_superuser" => true,
#   "is_revoked" => false,
#   "last_login" => "2014-05-04T02:32:00Z"
# }
```

### GET /users/current

[Reference](https://help.puppet.com/pe/current/topics/rbac_api_v1_user_get_users_current.htm)

Get information about the current authenticated user.

```ruby
client.rbac_v1.users.current
# => {
#   "id" => "fe62d770-5886-11e4-8ed6-0800200c9a66",
#   "login" => "Kalo",
#   "email" => "kalohill@example.com",
#   "display_name" => "Kalo Hill",
#   "role_ids" => [1, 2, 3],
#   "is_group" => false,
#   "is_remote" => false,
#   "is_superuser" => true,
#   "is_revoked" => false,
#   "last_login" => "2014-05-04T02:32:00Z"
# }
```

### GET /users/\<sid>/tokens

[Reference](https://help.puppet.com/pe/current/topics/rbac-api-v1-users-user-id-tokens.htm)

Get a list of tokens for a user.

```ruby
client.rbac_v1.users.tokens(
    "fe62d770-5886-11e4-8ed6-0800200c9a66",
    limit: 20,
    offset: 0,
    order_by: "creation_date",
    order: "asc"
)
# => {
#  "items" => [{
#       "id" => "d46b06b3-eb89-4146-900f-303a0aa2cfbe"
#       "creation_date" => "2026-04-09T01:40:09Z",
#       "expiration_date" =>  "2027-04-09T01:40:09Z",
#       "last_active_date" => "2026-04-16T05:26:28Z",
#       "client" =>  "",
#       "description" => "",
#       "session_timeout" => nil,
#       "label" => ""
#    }, ... 
#  ],
#  "pagination" => {
#       "limit" => 20,
#       "offset" => 0,
#       "order_by" => "creation_date",
#       "order" => "asc",
#       "total" => 25
#    }
# }
```

### POST /users

[Reference](https://help.puppet.com/pe/current/topics/rbac_api_v1_user_post_users.htm)

Create a local user.

```ruby
client.rbac_v1.users.create(
    login: "Kalo",
    email: "kalohill@example.com", 
    display_name: "Kalo Hill",
    role_ids: [1123,6643,1218],
    password: "Welc0me!"
)
# => {}
```

### PUT /users/\<sid>

[Reference](https://help.puppet.com/pe/current/topics/rbac_api_v1_user_put_users_name.htm)

Edit a local user.

```ruby
client.rbac_v1.users.edit(
    "c97c716a-5f42-49d8-b5a4-d0888a879d21",
    {
        login: "replace-test",
        email: "replace-test@example.com",
        display_name: "Replaced User",
    }
)
# => {
#     "email" => "replace-test@example.com",
#     "is_revoked" => false,
#     "last_login" => nil,
#     "is_remote" => false,
#     "login" => "replace-test",
#     "is_superuser" => false,
#     "id" => "c97c716a-5f42-49d8-b5a4-d0888a879d21",
#     "role_ids" => [],
#     "display_name" => "Replaced User",
#     "is_group" => false
# }
```

### DELETE /users/\<sid>

[Reference](https://help.puppet.com/pe/current/topics/rbac_api_v1_user_delete_users_name.htm)

Delete a user from the PE console.

```ruby
client.rbac_v1.users.delete("76351f96-3d89-4947-bde9-bc3d86542839")
# => {}
```

### POST /command/users/add-roles

[Reference](https://help.puppet.com/pe/current/topics/rbac-api-v1-post-command-users-add-roles.htm)

Assign roles to a user.

```ruby
client.rbac_v1.users.add_roles(
    "76351f96-3d89-4947-bde9-bc3d86542839",
    [1,2,3]
)
# => {}
```

### POST /command/users/remove-roles

[Reference](https://help.puppet.com/pe/current/topics/rbac-api-v1-post-command-users-remove-roles.htm)

Remove roles from a user.

```ruby
client.rbac_v1.users.remove_roles(
    "76351f96-3d89-4947-bde9-bc3d86542839",
    [1,2,3]
)
# => {}
```

### POST /command/users/revoke

[Reference](https://help.puppet.com/pe/current/topics/rbac-api-v1-post-command-users-revoke.htm)

Revoke a user's PE access.

```ruby
client.rbac_v1.users.revoke("76351f96-3d89-4947-bde9-bc3d86542839")
# => {}
```

### POST /command/users/reinstate

[Reference](https://help.puppet.com/pe/current/topics/rbac-api-v1-post-command-users-reinstate.htm)

Reinstate a revoked user.

```ruby
client.rbac_v1.users.reinstate("76351f96-3d89-4947-bde9-bc3d86542839")
# => {}
```

## User Groups Endpoints

User groups allow you to quickly assign one or more roles to a set of users by placing all relevant users in the group.
This is more efficient than assigning roles to each user individually.
Use the groups endpoints to get lists of groups and add, delete, and change groups.

### GET /groups

[Reference](https://help.puppet.com/pe/current/topics/rbac_api_v1_user_group_get_groups.htm)

Fetch information about all user groups.

```ruby
client.rbac_v1.groups.get
# => [{
#   "id" => "65a068a0-588a-11e4-8ed6-0800200c9a66",
#   "login" => "admins",
#   "display_name" => "Admins",
#   "role_ids" => [2, 3],
#   "is_group" => true,
#   "is_remote" => true,
#   "is_superuser" => false,
#   "user_ids" => ["07d9c8e0-5887-11e4-8ed6-0800200c9a66"]}
# },{
#   "id" => "75370a30-588a-11e4-8ed6-0800200c9a66",
#   "login" => "owners",
#   "display_name" => "Owners",
#   "role_ids" => [2, 1],
#   "is_group" => true,
#   "is_remote" => true,
#   "is_superuser" => false,
#   "user_ids" => ["1cadd0e0-5887-11e4-8ed6-0800200c9a66","5c1ab4b0-588b-11e4-8ed6-0800200c9a66"]
# },{
#   "id" => "ccdbde50-588a-11e4-8ed6-0800200c9a66",
#   "login" => "viewers",
#   "display_name" => "Viewers",
#   "role_ids" => [2, 3],
#   "is_group" => true,
#   "is_remote" => true,
#   "is_superuser" => false,
#   "user_ids" => []
# }]
```

### GET /groups/\<sid>

[Reference](https://help.puppet.com/pe/current/topics/rbac_api_v1_user_group_get_groups_name.htm)

Fetch information about that specific group.

```ruby
client.rbac_v1.groups.get("65a068a0-588a-11e4-8ed6-0800200c9a66")
# => {
#   "id" => "65a068a0-588a-11e4-8ed6-0800200c9a66",
#   "login" => "admins",
#   "display_name" => "Admins",
#   "role_ids" => [2, 3],
#   "is_group" => true,
#   "is_remote" => true,
#   "is_superuser" => false,
#   "user_ids" => ["07d9c8e0-5887-11e4-8ed6-0800200c9a66"]}
# }
```

### POST /command/groups/create

[Reference](https://help.puppet.com/pe/current/topics/rbac-api-v1-post-command-groups-create.htm)

Create a remote directory user group.

```ruby
client.rbac_v1.groups.create(
    login: "augmentators",
    role_ids: [1,2,3],
    display_name: "The Augmentators",
    identity_provider_id: "0e1a11bd-658f-11e4-8ed6-0800200c9a66"
)
# => {}
```

### PUT /groups/\<sid>

[Reference](https://help.puppet.com/pe/current/topics/rbac_api_v1_user_group_put_groups_name.htm)

Edit the content of the specified user group object.
For example, you can update the group's roles or membership.

```ruby
client.rbac_v1.groups.edit(
    "65a068a0-588a-11e4-8ed6-0800200c9a66",
    {
        login: "admins",
        display_name: "Admins",
        role_ids: [2,1],
        is_group: true,
        is_remote: true,
        is_superuser: false,
        user_ids: ["1cadd0e0-5887-11e4-8ed6-0800200c9a66","5c1ab4b0-588b-11e4-8ed6-0800200c9a66"]
    }
)
# => {
#   "id" => "65a068a0-588a-11e4-8ed6-0800200c9a66",
#   "login" => "admins",
#   "display_name" => "Admins",
#   "role_ids" => [2, 1],
#   "is_group" => true,
#   "is_remote" => true,
#   "is_superuser" => false,
#   "user_ids" => ["1cadd0e0-5887-11e4-8ed6-0800200c9a66","5c1ab40-588b-11e4-8ed6-0800200c9a66"]
# }
```

### DELETE /groups/\<sid>

[Reference](https://help.puppet.com/pe/current/topics/rbac_api_v1_user_group_delete_groups_name.htm)

Deletes the user group with the specified ID from PE RBAC.
This endpoint does not change the directory service.

```ruby
client.rbac_v1.groups.delete("65a068a0-588a-11e4-8ed6-0800200c9a66")
# => {}
```

### POST /groups (deprecated)

> [!CAUTION]
> DEPRECATED: Use [POST /command/groups/create](#post-commandgroupscreate) instead.

[Reference](https://help.puppet.com/pe/current/topics/rbac_api_v1_user_group_post_groups.htm)

Creates a new remote directory user group.

```ruby
client.rbac_v1.groups.create_deprecated(
    "augmentators",
    [1,2]
)
# => {}
```

## User Roles Endpoints

User roles contain sets of permissions.
When you assign a user (or a user group) to a role, you can assign the entire set of permissions at once.
This is more organized and easier to manage than assigning individual permissions to individual users.

### GET /roles

[Reference](https://help.puppet.com/pe/current/topics/rbac_api_v1_user_role_get_roles.htm)

Fetches information about all user roles.

```ruby
client.rbac_v1.roles.get
# =>
# [
#   {
#     "id" => 123,
#     "permissions" => [{"object_type"=>"node_groups",
#                        "action"=>"edit_rules",
#                        "instance"=>"*"}],
#     "user_ids" => ["1cadd0e0-5887-11e4-8ed6-0800200c9a66","5c1ab4b0-588b-11e4-8ed6-0800200c9a66"],
#     "group_ids" => ["2ca57e30-5887-11e4-8ed6-0800200c9a66"],
#     "display_name" => "A role",
#     "description" => "Edit node group rules"
#   }
# ]
```

### GET /roles/\<rid>

[Reference](https://help.puppet.com/pe/current/topics/rbac_api_v1_user_role_get_roles_name.htm)

Fetches information about a specific user role.

```ruby
client.rbac_v1.roles.get(123)
# =>
# {
#   "id" => 123,
#   "permissions" => [{"object_type"=>"node_groups",
#                      "action"=>"edit_rules",
#                      "instance"=>"*"}],
#   "user_ids" => ["1cadd0e0-5887-11e4-8ed6-0800200c9a66","5c1ab4b0-588b-11e4-8ed6-0800200c9a66"],
#   "group_ids" => ["2ca57e30-5887-11e4-8ed6-0800200c9a66"],
#   "display_name" => "A role",
#   "description" => "Edit node group rules"
# }
```

### POST /roles

[Reference](https://help.puppet.com/pe/current/topics/rbac_api_v1_user_role_post_roles.htm)

Create a role.

```ruby
client.rbac_v1.roles.create(
    permissions: [{object_type:"node_groups", action:"edit_rules", instance:"*"}],
    user_ids: ["1cadd0e0-5887-11e4-8ed6-0800200c9a66", "5c1ab4b0-588b-11e4-8ed6-0800200c9a66"],
    group_ids: ["2ca57e30-5887-11e4-8ed6-0800200c9a66"],
    display_name: "A role",
    description: "Edit node group rules"
)
# => {}
```

### PUT /roles/\<rid>

[Reference](https://help.puppet.com/pe/current/topics/rbac_api_v1_user_role_put_roles.htm)

Replaces the content of the specified role object.
For example, you can update the role's permissions or user membership.

```ruby
client.rbac_v1.roles.edit(
    "123",
    {
        permissions: [{object_type:"node_groups", action:"edit_rules", instance:"*"}],
        user_ids: ["1cadd0e0-5887-11e4-8ed6-0800200c9a66", "5c1ab4b0-588b-11e4-8ed6-0800200c9a66"],
        group_ids: ["2ca57e30-5887-11e4-8ed6-0800200c9a66"],
        display_name: "A role",
        description: "Edit node group rules"
    }
)
# => {
#   "id" => "123",
#   "permissions" => [{"object_type"=>"node_groups", "action"=>"edit_rules", "instance"=>"*"}],
#   "user_ids" => ["1cadd0e0-5887-11e4-8ed6-0800200c9a66", "5c1ab4b0-588b-11e4-8ed6-0800200c9a66"],
#   "group_ids" => ["2ca57e30-5887-11e4-8ed6-0800200c9a66"],
#   "display_name" => "A role",
#   "description" => "Edit node group rules"
# }
```

### DELETE /roles/\<rid>

[Reference](https://help.puppet.com/pe/current/topics/rbac_api_v1_user_role_delete_roles.htm)

Deletes the role with the specified role ID.
Users who had this role (either directly or through a user group) immediately lose the role and all permissions granted by it, but their session is otherwise unaffected.
The next action the user takes in PE is determined by their permissions without the deleted role.

```ruby
client.rbac_v1.roles.delete("123")
# => {}
```

### POST /command/roles/add-users

[Reference](https://help.puppet.com/pe/current/topics/rbac-api-v1-user-roles-command-add-users.htm)

Assign a role to one or more users.

```ruby
client.rbac_v1.roles.add_users(
    "123",
    ["1cadd0e0-5887-11e4-8ed6-0800200c9a66", "5c1ab4b0-588b-11e4-8ed6-0800200c9a66"]
)
# => {}
```

### POST /command/roles/remove-users

[Reference](https://help.puppet.com/pe/current/topics/rbac-api-v1-user-roles-command-remove-users.htm)

Remove a role from one or more users.

```ruby
client.rbac_v1.roles.remove_users(
    "123",
    ["1cadd0e0-5887-11e4-8ed6-0800200c9a66", "5c1ab4b0-588b-11e4-8ed6-0800200c9a66"]
)
# => {}
```

### POST /command/roles/add-groups

[Reference](https://help.puppet.com/pe/current/topics/rbac-api-v1-post-command-roles-add-user-groups.htm)

Add a role to one or more user groups.

```ruby
client.rbac_v1.roles.add_groups(
    "123",
    ["2ca57e30-5887-11e4-8ed6-0800200c9a66"]
)
# => {}
```

### POST /command/roles/remove-groups

[Reference](https://help.puppet.com/pe/current/topics/rbac-api-v1-post-command-roles-remove-groups.htm)

Remove a role from one or more user groups.

```ruby
client.rbac_v1.roles.remove_groups(
    "123",
    ["2ca57e30-5887-11e4-8ed6-0800200c9a66"]
)
# => {}
```

### POST /command/roles/add-permissions

[Reference](https://help.puppet.com/pe/current/topics/rbac-api-v1-user-roles-command-add-permissions.htm)

Add permissions to a role.

```ruby
client.rbac_v1.roles.add_permissions(
    "123",
    [{object_type:"node_groups", action:"edit_rules", instance:"*"}]
)
# => {}
```

### POST /command/roles/remove-permissions

[Reference](https://help.puppet.com/pe/current/topics/rbac-api-v1-user-roles-command-remove-permissions.htm)

Remove permissions from a role.

```ruby
client.rbac_v1.roles.remove_permissions(
    "123",
    [{object_type:"node_groups", action:"edit_rules", instance:"*"}]
)
# => {}
```

## Permissions Endpoints

You add permissions to roles to control what users can access and do in PE.
Use the permissions endpoints to get information about objects you can create permissions for, what types of permissions you can create, and whether specific users can perform certain actions.

### GET /types

[Reference](https://help.puppet.com/pe/current/topics/rbac_api_v1_permissions_get_types.htm)

Lists each object_type that you can regulate with RBAC permissions, the available actions for each type, and whether each action allows instance specification.

```ruby
client.rbac_v1.permissions.types
# =>
# [{ "object_type" => "node_groups",
#    "display_name" => "Node Groups",
#    "description" => "Groups that nodes can be assigned to."
#    "actions" => [{ "name" => "view",
#                  "display_name" => "View",
#                  "description" => "View the node groups",
#                  "has_instances" => true
#                 },{
#                  "name" => "modify",
#                  "display_name" => "Configure",
#                  "description" => "Modify description, variables and classes",
#                  "has_instances" => true
#                 }]
# }]
```

### POST /permitted

[Reference](https://help.puppet.com/pe/current/topics/rbac_api_v1_permissions_post_permitted.htm)

Query whether a user or user group can perform specified actions.
Use this to check if a user or group already has a certain permission.

```ruby
client.rbac_v1.permissions.permitted(
    token: "d46b06b3-eb89-4146-900f-303a0aa2cfbe",
    permissions: [
        {
            "object_type" => "node_groups",
            "action" => "edit_rules",
            "instance" => "132acd70-5886-11e4-8ed6-0800200c9a66"
        }
    ]
)
# => [true]
```

### GET /permitted/\<object-type>/\<action>

[Reference](https://help.puppet.com/pe/current/topics/rbac_api_v1_permissions_get_permitted_object_action.htm)

For a specific object_type and action, get a list of instance IDs that the current authenticated user is permitted to take the specified action on.

```ruby
client.rbac_v1.permissions.instances(
    object_type: "node_groups",
    action: "edit_rules"
)
# => ["00000000-0000-4000-8000-000000000000"]
```

### GET /permitted/\<object-type>/\<action>/\<uuid>

[Reference](https://help.puppet.com/pe/current/topics/rbac_api_v1_permissions_get_permitted_object_action_uuid.htm)

For a specific object_type and action, get a list of instance IDs that the specific user (identified by UUID) is permitted to take the specified action on.

```ruby
client.rbac_v1.permissions.user_instances(
    object_type: "node_groups",
    action: "edit_rules",
    uuid: "fe62d770-5886-11e4-8ed6-0800200c9a66"
)
# => ["00000000-0000-4000-8000-000000000000"]
```

## Tokens Endpoints

Authentication tokens control access to PE services.
Use the auth/token and tokens endpoints to create tokens.

### POST /auth/token

[Reference](https://help.puppet.com/pe/current/topics/rbac_api_v1_token_post_auth.htm)

Generate an authorization token for a user identified by login and password.
This token can be used to authenticate requests to Puppet Enterprise (PE) services, such as by using an X-Authentication header or a token query parameter in an API request.

```ruby
client.rbac_v1.tokens.generate(
    login: "Kalo",
    password: "Welc0me!",
    lifetime: "1y",
    label: "Kalo's API client token"
)
# => {"token" => "0QX-WR3kgP0R9C2dA0I2nfnp0QgAT95_xH3iylBhqroA"}
```

### POST /tokens

[Reference](https://help.puppet.com/pe/current/topics/rbac-api-v1-tokens-post.htm)

Create a token for the authenticated user.
Doesn't allow certificate authentication.

```ruby
client.rbac_v1.tokens.create(
    lifetime: "1y",
    label: "Kalo's API client token"
)
# => {"token" => "0QX-WR3kgP0R9C2dA0I2nfnp0QgAT95_xH3iylBhqroA"}
```

## LDAP Endpoints

Use the LDAP endpoints to test and configure LDAP directory service connections.

### POST /command/ldap/create

[Reference](https://help.puppet.com/pe/current/topics/rbac-api-v1-post-command-ldap-create.htm)

Configure a new LDAP connection.

```ruby
client.rbac_v1.ldap.create(
    {
        help_link: "https://example.com/login-help.html",
        ssl: true,
        group_name_attr: "name",
        group_rdn: nil,
        connect_timeout: 15,
        user_display_name_attr: "cn",
        disable_ldap_matching_rule_in_chain: false,
        ssl_hostname_validation: true,
        hostname: "ldap.example.com",
        base_dn: "dc=example,dc=com",
        user_lookup_attr: "uid",
        port: 636,
        login: "cn=pe-orch,ou=service,ou=users,dc=example,dc=com",
        group_lookup_attr: "cn",
        group_member_attr: "uniqueMember",
        ssl_wildcard_validation: false,
        user_email_attr: "mail",
        user_rdn: "ou=users",
        group_object_class: "groupOfUniqueNames",
        display_name: "ldap.example.com",
        search_nested_groups: true,
        start_tls: false
    }
)
# => {"id" => "e97188aa-9573-413b-945e-07f5f261613e"}
```

### POST /command/ldap/update

[Reference](https://help.puppet.com/pe/current/topics/rbac-api-v1-post-command-ldap-update.htm)

Replace an existing directory service connection's settings.

```ruby
client.rbac_v1.ldap.update(
    {
        help_link: "https://example.com/login-help.html",
        ssl: true,
        group_name_attr: "name",
        group_rdn: nil,
        connect_timeout: 15,
        user_display_name_attr: "cn",
        disable_ldap_matching_rule_in_chain: false,
        ssl_hostname_validation: true,
        hostname: "ldap.example.com",
        base_dn: "dc=example,dc=com",
        user_lookup_attr: "uid",
        port: 636,
        login: "cn=pe-orch,ou=service,ou=users,dc=example,dc=com",
        group_lookup_attr: "cn",
        group_member_attr: "uniqueMember",
        ssl_wildcard_validation: false,
        user_email_attr: "mail",
        user_rdn: "ou=users",
        group_object_class: "groupOfUniqueNames",
        display_name: "ldap.example.com",
        search_nested_groups: true,
        start_tls: false
    }
)
# => {
#   "id" => "e97188aa-9573-413b-945e-07f5f261613e",
#   "help_link" => "https://example.com/login-help.html",
#   "ssl" => true,
#   "group_name_attr" => "name",
#   "group_rdn" => nil,
#   "connect_timeout" => 15,
#   "user_display_name_attr" => "cn",
#   "disable_ldap_matching_rule_in_chain" => false,
#   "ssl_hostname_validation" => true,
#   "hostname" => "ldap.example.com",
#   "base_dn" => "dc=example,dc=com",
#   "user_lookup_attr" => "uid",
#   "port" => 636,
#   "login" => "cn=pe-orch,ou=service,ou=users,dc=example,dc=com",
#   "group_lookup_attr" => "cn",
#   "group_member_attr" => "uniqueMember",
#   "ssl_wildcard_validation" => false,
#   "user_email_attr" => "mail",
#   "user_rdn" => "ou=users",
#   "group_object_class" => "groupOfUniqueNames",
#   "display_name" => "ldap.example.com",
#   "search_nested_groups" => true,
#   "start_tls" => false
# }
```

### POST /command/ldap/delete

[Reference](https://help.puppet.com/pe/current/topics/rbac-api-v1-post-command-ldap-delete.htm)

Delete an existing directory service connection.

```ruby
client.rbac_v1.ldap.delete("e97188aa-9573-413b-945e-07f5f261613e")
# => {}
```

### POST /command/ldap/test

[Reference](https://help.puppet.com/pe/current/topics/rbac-api-v1-post-command-ldap-test.htm)

Test a directory service connection based on supplied settings.

```ruby
client.rbac_v1.ldap.test(
    {
        help_link: "https://example.com/login-help.html",
        ssl: true,
        group_name_attr: "name",
        group_rdn: nil,
        connect_timeout: 15,
        user_display_name_attr: "cn",
        disable_ldap_matching_rule_in_chain: false,
        ssl_hostname_validation: true,
        hostname: "ldap.example.com",
        base_dn: "dc=example,dc=com",
        user_lookup_attr: "uid",
        port: 636,
        login: "cn=pe-orch,ou=service,ou=users,dc=example,dc=com",
        group_lookup_attr: "cn",
        group_member_attr: "uniqueMember",
        ssl_wildcard_validation: false,
        user_email_attr: "mail",
        user_rdn: "ou=users",
        group_object_class: "groupOfUniqueNames",
        display_name: "ldap.example.com",
        search_nested_groups: true,
        start_tls: false
    }
)
# => {"elapsed" => 10}
```

### GET /ds/test (deprecated)

> [!CAUTION]
> DEPRECATED: Use [POST /command/ldap/test](#post-commandldaptest) instead.

[Reference](https://help.puppet.com/pe/current/topics/rbac_api_v1_directory_get_ds_test.htm)

Test a directory service connection based on supplied settings.

```ruby
client.rbac_v1.ldap.ds_test
# => {
#   help_link => "https://help.example.com",
#   "ssl" => true,
#   "group_name_attr" => "name",
#   "password" => "<password>",
#   "group_rdn" => nil,
#   "connect_timeout" => 15,
#   "user_display_name_attr" => "cn",
#   "disable_ldap_matching_rule_in_chain" => false,
#   "ssl_hostname_validation" => true,
#   "hostname" => "ldap.example.com",
#   "base_dn" => "dc=example,dc=com",
#   "user_lookup_attr" => "uid",
#   "port" => 636,
#   "login" => "cn=ldapuser,ou=service,ou=users,dc=example,dc=com",
#   "group_lookup_attr" => "cn",
#   "group_member_attr" => "uniqueMember",
#   "ssl_wildcard_validation" => false,
#   "user_email_attr" => "mail",
#   "user_rdn" => "ou=users",
#   "group_object_class" => "groupOfUniqueNames",
#   "display_name" => "Acme Corp Ldap server",
#   "search_nested_groups" => true,
#   "start_tls" => false
# }
```

### PUT /ds/test (deprecated)

> [!CAUTION]
> DEPRECATED: Use [POST /command/ldap/test](#post-commandldaptest) instead.

[Reference](https://help.puppet.com/pe/current/topics/rbac_api_v1_directory_put_ds_test.htm)

Test the connection to the connected directory service.

```ruby
client.rbac_v1.ldap.ds_test(
    {
        help_link: "https://help.example.com",
        ssl: true,
        group_name_attr: "name",
        password: "<password>",
        group_rdn: nil,
        connect_timeout: 15,
        user_display_name_attr: "cn",
        disable_ldap_matching_rule_in_chain: false,
        ssl_hostname_validation: true,
        hostname: "ldap.example.com",
        base_dn: "dc=example,dc=com",
        user_lookup_attr: "uid",
        port: 636,
        login: "cn=ldapuser,ou=service,ou=users,dc=example,dc=com",
        group_lookup_attr: "cn",
        group_member_attr: "uniqueMember",
        ssl_wildcard_validation: false,
        user_email_attr: "mail",
        user_rdn: "ou=users",
        group_object_class: "groupOfUniqueNames",
        display_name: "Acme Corp Ldap server",
        search_nested_groups: true,
        start_tls: false
    }
)
# => {"elapsed" => 10}
```

### PUT /ds (deprecated)

> [!CAUTION]
> DEPRECATED: Use [POST /command/ldap/create](#post-commandldapcreate), [POST /command/ldap/update](#post-commandldapupdate), and [POST /command/ldap/delete](#post-commandldapdelete) instead.

[Reference](https://help.puppet.com/pe/current/topics/rbac_api_v1_directory_put_ds.htm)

Replace current directory service connection settings.
You can update the settings or disconnect the service (by removing all settings).

```ruby
client.rbac_v1.ldap.ds(
    {
        help_link: "https://help.example.com",
        ssl: true,
        group_name_attr: "name",
        password: "<password>",
        group_rdn: nil,
        connect_timeout: 15,
        user_display_name_attr: "cn",
        disable_ldap_matching_rule_in_chain: false,
        ssl_hostname_validation: true,
        hostname: "ldap.example.com",
        base_dn: "dc=example,dc=com",
        user_lookup_attr: "uid",
        port: 636,
        login: "cn=ldapuser,ou=service,ou=users,dc=example,dc=com",
        group_lookup_attr: "cn",
        group_member_attr: "uniqueMember",
        ssl_wildcard_validation: false,
        user_email_attr: "mail",
        user_rdn: "ou=users",
        group_object_class: "groupOfUniqueNames",
        display_name: "Acme Corp Ldap server",
        search_nested_groups: true,
        start_tls: false
    }
)
# => {
#   help_link => "https://help.example.com",
#   "ssl" => true,
#   "group_name_attr" => "name",
#   "password" => "<password>",
#   "group_rdn" => nil,
#   "connect_timeout" => 15,
#   "user_display_name_attr" => "cn",
#   "disable_ldap_matching_rule_in_chain" => false,
#   "ssl_hostname_validation" => true,
#   "hostname" => "ldap.example.com",
#   "base_dn" => "dc=example,dc=com",
#   "user_lookup_attr" => "uid",
#   "port" => 636,
#   "login" => "cn=ldapuser,ou=service,ou=users,dc=example,dc=com",
#   "group_lookup_attr" => "cn",
#   "group_member_attr" => "uniqueMember",
#   "ssl_wildcard_validation" => false,
#   "user_email_attr" => "mail",
#   "user_rdn" => "ou=users",
#   "group_object_class" => "groupOfUniqueNames",
#   "display_name" => "Acme Corp Ldap server",
#   "search_nested_groups" => true,
#   "start_tls" => false
# }
```

## SAML Endpoints

Use the saml endpoints to configure SAML, retrieve SAML configuration details, and get the public certificate and URLs needed for configuration.

### PUT /saml

[Reference](https://help.puppet.com/pe/current/topics/rbac-api-v1-saml-put-saml.htm)

Use this endpoint to configure SAML.

```ruby
client.rbac_v1.saml.configure(
    {
        display_name: "Corporate Okta",
        idp_sso_url: "https://idp.example.org/SAML2/SSO",
        idp_slo_url: "https://ipd.example.com/SAML2/SLO", 
        idp_certificate: ["MIIGADCCA+igAwIBAgIBAjANBgkqhkiG9w0BAQsFADBqMWgwZgYDVQQDDF9QdXBw"],
        want_messages_signed: true,
        want_assertions_signed: true,
        sign_metadata: true,
        want_assertions_encrypted: true,
        want_name_id_encrypted: true,
        allow_duplicated_attribute_name: true,
        want_xml_validation: true,
        signature_algorithm: "rsa-sha256",
        requested_authn_context_comparison: "exact",
        user_display_name_attr: "test",
        user_lookup_attr: "test_lookup",
        requested_auth_context: "test-request",
        group_lookup_attr: "group_lookup_test",
        user_email_attr: "email_attr", 
        idp_entity_id: "entity_id"
     }
)
# => {
#   "want_xml_validation" => true,
#   "sign_metadata" => true,
#   "requested_authn_context_comparison" => "exact",
#   "want_assertions_encrypted" => true,
#   "want_name_id_encrypted" => true,
#   "want_messages_signed" => true,
#   "signature_algorithm" => "rsa-sha256",
#   "user_display_name_attr" => "test",
#   "want_assertions_signed" => true,
#   "user_lookup_attr" => "test_lookup",
#   "requested_auth_context" => "test-request",
#   "allow_duplicated_attribute_name" => true,
#   "idp_sso_url" => "https://idp.example.org/SAML2/SSO",
#   "group_lookup_attr" => "group_lookup_test",
#   "idp_certificate" => ["MIIGADCCA+igAwIBAgIBAjANBgkqhkiG9w0BAQsFADBqMWgwZgYDVQQDDF9QdXBw"],
#   "user_email_attr" => "email_attr",
#   "display_name" => "Corporate Okta",
#   "idp_entity_id" => "entity_id",
#   "idp_slo_url" => "https://ipd.example.com/SAML2/SLO"
# }
```

### GET /saml

[Reference](https://help.puppet.com/pe/current/topics/rbac-api-v1-saml-get-saml.htm)

Retrieves the current SAML configuration settings.

```ruby
client.rbac_v1.saml.get
# => {
#   "want_xml_validation" => true,
#   "sign_metadata" => true,
#   "requested_authn_context_comparison" => "exact",
#   "want_assertions_encrypted" => true,
#   "want_name_id_encrypted" => true,
#   "want_messages_signed" => true,
#   "signature_algorithm" => "rsa-sha256",
#   "user_display_name_attr" => "test",
#   "want_assertions_signed" => true,
#   "user_lookup_attr" => "test_lookup",
#   "requested_auth_context" => "test-request",
#   "allow_duplicated_attribute_name" => true,
#   "idp_sso_url" => "https://idp.example.org/SAML2/SSO",
#   "group_lookup_attr" => "group_lookup_test",
#   "idp_certificate" => ["MIIGADCCA+igAwIBAgIBAjANBgkqhkiG9w0BAQsFADBqMWgwZgYDVQQDDF9QdXBw"],
#   "user_email_attr" => "email_attr",
#   "display_name" => "Corporate Okta",
#   "idp_entity_id" => "entity_id",
#   "idp_slo_url" => "https://ipd.example.com/SAML2/SLO"
# }
```

### DELETE /saml

[Reference](https://help.puppet.com/pe/current/topics/rbac-api-v1-saml-delete-saml.htm)

Remove the current SAML configuration along with associated user groups and users.

```ruby
client.rbac_v1.saml.delete
# => {}
```

### GET /saml/meta

[Reference](https://help.puppet.com/pe/current/topics/rbac-api-v1-saml-get-saml-meta.htm)

Retrieve the public SAML certificate and URLs you need to configure an identity provider.

```ruby
client.rbac_v1.saml.meta
# => {
#    "meta": "https://localhost/saml/v1/meta",
#    "acs": "https://localhost/saml/v1/acs",
#    "slo": "https://localhost/saml/vi/slo",
#    "cert": "-----BEGIN CERTIFICATE-----\nMIIFo ..."
# }
```

## Passwords Endpoints

When local users forget their Puppet Enterprise (PE) passwords or lock themselves out of PE by attempting to log in with incorrect credentials too many times, you must generate a password reset token for them.
Use the password endpoints to generate password reset tokens, use tokens to reset passwords, change the authenticated user's password, and validate potential user names and passwords.

### POST /users/\<uuid>/password/reset

[Reference](https://help.puppet.com/pe/current/topics/rbac_api_v1_password_post_users.htm)

Generate a single-use, limited-lifetime password reset token for a specific local user.

```ruby
client.rbac_v1.passwords.generate_reset_token("1cadd0e0-5887-11e4-8ed6-0800200c9a66")
# => {"token" => "0QX-WR3kgP0R9C2dA0I2nfnp0QgAT95_xH3iylBhqroA"}
```

### POST /auth/reset

[Reference](https://help.puppet.com/pe/current/topics/rbac_api_v1_password_post_auth.htm)

Use a password reset token to change a local user's password.

```ruby
client.rbac_v1.passwords.reset(
    "0QX-WR3kgP0R9C2dA0I2nfnp0QgAT95_xH3iylBhqroA",
    "N3wP@ssw0rd!"
)
# => {}
```

### PUT /users/current/password

[Reference](https://help.puppet.com/pe/current/topics/rbac_api_v1_password_put_users.htm)

Changes the current authenticated local user's password.

```ruby
client.rbac_v1.passwords.change(
    "CurrentPassword123",
    "N3wP@ssw0rd!"
)
# => {}
```

### POST /command/validate-password

[Reference](https://help.puppet.com/pe/current/topics/rbac-api-v1-post-command-validate-password.htm)

Check whether a password is valid.

```ruby
# Token authenticated request
client.rbac_v1.passwords.validate_password(
    "N3wP@ssw0rd!"
)
# => {"valid" => true}

# Certificate authenticated request
client.rbac_v1.passwords.validate_password(
    "N3wP@ssw0rd!",
    reset_token: "0QX-WR3kgP0R9C2dA0I2nfnp0QgAT95_xH3iylBhqroA"
)
# => {"valid" => true}
```

### POST /command/validate-login

[Reference](https://help.puppet.com/pe/current/topics/rbac-api-v1-post-command-validate-login.htm)

Check whether a user name (login) is valid.

```ruby
client.rbac_v1.passwords.validate_login("Kalo")
# => {"valid" => true}
```

## Disclaimer Endpoints

Use these endpoints to modify the disclaimer text that appears on the Puppet Enterprise (PE) console login page.

### GET /config/disclaimer

[Reference](https://help.puppet.com/pe/current/topics/rbac-api-v1-get-config-disclaimer.htm)

Retrieve the current disclaimer text, as specified by [POST /command/config/set-disclaimer](#post-commandconfigset-disclaimer).
This endpoint does not retrieve the contents of any disclaimer.txt file.

```ruby
client.rbac_v1.disclaimer.get
# {"disclaimer" => "Not to be accessed by unauthorized users"}
```

### POST /command/config/set-disclaimer

[Reference](https://help.puppet.com/pe/current/topics/rbac-api-v1-post-command-config-set-disclaimer.htm)

Change the disclaimer text that is on the PE console login page.

```ruby
client.rbac_v1.disclaimer.set("Not to be accessed by unauthorized users")
# => {}
```

### POST /command/config/remove-disclaimer

[Reference](https://help.puppet.com/pe/current/topics/rbac-api-v1-post-command-config-remove-disclaimer.htm)

Remove the disclaimer text set through [POST /command/config/set-disclaimer](#post-commandconfigset-disclaimer).

```ruby
client.rbac_v1.disclaimer.remove
# => {}
```
