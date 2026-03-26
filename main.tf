resource "gitlab_project" "project" {
  name                                             = var.name
  description                                      = var.description
  archived                                         = var.archived
  namespace_id                                     = data.gitlab_group.parent.id
  initialize_with_readme                           = true
  default_branch                                   = var.default_branch == "" ? null : var.default_branch
  topics                                           = toset(concat(local.allowed_project_types[var.project_type].tags, var.tags))
  ci_config_path                                   = var.gitlab_ci_path == null ? local.allowed_project_types[var.project_type].gitlab_ci_path : var.gitlab_ci_path
  visibility_level                                 = var.visibility
  build_git_strategy                               = var.build_git_strategy
  autoclose_referenced_issues                      = var.autoclose_referenced_issues
  avatar                                           = local.avatar == null ? null : local.avatar
  avatar_hash                                      = local.avatar == null ? null : filesha256(local.avatar)
  only_allow_merge_if_all_discussions_are_resolved = true
  only_allow_merge_if_pipeline_succeeds            = var.only_allow_merge_if_pipeline_succeeds
  allow_merge_on_skipped_pipeline                  = var.allow_merge_on_skipped_pipeline
  ci_push_repository_for_job_token_allowed         = true

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [archived]
  }
}

resource "gitlab_project_push_rules" "push_rule" {
  count = var.is_gitlab_free == true ? 0 : 1

  project              = gitlab_project.project.id
  commit_message_regex = var.is_enable_conventional_commits_push_rule == true ? "^(build|chore|ci|docs|params|feat|fix|perf|refactor|style|test|revert|merge|release|hotfix|fixup|squash|wip|BREAKING CHANGE)(\\(.+\\))?: .+" : ""
}

resource "gitlab_project_label" "label" {
  for_each = var.labels

  project     = gitlab_project.project.id
  name        = each.key
  description = each.value.description
  color       = each.value.color
}

## Protected Branches
resource "gitlab_branch_protection" "protected_branches" {
  for_each = local.protected_branches

  project            = gitlab_project.project.id
  branch             = each.key
  push_access_level  = each.value.push_access_level
  merge_access_level = each.value.merge_access_level
  allow_force_push   = lookup(each.value, "allow_force_push", false)
}

resource "gitlab_project_approval_rule" "approval_rule" {
  for_each = var.is_gitlab_free ? {} : var.approval_rules

  project            = gitlab_project.project.id
  name               = each.key
  approvals_required = each.value.approvals_required
  user_ids = length(lookup(each.value, "usernames", [])) > 0 ? [
    for username in lookup(each.value, "usernames", []) : local.approval_rule_user_ids[username]
  ] : lookup(each.value, "user_ids", [])

  group_ids = length(lookup(each.value, "group_paths", [])) > 0 ? [
    for path in lookup(each.value, "group_paths", []) : local.approval_rule_group_ids[path]
  ] : lookup(each.value, "group_ids", [])
  protected_branch_ids = [
    for branch in lookup(each.value, "protected_branches", []) : gitlab_branch_protection.protected_branches[branch].branch_protection_id
  ]
}

## Protected Tags
resource "gitlab_tag_protection" "protected_tags" {
  for_each = var.protected_tags

  project             = gitlab_project.project.id
  tag                 = each.key
  create_access_level = each.value.create_access_level
}

resource "gitlab_project_environment" "environment" {
  for_each = var.environments

  project              = gitlab_project.project.id
  name                 = each.key
  description          = lookup(each.value, "description", null)
  auto_stop_setting    = lookup(each.value, "auto_stop_setting", null)
  external_url         = lookup(each.value, "external_url", null)
  kubernetes_namespace = lookup(each.value, "kubernetes_namespace", null)
  tier                 = lookup(each.value, "tier", null)
  stop_before_destroy  = lookup(each.value, "stop_before_destroy", false)
}

resource "gitlab_project_variable" "variable" {
  for_each = local.merged_project_variables

  project           = gitlab_project.project.id
  key               = each.key
  value             = each.value.value
  description       = lookup(each.value, "description", null)
  protected         = lookup(each.value, "protected", false)
  masked            = lookup(each.value, "masked", false)
  environment_scope = lookup(each.value, "environment_scope", "*")
}

resource "gitlab_pipeline_schedule" "ci_schedule" {
  for_each = local.ci_schedules

  project       = gitlab_project.project.id
  description   = each.value.description
  ref           = each.value.ref
  cron          = each.value.cron
  cron_timezone = each.value.cron_timezone
  active        = each.value.active
}

resource "gitlab_pipeline_schedule_variable" "ci_schedule_variable" {
  for_each = { for variable in local.ci_schedule_variables : "${variable.schedule_name}:${variable.key}" => variable }

  project              = gitlab_project.project.id
  pipeline_schedule_id = tonumber(element(split(":", gitlab_pipeline_schedule.ci_schedule[each.value.schedule_name].id), 1))
  key                  = each.value.key
  value                = each.value.variable.value
  variable_type        = lookup(each.value.variable, "variable_type", "env_var")
}

resource "gitlab_project_mirror" "mirror" {
  count                   = var.mirror_url != "" ? 1 : 0
  project                 = gitlab_project.project.id
  url                     = var.mirror_url
  only_protected_branches = var.mirror_only_protected_branches
  mirror_branch_regex     = var.mirror_branch_regex == "" ? null : var.mirror_branch_regex
}
