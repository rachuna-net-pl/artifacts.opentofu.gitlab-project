# terraform-docs

[![Build Status](https://github.com/terraform-docs/terraform-docs/workflows/ci/badge.svg)](https://github.com/terraform-docs/terraform-docs/actions) [![GoDoc](https://pkg.go.dev/badge/github.com/terraform-docs/terraform-docs)](https://pkg.go.dev/github.com/terraform-docs/terraform-docs) [![Go Report Card](https://goreportcard.com/badge/github.com/terraform-docs/terraform-docs)](https://goreportcard.com/report/github.com/terraform-docs/terraform-docs) [![Codecov Report](https://codecov.io/gh/terraform-docs/terraform-docs/branch/master/graph/badge.svg)](https://codecov.io/gh/terraform-docs/terraform-docs) [![License](https://img.shields.io/github/license/terraform-docs/terraform-docs)](https://github.com/terraform-docs/terraform-docs/blob/master/LICENSE) [![Latest release](https://img.shields.io/github/v/release/terraform-docs/terraform-docs)](https://github.com/terraform-docs/terraform-docs/releases)

![terraform-docs-teaser](./images/terraform-docs-teaser.png)

## What is terraform-docs

A utility to generate documentation from Terraform modules in various output formats.

## Installation

macOS users can install using [Homebrew]:

```bash
brew install terraform-docs
```

or

```bash
brew install terraform-docs/tap/terraform-docs
```

Windows users can install using [Scoop]:

```bash
scoop bucket add terraform-docs https://github.com/terraform-docs/scoop-bucket
scoop install terraform-docs
```

or [Chocolatey]:

```bash
choco install terraform-docs
```

Stable binaries are also available on the [releases] page. To install, download the
binary for your platform from "Assets" and place this into your `$PATH`:

```bash
curl -Lo ./terraform-docs.tar.gz https://github.com/terraform-docs/terraform-docs/releases/download/v0.20.0/terraform-docs-v0.20.0-$(uname)-amd64.tar.gz
tar -xzf terraform-docs.tar.gz
chmod +x terraform-docs
mv terraform-docs /usr/local/bin/terraform-docs
```

**NOTE:** Windows releases are in `ZIP` format.

The latest version can be installed using `go install` or `go get`:

```bash
# go1.17+
go install github.com/terraform-docs/terraform-docs@v0.20.0
```

```bash
# go1.16
GO111MODULE="on" go get github.com/terraform-docs/terraform-docs@v0.20.0
```

**NOTE:** please use the latest Go to do this, minimum `go1.16` is required.

This will put `terraform-docs` in `$(go env GOPATH)/bin`. If you encounter the error
`terraform-docs: command not found` after installation then you may need to either add
that directory to your `$PATH` as shown [here] or do a manual installation by cloning
the repo and run `make build` from the repository which will put `terraform-docs` in:

```bash
$(go env GOPATH)/src/github.com/terraform-docs/terraform-docs/bin/$(uname | tr '[:upper:]' '[:lower:]')-amd64/terraform-docs
```

## Usage

### Running the binary directly

To run and generate documentation into README within a directory:

```bash
terraform-docs markdown table --output-file README.md --output-mode inject /path/to/module
```

Check [`output`] configuration for more details and examples.

### Using docker

terraform-docs can be run as a container by mounting a directory with `.tf`
files in it and run the following command:

```bash
docker run --rm --volume "$(pwd):/terraform-docs" -u $(id -u) quay.io/terraform-docs/terraform-docs:0.20.0 markdown /terraform-docs
```

If `output.file` is not enabled for this module, generated output can be redirected
back to a file:

```bash
docker run --rm --volume "$(pwd):/terraform-docs" -u $(id -u) quay.io/terraform-docs/terraform-docs:0.20.0 markdown /terraform-docs > doc.md
```

**NOTE:** Docker tag `latest` refers to _latest_ stable released version and `edge`
refers to HEAD of `master` at any given point in time.

### Using GitHub Actions

To use terraform-docs GitHub Action, configure a YAML workflow file (e.g.
`.github/workflows/documentation.yml`) with the following:

```yaml
name: Generate terraform docs
on:
  - pull_request

jobs:
  docs:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
      with:
        ref: ${{ github.event.pull_request.head.ref }}

    - name: Render terraform docs and push changes back to PR
      uses: terraform-docs/gh-actions@main
      with:
        working-dir: .
        output-file: README.md
        output-method: inject
        git-push: "true"
```

Read more about [terraform-docs GitHub Action] and its configuration and
examples.

### pre-commit hook

With pre-commit, you can ensure your Terraform module documentation is kept
up-to-date each time you make a commit.

First [install pre-commit] and then create or update a `.pre-commit-config.yaml`
in the root of your Git repo with at least the following content:

```yaml
repos:
  - repo: https://github.com/terraform-docs/terraform-docs
    rev: "v0.20.0"
    hooks:
      - id: terraform-docs-go
        args: ["markdown", "table", "--output-file", "README.md", "./mymodule/path"]
```

Then run:

```bash
pre-commit install
pre-commit install-hooks
```

Further changes to your module's `.tf` files will cause an update to documentation
when you make a commit.

## Configuration

terraform-docs can be configured with a yaml file. The default name of this file is
`.terraform-docs.yml` and the path order for locating it is:

1. root of module directory
1. `.config/` folder at root of module directory
1. current directory
1. `.config/` folder at current directory
1. `$HOME/.tfdocs.d/`

```yaml
formatter: "" # this is required

version: ""

header-from: main.tf
footer-from: ""

recursive:
  enabled: false
  path: modules
  include-main: true

sections:
  hide: []
  show: []

content: ""

output:
  file: ""
  mode: inject
  template: |-
    <!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.10.5 |
| <a name="requirement_gitlab"></a> [gitlab](#requirement\_gitlab) | 18.8.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_gitlab"></a> [gitlab](#provider\_gitlab) | 18.8.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [gitlab_branch_protection.protected_branches](https://registry.terraform.io/providers/gitlabhq/gitlab/18.8.2/docs/resources/branch_protection) | resource |
| [gitlab_pipeline_schedule.ci_schedule](https://registry.terraform.io/providers/gitlabhq/gitlab/18.8.2/docs/resources/pipeline_schedule) | resource |
| [gitlab_pipeline_schedule_variable.ci_schedule_variable](https://registry.terraform.io/providers/gitlabhq/gitlab/18.8.2/docs/resources/pipeline_schedule_variable) | resource |
| [gitlab_project.project](https://registry.terraform.io/providers/gitlabhq/gitlab/18.8.2/docs/resources/project) | resource |
| [gitlab_project_approval_rule.approval_rule](https://registry.terraform.io/providers/gitlabhq/gitlab/18.8.2/docs/resources/project_approval_rule) | resource |
| [gitlab_project_environment.environment](https://registry.terraform.io/providers/gitlabhq/gitlab/18.8.2/docs/resources/project_environment) | resource |
| [gitlab_project_label.label](https://registry.terraform.io/providers/gitlabhq/gitlab/18.8.2/docs/resources/project_label) | resource |
| [gitlab_project_mirror.mirror](https://registry.terraform.io/providers/gitlabhq/gitlab/18.8.2/docs/resources/project_mirror) | resource |
| [gitlab_project_push_rules.push_rule](https://registry.terraform.io/providers/gitlabhq/gitlab/18.8.2/docs/resources/project_push_rules) | resource |
| [gitlab_project_variable.variable](https://registry.terraform.io/providers/gitlabhq/gitlab/18.8.2/docs/resources/project_variable) | resource |
| [gitlab_tag_protection.protected_tags](https://registry.terraform.io/providers/gitlabhq/gitlab/18.8.2/docs/resources/tag_protection) | resource |
| [gitlab_group.approval_rule_groups](https://registry.terraform.io/providers/gitlabhq/gitlab/18.8.2/docs/data-sources/group) | data source |
| [gitlab_group.parent](https://registry.terraform.io/providers/gitlabhq/gitlab/18.8.2/docs/data-sources/group) | data source |
| [gitlab_user.approval_rule_users](https://registry.terraform.io/providers/gitlabhq/gitlab/18.8.2/docs/data-sources/user) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_merge_on_skipped_pipeline"></a> [allow\_merge\_on\_skipped\_pipeline](#input\_allow\_merge\_on\_skipped\_pipeline) | Set to true if you want to treat skipped pipelines as if they finished with success. | `bool` | `false` | no |
| <a name="input_allowed_avatar_types_json"></a> [allowed\_avatar\_types\_json](#input\_allowed\_avatar\_types\_json) | Path to allowed avatar types json | `string` | `""` | no |
| <a name="input_allowed_project_types_json"></a> [allowed\_project\_types\_json](#input\_allowed\_project\_types\_json) | Path to allowed project types json | `string` | `""` | no |
| <a name="input_approval_rules"></a> [approval\_rules](#input\_approval\_rules) | Project-level merge request approval rules keyed by rule name. | <pre>map(object({<br/>    approvals_required = number<br/>    user_ids           = optional(list(number), [])<br/>    usernames          = optional(list(string), [])<br/>    group_ids          = optional(list(number), [])<br/>    group_paths        = optional(list(string), [])<br/>    protected_branches = optional(list(string), [])<br/>  }))</pre> | `{}` | no |
| <a name="input_archived"></a> [archived](#input\_archived) | Whether the GitLab project should be archived | `bool` | `false` | no |
| <a name="input_autoclose_referenced_issues"></a> [autoclose\_referenced\_issues](#input\_autoclose\_referenced\_issues) | Autoclose referenced issues | `bool` | `true` | no |
| <a name="input_avatar"></a> [avatar](#input\_avatar) | Path to the avatar .png file (default: derived from project type) | `string` | `""` | no |
| <a name="input_avatars_dir"></a> [avatars\_dir](#input\_avatars\_dir) | Avatars directory png files | `string` | `""` | no |
| <a name="input_build_git_strategy"></a> [build\_git\_strategy](#input\_build\_git\_strategy) | The Git strategy. Defaults to fetch. | `string` | `"clone"` | no |
| <a name="input_ci_schedules"></a> [ci\_schedules](#input\_ci\_schedules) | List of GitLab CI pipeline schedules for this project with optional variables. | <pre>list(object({<br/>    name          = string<br/>    description   = string<br/>    ref           = string<br/>    cron          = string<br/>    cron_timezone = optional(string)<br/>    active        = optional(bool)<br/>    variables = optional(map(object({<br/>      value         = string<br/>      variable_type = optional(string)<br/>    })))<br/>  }))</pre> | `[]` | no |
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
| <a name="input_protected_branches"></a> [protected\_branches](#input\_protected\_branches) | n/a | <pre>map(object({<br/>    push_access_level  = string<br/>    merge_access_level = string<br/>    allow_force_push   = optional(bool, false)<br/>  }))</pre> | <pre>{<br/>  "develop": {<br/>    "merge_access_level": "maintainer",<br/>    "push_access_level": "no one"<br/>  },<br/>  "main": {<br/>    "merge_access_level": "maintainer",<br/>    "push_access_level": "no one"<br/>  }<br/>}</pre> | no |
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

output-values:
  enabled: false
  from: ""

sort:
  enabled: true
  by: name

settings:
  anchor: true
  color: true
  default: true
  description: false
  escape: true
  hide-empty: false
  html: true
  indent: 2
  lockfile: true
  read-comments: true
  required: true
  sensitive: true
  type: true
```

## Content Template

Generated content can be customized further away with `content` in configuration.
If the `content` is empty the default order of sections is used.

Compatible formatters for customized content are `asciidoc` and `markdown`. `content`
will be ignored for other formatters.

`content` is a Go template with following additional variables:

- `{{ .Header }}`
- `{{ .Footer }}`
- `{{ .Inputs }}`
- `{{ .Modules }}`
- `{{ .Outputs }}`
- `{{ .Providers }}`
- `{{ .Requirements }}`
- `{{ .Resources }}`

and following functions:

- `{{ include "relative/path/to/file" }}`

These variables are the generated output of individual sections in the selected
formatter. For example `{{ .Inputs }}` is Markdown Table representation of _inputs_
when formatter is set to `markdown table`.

Note that sections visibility (i.e. `sections.show` and `sections.hide`) takes
precedence over the `content`.

Additionally there's also one extra special variable avaialble to the `content`:

- `{{ .Module }}`

As opposed to the other variables mentioned above, which are generated sections
based on a selected formatter, the `{{ .Module }}` variable is just a `struct`
representing a [Terraform module].

````yaml
content: |-
  Any arbitrary text can be placed anywhere in the content

  {{ .Header }}

  and even in between sections

  {{ .Providers }}

  and they don't even need to be in the default order

  {{ .Outputs }}

  include any relative files

  {{ include "relative/path/to/file" }}

  {{ .Inputs }}

  # Examples

  ```hcl
  {{ include "examples/foo/main.tf" }}
  ```

  ## Resources

  {{ range .Module.Resources }}
  - {{ .GetMode }}.{{ .Spec }} ({{ .Position.Filename }}#{{ .Position.Line }})
  {{- end }}
````

## Build on top of terraform-docs

terraform-docs primary use-case is to be utilized as a standalone binary, but
some parts of it is also available publicly and can be imported in your project
as a library.

```go
import (
    "github.com/terraform-docs/terraform-docs/format"
    "github.com/terraform-docs/terraform-docs/print"
    "github.com/terraform-docs/terraform-docs/terraform"
)

// buildTerraformDocs for module root `path` and provided content `tmpl`.
func buildTerraformDocs(path string, tmpl string) (string, error) {
    config := print.DefaultConfig()
    config.ModuleRoot = path // module root path (can be relative or absolute)

    module, err := terraform.LoadWithOptions(config)
    if err != nil {
        return "", err
    }

    // Generate in Markdown Table format
    formatter := format.NewMarkdownTable(config)

    if err := formatter.Generate(module); err != nil {
        return "", err
    }

    // // Note: if you don't intend to provide additional template for the generated
    // // content, or the target format doesn't provide templating (e.g. json, yaml,
    // // xml, or toml) you can use `Content()` function instead of `Render()`.
    // // `Content()` returns all the sections combined with predefined order.
    // return formatter.Content(), nil

    return formatter.Render(tmpl)
}
```

## Plugin

Generated output can be heavily customized with [`content`], but if using that
is not enough for your use-case, you can write your own plugin.

In order to install a plugin the following steps are needed:

- download the plugin and place it in `~/.tfdocs.d/plugins` (or `./.tfdocs.d/plugins`)
- make sure the plugin file name is `tfdocs-format-<NAME>`
- modify [`formatter`] of `.terraform-docs.yml` file to be `<NAME>`

**Important notes:**

- if the plugin file name is different than the example above, terraform-docs won't
be able to to pick it up nor register it properly
- you can only use plugin thorough `.terraform-docs.yml` file and it cannot be used
with CLI arguments

To create a new plugin create a new repository called `tfdocs-format-<NAME>` with
following `main.go`:

```go
package main

import (
    _ "embed" //nolint

    "github.com/terraform-docs/terraform-docs/plugin"
    "github.com/terraform-docs/terraform-docs/print"
    "github.com/terraform-docs/terraform-docs/template"
    "github.com/terraform-docs/terraform-docs/terraform"
)

func main() {
    plugin.Serve(&plugin.ServeOpts{
        Name:    "<NAME>",
        Version: "0.1.0",
        Printer: printerFunc,
    })
}

//go:embed sections.tmpl
var tplCustom []byte

// printerFunc the function being executed by the plugin client.
func printerFunc(config *print.Config, module *terraform.Module) (string, error) {
    tpl := template.New(config,
        &template.Item{Name: "custom", Text: string(tplCustom)},
    )

    rendered, err := tpl.Render("custom", module)
    if err != nil {
        return "", err
    }

    return rendered, nil
}
```

Please refer to [tfdocs-format-template] for more details. You can create a new
repository from it by clicking on `Use this template` button.

## Documentation

- **Users**
  - Read the [User Guide] to learn how to use terraform-docs
  - Read the [Formats Guide] to learn about different output formats of terraform-docs
  - Refer to [Config File Reference] for all the available configuration options
- **Developers**
  - Read [Contributing Guide] before submitting a pull request

Visit [our website] for all documentation.

## Community

- Discuss terraform-docs on [Slack]

## License

MIT License - Copyright (c) 2021 The terraform-docs Authors.

[Chocolatey]: https://www.chocolatey.org
[Config File Reference]: https://terraform-docs.io/user-guide/configuration/
[`content`]: https://terraform-docs.io/user-guide/configuration/content/
[Contributing Guide]: CONTRIBUTING.md
[Formats Guide]: https://terraform-docs.io/reference/terraform-docs/
[`formatter`]: https://terraform-docs.io/user-guide/configuration/formatter/
[here]: https://golang.org/doc/code.html#GOPATH
[Homebrew]: https://brew.sh
[install pre-commit]: https://pre-commit.com/#install
[`output`]: https://terraform-docs.io/user-guide/configuration/output/
[releases]: https://github.com/terraform-docs/terraform-docs/releases
[Scoop]: https://scoop.sh/
[Slack]: https://slack.terraform-docs.io/
[terraform-docs GitHub Action]: https://github.com/terraform-docs/gh-actions
[Terraform module]: https://pkg.go.dev/github.com/terraform-docs/terraform-docs/terraform#Module
[tfdocs-format-template]: https://github.com/terraform-docs/tfdocs-format-template
[our website]: https://terraform-docs.io/
[User Guide]: https://terraform-docs.io/user-guide/introduction/
