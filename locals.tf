locals {
  avatars_dir = var.avatars_dir == "" ? path.root : var.avatars_dir

  allowed_project_types_json = var.allowed_project_types_json == "" ? "${path.root}/data/allowed_project_types.json" : var.allowed_project_types_json
  allowed_project_types      = jsondecode(try(file(local.allowed_project_types_json), null) == null ? file("${path.module}/data/allowed_project_types.json") : file(local.allowed_project_types_json))

  # Define the allowed project types as a map
  avatar_project = local.allowed_project_types[var.project_type].avatar == "" ? null : "${local.avatars_dir}/${local.allowed_project_types[var.project_type].avatar}"
  avatar_path    = var.avatar == "" ? local.avatar_project : var.avatar
  avatar         = local.avatar_path == null ? null : fileexists(local.avatar_path) ? local.avatar_path : null

  protected_branches = var.protected_branches != null ? var.protected_branches : local.allowed_project_types[var.project_type].protected_branches

  merged_project_variables = merge(
    local.allowed_project_types[var.project_type].ci_variables,
    var.variables,
    {
      PROJECT_TYPE = {
        value             = var.project_type
        description       = "Project Type"
        protected         = false
        masked            = false
        environment_scope = "*"
      }
    }
  )

  approval_rule_usernames = toset(flatten([
    for rule in values(var.approval_rules) : lookup(rule, "usernames", [])
  ]))

  approval_rule_group_paths = toset(flatten([
    for rule in values(var.approval_rules) : lookup(rule, "group_paths", [])
  ]))

  approval_rule_user_ids  = { for username, data in data.gitlab_user.approval_rule_users : username => data.id }
  approval_rule_group_ids = { for path, data in data.gitlab_group.approval_rule_groups : path => data.id }

  ci_schedules = {
    for schedule in var.ci_schedules : schedule.name => {
      description   = schedule.description
      ref           = startswith(schedule.ref, "refs/") ? schedule.ref : "refs/heads/${schedule.ref}"
      cron          = schedule.cron
      cron_timezone = coalesce(lookup(schedule, "cron_timezone", null), "UTC")
      active        = coalesce(lookup(schedule, "active", null), true)
      variables     = coalesce(lookup(schedule, "variables", null), {})
    }
  }

  ci_schedule_variables = flatten([
    for schedule_name, schedule in local.ci_schedules : [
      for variable_key, variable in schedule.variables : {
        schedule_name = schedule_name
        key           = variable_key
        variable      = variable
      }
    ]
  ])

  merged_protected_tags = merge(
    lookup(local.allowed_project_types[var.project_type], "protected_tags", {}),
    var.protected_tags
  )
}
