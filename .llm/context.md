# Kontekst projektu `gitlab-project`

## Cel modułu

Reużywalny moduł OpenTofu/Terraform opakowujący provider `gitlabhq/gitlab` w zestaw opinionated ustawień dla projektów pl.rachuna-net: tworzenie repozytoriów GitLab wraz z pełną konfiguracją (chronione gałęzie/tagi, reguły zatwierdzania MR, harmonogramy CI, zmienne, środowiska, mirror, avatar).

## Struktura repozytorium

| Ścieżka | Przeznaczenie |
|---------|---------------|
| [main.tf](../main.tf) | Definicje zasobów GitLab (projekt, chronione gałęzie/tagi, approval rules, zmienne, schedulery CI, mirror, środowiska, labele, push rules). |
| [locals.tf](../locals.tf) | Wyliczenia pomocnicze: ścieżka avatara, scalanie zmiennych/tagów z `allowed_project_types`, spłaszczanie zmiennych harmonogramów, normalizacja `ref`. |
| [variable.tf](../variable.tf) | Wszystkie zmienne wejściowe modułu wraz z walidacjami i wartościami domyślnymi. |
| [output.tf](../output.tf) | Eksponowane wyjścia modułu. |
| [data.tf](../data.tf) | Źródła danych: `gitlab_group` (parent oraz grupy z approval rules), `gitlab_user` (użytkownicy z approval rules). |
| [providers.tf](../providers.tf) | Wymagany Terraform `>= 1.10.5`, provider `gitlabhq/gitlab` `18.8.2`. |
| [data/allowed_project_types.json](../data/allowed_project_types.json) | Katalog typów projektów: dla każdego typu domyślne `avatar`, `gitlab_ci_path`, `tags`, `ci_variables`, `protected_branches`, `protected_tags`. |
| [docs/](../docs/) | Assety (logo, grafika opentofu) używane w README. |
| [.terraform-docs.yml](../.terraform-docs.yml) | Konfiguracja generatora dokumentacji zmiennych. |
| [renovate.json](../renovate.json) | Reguły Renovate dla automatycznych aktualizacji. |
| [.devcontainer/](../.devcontainer/) | Środowisko devcontainer dla VS Code. |

## Kluczowe koncepty logiki

### `project_type` i `allowed_project_types.json`

Zmienna `var.project_type` wskazuje klucz w mapie z `data/allowed_project_types.json`. Dla każdego typu plik definiuje: domyślny avatar, ścieżkę do pliku `.gitlab-ci.yml`, tagi, zmienne CI (`ci_variables`), chronione gałęzie i chronione tagi.

W [locals.tf](../locals.tf):

- `merged_project_variables` scala `ci_variables` z typu projektu z `var.variables` oraz dokłada zmienną `PROJECT_TYPE`.
- `merged_protected_tags` scala chronione tagi z typu projektu z `var.protected_tags`.
- `avatar` jest wyliczany z `var.avatar`, a jeśli pusty — z `avatar` typu projektu; plik musi istnieć (`fileexists`), w przeciwnym razie avatar pozostaje `null`.

### Harmonogramy CI

`var.ci_schedules` to lista obiektów przekształcana w [locals.tf](../locals.tf) do mapy keyed by `name`. Pole `ref`, jeśli nie zaczyna się od `refs/`, jest automatycznie poprzedzane `refs/heads/`. Zmienne harmonogramów są spłaszczane do listy przez `ci_schedule_variables` i tworzone jako `gitlab_pipeline_schedule_variable`.

### Approval rules

Reguły są tworzone tylko dla GitLab płatnego (`var.is_gitlab_free == false`). Moduł akceptuje zarówno surowe `user_ids`/`group_ids`, jak i nazwy `usernames`/`group_paths` — te drugie są rozwiązywane przez data sources w [data.tf](../data.tf).

### Push rules

Regex konwencjonalnych commitów (`^(build|chore|ci|docs|params|feat|fix|perf|refactor|style|test|revert|merge|release|hotfix|fixup|squash|wip|BREAKING CHANGE)(\(.+\))?: .+`) jest włączany przez `var.is_enable_conventional_commits_push_rule` (tylko płatny GitLab).

### Mirror

Mirror jest tworzony warunkowo, gdy `var.mirror_url != ""`.

### `lifecycle` na projekcie

`gitlab_project.project` ma `prevent_destroy = true` i `ignore_changes = [archived]`, dlatego zmiana `var.archived` po utworzeniu nie powoduje rekonfiguracji, a `tofu destroy` zgłosi błąd.

## Wyjścia modułu

Aktualnie eksponowane: `name`, `description` (patrz [output.tf](../output.tf)).

## Powiązania zewnętrzne

- Provider GitLab: https://registry.terraform.io/providers/gitlabhq/gitlab/18.8.2
- Convention Commits (standard commitów projektu): https://www.conventionalcommits.org/
- Wiki standardów: https://gitlab.com/pl.rachuna-net/ai/openclaw/gitlab-profile/-/wikis/Standardy/Conventional-Commits
