data "gitlab_group" "parent" {
  full_path = var.parent_group
}

data "gitlab_user" "approval_rule_users" {
  for_each = local.approval_rule_usernames

  username = each.key
}

data "gitlab_group" "approval_rule_groups" {
  for_each = local.approval_rule_group_paths

  full_path = each.key
}
