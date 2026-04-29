# <img src="docs/opentofu.png" alt="opentofu" height="30"/> gitlab-project

Zarządzanie projektami w GitLab

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.10.5 |
| <a name="requirement_gitlab"></a> [gitlab](#requirement\_gitlab) | 18.11.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_gitlab"></a> [gitlab](#provider\_gitlab) | 18.11.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [gitlab_branch_protection.protected_branches](https://registry.terraform.io/providers/gitlabhq/gitlab/18.11.0/docs/resources/branch_protection) | resource |
| [gitlab_pipeline_schedule.ci_schedule](https://registry.terraform.io/providers/gitlabhq/gitlab/18.11.0/docs/resources/pipeline_schedule) | resource |
| [gitlab_pipeline_schedule_variable.ci_schedule_variable](https://registry.terraform.io/providers/gitlabhq/gitlab/18.11.0/docs/resources/pipeline_schedule_variable) | resource |
| [gitlab_project.project](https://registry.terraform.io/providers/gitlabhq/gitlab/18.11.0/docs/resources/project) | resource |
| [gitlab_project_approval_rule.approval_rule](https://registry.terraform.io/providers/gitlabhq/gitlab/18.11.0/docs/resources/project_approval_rule) | resource |
| [gitlab_project_environment.environment](https://registry.terraform.io/providers/gitlabhq/gitlab/18.11.0/docs/resources/project_environment) | resource |
| [gitlab_project_label.label](https://registry.terraform.io/providers/gitlabhq/gitlab/18.11.0/docs/resources/project_label) | resource |
| [gitlab_project_mirror.mirror](https://registry.terraform.io/providers/gitlabhq/gitlab/18.11.0/docs/resources/project_mirror) | resource |
| [gitlab_project_push_rules.push_rule](https://registry.terraform.io/providers/gitlabhq/gitlab/18.11.0/docs/resources/project_push_rules) | resource |
| [gitlab_project_variable.variable](https://registry.terraform.io/providers/gitlabhq/gitlab/18.11.0/docs/resources/project_variable) | resource |
| [gitlab_tag_protection.protected_tags](https://registry.terraform.io/providers/gitlabhq/gitlab/18.11.0/docs/resources/tag_protection) | resource |
| [gitlab_group.approval_rule_groups](https://registry.terraform.io/providers/gitlabhq/gitlab/18.11.0/docs/data-sources/group) | data source |
| [gitlab_group.parent](https://registry.terraform.io/providers/gitlabhq/gitlab/18.11.0/docs/data-sources/group) | data source |
| [gitlab_user.approval_rule_users](https://registry.terraform.io/providers/gitlabhq/gitlab/18.11.0/docs/data-sources/user) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_merge_on_skipped_pipeline"></a> [allow\_merge\_on\_skipped\_pipeline](#input\_allow\_merge\_on\_skipped\_pipeline) | Set to true if you want to treat skipped pipelines as if they finished with success. | `bool` | `false` | no |
| <a name="input_allowed_project_types_json"></a> [allowed\_project\_types\_json](#input\_allowed\_project\_types\_json) | Path to allowed project types json | `string` | `""` | no |
| <a name="input_approval_rules"></a> [approval\_rules](#input\_approval\_rules) | Project-level merge request approval rules keyed by rule name. | <pre>map(object({<br/>    approvals_required = number<br/>    user_ids           = optional(list(number), [])<br/>    usernames          = optional(list(string), [])<br/>    group_ids          = optional(list(number), [])<br/>    group_paths        = optional(list(string), [])<br/>    protected_branches = optional(list(string), [])<br/>  }))</pre> | `{}` | no |
| <a name="input_archived"></a> [archived](#input\_archived) | Whether the GitLab project should be archived | `bool` | `false` | no |
| <a name="input_autoclose_referenced_issues"></a> [autoclose\_referenced\_issues](#input\_autoclose\_referenced\_issues) | Autoclose referenced issues | `bool` | `true` | no |
| <a name="input_avatar"></a> [avatar](#input\_avatar) | Path to the avatar .png file (default: derived from project type) | `string` | `""` | no |
| <a name="input_avatars_dir"></a> [avatars\_dir](#input\_avatars\_dir) | Avatars directory png files | `string` | `""` | no |
| <a name="input_build_git_strategy"></a> [build\_git\_strategy](#input\_build\_git\_strategy) | The Git strategy. Defaults to fetch. | `string` | `"clone"` | no |
| <a name="input_ci_push_repository_for_job_token_allowed"></a> [ci\_push\_repository\_for\_job\_token\_allowed](#input\_ci\_push\_repository\_for\_job\_token\_allowed) | Set to true if you want to allow pushing to the repository for job tokens. | `bool` | `false` | no |
| <a name="input_ci_schedules"></a> [ci\_schedules](#input\_ci\_schedules) | List of GitLab CI pipeline schedules for this project with optional inputs and variables. | <pre>list(object({<br/>    name          = string<br/>    description   = string<br/>    ref           = string<br/>    cron          = string<br/>    cron_timezone = optional(string)<br/>    active        = optional(bool)<br/>    inputs = optional(list(object({<br/>      name  = string<br/>      value = any<br/>    })))<br/>    variables = optional(map(object({<br/>      value         = string<br/>      variable_type = optional(string)<br/>    })))<br/>  }))</pre> | `[]` | no |
| <a name="input_default_branch"></a> [default\_branch](#input\_default\_branch) | Default branch | `string` | `""` | no |
| <a name="input_description"></a> [description](#input\_description) | Repository Description | `string` | n/a | yes |
| <a name="input_environments"></a> [environments](#input\_environments) | Project environments keyed by name. | <pre>map(object({<br/>    description          = optional(string)<br/>    auto_stop_setting    = optional(string)<br/>    external_url         = optional(string)<br/>    kubernetes_namespace = optional(string)<br/>    tier                 = optional(string)<br/>    stop_before_destroy  = optional(bool, false)<br/>  }))</pre> | `{}` | no |
| <a name="input_gitlab_ci_path"></a> [gitlab\_ci\_path](#input\_gitlab\_ci\_path) | Path to the GitLab CI file | `string` | `null` | no |
| <a name="input_is_enable_conventional_commits_push_rule"></a> [is\_enable\_conventional\_commits\_push\_rule](#input\_is\_enable\_conventional\_commits\_push\_rule) | Enable conventional commits push rule | `bool` | `false` | no |
| <a name="input_is_gitlab_free"></a> [is\_gitlab\_free](#input\_is\_gitlab\_free) | Is the project a free tier project | `bool` | `true` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | n/a | <pre>map(object({<br/>    description = string<br/>    color       = string<br/>  }))</pre> | `{}` | no |
| <a name="input_mirror_branch_regex"></a> [mirror\_branch\_regex](#input\_mirror\_branch\_regex) | Regular expression used to limit which branches are mirrored | `string` | `""` | no |
| <a name="input_mirror_only_protected_branches"></a> [mirror\_only\_protected\_branches](#input\_mirror\_only\_protected\_branches) | Mirror only protected branches | `bool` | `false` | no |
| <a name="input_mirror_url"></a> [mirror\_url](#input\_mirror\_url) | URL for the project mirror | `string` | `""` | no |
| <a name="input_name"></a> [name](#input\_name) | Repository Name | `string` | n/a | yes |
| <a name="input_only_allow_merge_if_pipeline_succeeds"></a> [only\_allow\_merge\_if\_pipeline\_succeeds](#input\_only\_allow\_merge\_if\_pipeline\_succeeds) | Set to true if you want allow merges only if a pipeline succeeds. | `bool` | `true` | no |
| <a name="input_parent_group"></a> [parent\_group](#input\_parent\_group) | Parent Group | `string` | n/a | yes |
| <a name="input_project_type"></a> [project\_type](#input\_project\_type) | Project type | `string` | `""` | no |
| <a name="input_protected_branches"></a> [protected\_branches](#input\_protected\_branches) | Protected branches configuration. If null, defaults are taken from allowed\_project\_types per project type. | <pre>map(object({<br/>    push_access_level  = string<br/>    merge_access_level = string<br/>    allow_force_push   = optional(bool, false)<br/>  }))</pre> | `null` | no |
| <a name="input_protected_tags"></a> [protected\_tags](#input\_protected\_tags) | Protected tags | <pre>map(object({<br/>    create_access_level = string<br/>  }))</pre> | <pre>{<br/>  "v*": {<br/>    "create_access_level": "maintainer"<br/>  }<br/>}</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags | `list(string)` | `[]` | no |
| <a name="input_variables"></a> [variables](#input\_variables) | n/a | <pre>map(object({<br/>    value             = string<br/>    description       = optional(string)<br/>    protected         = optional(bool)<br/>    masked            = optional(bool)<br/>    environment_scope = optional(string)<br/>  }))</pre> | `{}` | no |
| <a name="input_visibility"></a> [visibility](#input\_visibility) | The project's visibility | `string` | `"private"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_description"></a> [description](#output\_description) | n/a |
| <a name="output_name"></a> [name](#output\_name) | n/a |
<!-- END_TF_DOCS -->

## CI pipeline schedulers

Moduł umożliwia definiowanie schedulerów CI wraz z zestawem inputów i zmiennych przekazywanych do pipeline'ów. Każdy scheduler przyjmuje pola `name`, `description`, `ref`, `cron`, opcjonalne `cron_timezone` (domyślnie `UTC`), `active` (domyślnie `true`), listę `inputs` z obiektami `{ name, value }` oraz mapę `variables`, w której kluczem jest nazwa zmiennej, a wartością obiekt `{ value, variable_type }` z typem `env_var` (domyślnie) lub `file`. Gałąź podana w `ref` jest automatycznie poprzedzana `refs/heads/` dla zachowania zgodności z API GitLaba; pełne referencje (`refs/tags/...`) podawaj wprost.

Przykładowa konfiguracja dwóch schedulerów:

```hcl
module "gitlab_project" {
  source = "path/to/modules/gitlab-project"

  # ...pozostałe argumenty modułu

  ci_schedules = [
    {
      name          = "nightly"
      description   = "Nightly smoke tests on main"
      ref           = "main"
      cron          = "0 1 * * *"
      cron_timezone = "Europe/Warsaw"
      inputs = [
        {
          name  = "environment"
          value = "staging"
        },
        {
          name  = "run_smoke_tests"
          value = true
        }
      ]
      variables = {
        ENVIRONMENT = { value = "staging" }
        SMOKE_SCOPE = { value = "critical" }
      }
    },
    {
      name        = "weekly-security"
      description = "Weekly security scan on develop"
      ref         = "develop"
      cron        = "30 2 * * 1"
      active      = false
      variables = {
        SCAN_DEPTH = { value = "full" }
        LICENSES   = { value = "approved", variable_type = "file" }
      }
    }
  ]
}
```

---
## Contributions
Jeśli masz pomysły na ulepszenia, zgłoś problemy, rozwidl repozytorium lub utwórz Merge Request. Wszystkie wkłady są mile widziane!
[Contributions](CONTRIBUTING.md)

---
## License
[Licencja](LICENSE) oparta na zasadach Creative Commons BY-NC-SA 4.0, dostosowana do potrzeb projektu.

---
# Author Information
### Maciej Rachuna
# <img src="docs/logo.png" alt="rachuna-net.pl" height="100"/>
