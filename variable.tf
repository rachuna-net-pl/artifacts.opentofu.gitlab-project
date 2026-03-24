variable "name" {
  type        = string
  description = "Repository Name"
}

variable "description" {
  type        = string
  description = "Repository Description"
}

variable "parent_group" {
  type        = string
  description = "Parent Group"
}

variable "default_branch" {
  type        = string
  description = "Default branch"
  default     = ""
}

variable "tags" {
  type        = list(string)
  description = "Tags"
  default     = []
}

variable "visibility" {
  type        = string
  default     = "private"
  description = "The project's visibility"

  validation {
    condition = contains([
      "private",
      "internal",
      "public"
    ], var.visibility)
    error_message = "Unsupported project visibility"
  }
}

variable "build_git_strategy" {
  type        = string
  default     = "clone"
  description = "The Git strategy. Defaults to fetch."
}

variable "autoclose_referenced_issues" {
  type        = bool
  default     = true
  description = "Autoclose referenced issues"
}

variable "allowed_avatar_types_json" {
  type        = string
  default     = ""
  description = "Path to allowed avatar types json"
}

variable "avatar" {
  type        = string
  description = "Path to the avatar .png file (default: derived from project type)"
  default     = ""

  validation {
    condition     = var.avatar == "" || endswith(var.avatar, ".png")
    error_message = "Avatar must be a path to a .png file"
  }
}

variable "allowed_project_types_json" {
  type        = string
  default     = ""
  description = "Path to allowed project types json"
}


variable "project_type" {
  type        = string
  description = "Project type"
  default     = ""

  validation {
    condition     = contains(keys(local.allowed_project_types), var.project_type)
    error_message = "Unsupported project project_type"
  }
}

variable "gitlab_ci_path" {
  type        = string
  description = "Path to the GitLab CI file"
  default     = null
}

variable "ci_schedules" {
  description = "List of GitLab CI pipeline schedules for this project with optional variables."
  type = list(object({
    name          = string
    description   = string
    ref           = string
    cron          = string
    cron_timezone = optional(string)
    active        = optional(bool)
    variables = optional(map(object({
      value         = string
      variable_type = optional(string)
    })))
  }))
  default = []

  validation {
    condition     = length(var.ci_schedules) == length(toset([for schedule in var.ci_schedules : schedule.name]))
    error_message = "CI schedule names must be unique."
  }

  validation {
    condition = alltrue([
      for schedule in var.ci_schedules : alltrue([
        for variable in values(coalesce(lookup(schedule, "variables", null), {})) : contains([
          "env_var",
          "file"
        ], coalesce(lookup(variable, "variable_type", null), "env_var"))
      ])
    ])
    error_message = "CI schedule variable types must be either env_var or file."
  }
}

variable "protected_branches" {
  type = map(object({
    push_access_level  = string
    merge_access_level = string
    allow_force_push   = optional(bool, false)
  }))
  default = {
    "develop" = {
      push_access_level  = "no one"
      merge_access_level = "maintainer"
    }
    "main" = {
      push_access_level  = "no one"
      merge_access_level = "maintainer"
    }
  }
}

variable "labels" {
  type = map(object({
    description = string
    color       = string
  }))
  default = {}
}

variable "protected_tags" {
  type = map(object({
    create_access_level = string
  }))
  description = "Protected tags"
  default = {
    "v*" = {
      create_access_level = "maintainer"
    }
  }
}

variable "environments" {
  type = map(object({
    description          = optional(string)
    auto_stop_setting    = optional(string)
    external_url         = optional(string)
    kubernetes_namespace = optional(string)
    tier                 = optional(string)
    stop_before_destroy  = optional(bool, false)
  }))
  description = "Project environments keyed by name."
  default     = {}

  validation {
    condition = alltrue([
      for env in values(var.environments) : lookup(env, "tier", null) == null ? true : contains([
        "production",
        "staging",
        "testing",
        "development",
        "other"
      ], env.tier)
    ])
    error_message = "Unsupported environment tier"
  }
}

variable "approval_rules" {
  description = "Project-level merge request approval rules keyed by rule name."
  type = map(object({
    approvals_required = number
    user_ids           = optional(list(number), [])
    usernames          = optional(list(string), [])
    group_ids          = optional(list(number), [])
    group_paths        = optional(list(string), [])
    protected_branches = optional(list(string), [])
  }))
  default = {}

  validation {
    condition = alltrue([
      for rule in values(var.approval_rules) : alltrue([
        for branch in lookup(rule, "protected_branches", []) : contains(keys(var.protected_branches), branch)
      ])
    ])
    error_message = "Approval rules can reference only branches defined in protected_branches."
  }
}

variable "variables" {
  type = map(object({
    value             = string
    description       = optional(string)
    protected         = optional(bool)
    masked            = optional(bool)
    environment_scope = optional(string)
  }))
  default = {}
}

variable "mirror_url" {
  type        = string
  description = "URL for the project mirror"
  default     = ""
}

variable "mirror_only_protected_branches" {
  type        = bool
  description = "Mirror only protected branches"
  default     = false
}

variable "mirror_branch_regex" {
  type        = string
  description = "Regular expression used to limit which branches are mirrored"
  default     = ""
}

variable "is_gitlab_free" {
  type        = bool
  default     = true
  description = "Is the project a free tier project"
}

variable "is_enable_conventional_commits_push_rule" {
  type        = bool
  default     = false
  description = "Enable conventional commits push rule"

}

variable "archived" {
  type        = bool
  default     = false
  description = "Whether the GitLab project should be archived"
}

variable "avatars_dir" {
  description = "Avatars directory png files"
  type        = string
  default     = ""
}

variable "only_allow_merge_if_pipeline_succeeds" {
  description = "Set to true if you want allow merges only if a pipeline succeeds."
  type        = bool
  default     = true
}

variable "allow_merge_on_skipped_pipeline" {
  description = "Set to true if you want to treat skipped pipelines as if they finished with success."
  type        = bool
  default     = false
}
