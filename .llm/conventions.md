# Konwencje projektu `gitlab-project`

Dokument opisuje konwencje kodu, commitów i współpracy obowiązujące w repozytorium.

## HCL / OpenTofu

### Formatowanie

- Używaj `tofu fmt -recursive` (lub `terraform fmt`) przed commitem.
- Wyrównuj znaki `=` w blokach konfiguracji w obrębie pojedynczego zasobu/locala (tak jak w istniejącym kodzie — np. [main.tf](../main.tf)).
- Dwuspacjowe wcięcia, brak tabulatorów.

### Nazewnictwo

- Pliki: `main.tf`, `variable.tf` (liczba pojedyncza — tak jak w projekcie), `locals.tf`, `data.tf`, `output.tf`, `providers.tf`.
- Nazwy zasobów i zmiennych: `snake_case`.
- Klucze w mapach wejściowych (np. `protected_branches`, `labels`, `approval_rules`) odpowiadają rzeczywistym nazwom (branch/tag/label/rule).

### Struktura zmiennych

- Każda zmienna ma `type` i `description`; w miarę możliwości `default`.
- Walidacje (`validation { condition … error_message … }`) dodawaj tam, gdzie wartość należy do zamkniętego zbioru (np. `visibility`).
- Złożone struktury definiuj jako `map(object({...}))` z `optional(...)` dla pól nieobowiązkowych.

### Zasoby i wyrażenia

- Do warunkowego tworzenia zasobu używaj `count = var.flag ? 1 : 0` lub pustego `for_each = {}`.
- Przy scalaniu map preferuj `merge(...)` w [locals.tf](../locals.tf), a nie w zasobach.
- Przy odwołaniach do mapy z JSON (`local.allowed_project_types[var.project_type]`) korzystaj z `lookup(..., klucz, default)` tam, gdzie klucz może nie występować (jak w `merged_protected_tags`).
- Nie dodawaj nowych providerów ani nie zmieniaj wersji providera bez wyraźnej zgody — wersja jest pinowana w [providers.tf](../providers.tf).

### `lifecycle`

- Na `gitlab_project.project` zachowane: `prevent_destroy = true`, `ignore_changes = [archived]`. Nie zmieniaj bez zgody właściciela.

## Dokumentacja

- Sekcja między `<!-- BEGIN_TF_DOCS -->` a `<!-- END_TF_DOCS -->` w [README.md](../README.md) jest generowana przez `terraform-docs` wg [.terraform-docs.yml](../.terraform-docs.yml). Regeneruj ją zamiast edytować ręcznie:
  ```bash
  terraform-docs .
  ```
- Opisy (`description`) w `variable.tf` powinny być po angielsku (spójnie z istniejącym kodem) — to one trafiają do wygenerowanej dokumentacji.
- Dłuższe objaśnienia konceptów (np. schedulery CI) dokumentuj w [README.md](../README.md) poza blokiem `BEGIN_TF_DOCS` — po polsku.

## Dane statyczne (`data/allowed_project_types.json`)

- Klucz `""` (pusty) jest używany jako typ domyślny — nie usuwaj go.
- Każdy wpis musi zawierać pola: `avatar`, `gitlab_ci_path`, `tags`, `ci_variables`, `protected_branches`, `protected_tags` (nawet jeśli puste).
- Gdy dodajesz nowy typ projektu, rozważ dodanie odpowiedniego avatara w katalogu mapowanym przez `var.avatars_dir` / `.userfiles`.

## Commity

- Standard: [Conventional Commits](https://www.conventionalcommits.org/).
- Dozwolone typy (zgodne z regex push rule w [main.tf](../main.tf)): `build`, `chore`, `ci`, `docs`, `params`, `feat`, `fix`, `perf`, `refactor`, `style`, `test`, `revert`, `merge`, `release`, `hotfix`, `fixup`, `squash`, `wip`, `BREAKING CHANGE`.
- Opis commita może być po polsku lub po angielsku — zachowuj spójność w obrębie gałęzi.
- Jeden commit = jedna logiczna zmiana; nie mieszaj refaktoru z nową funkcją.

## Gałęzie i MR

- Gałąź domyślna: `main`; gałąź rozwojowa: `develop`.
- Nowe prace wykonuj na gałęziach tematycznych (`feat/...`, `fix/...`, `refactor/...`, `docs/...`, `chore/...`).
- MR kieruj zgodnie z [CONTRIBUTING.md](../CONTRIBUTING.md); opisz co i dlaczego zmieniasz.

## Bezpieczeństwo i stan

- Nie commituj plików stanu Terraform/OpenTofu (`*.tfstate*`, katalog `.terraform/`) — są ignorowane w [.gitignore](../.gitignore).
- Nie commituj sekretów; wartości wrażliwe (tokeny providera) przekazuj przez zmienne środowiskowe lub secret manager CI.
- Gdy zmienna GitLab ma być maskowana/chroniona, ustaw `masked = true` / `protected = true` w definicji.

## Renovate

[renovate.json](../renovate.json) automatycznie aktualizuje zależności. Gdy ręcznie podbijasz wersję providera, zweryfikuj, że zmiana jest zgodna z regułami Renovate oraz zaktualizuj dokumentację w README (regeneruj `terraform-docs`).
