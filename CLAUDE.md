# CLAUDE.md

Plik pomocniczy dla asystentów AI (Claude Code) pracujących w tym repozytorium.

## Czym jest ten projekt

Moduł OpenTofu/Terraform `gitlab-project` zarządza projektami w GitLab: tworzy repozytorium, ustawia chronione gałęzie i tagi, reguły zatwierdzania MR, zmienne CI, harmonogramy pipeline'ów, środowiska, mirror oraz avatar na podstawie typu projektu.

- **Provider:** `gitlabhq/gitlab` w wersji `18.8.2`
- **Wymagany Terraform/OpenTofu:** `>= 1.10.5`
- **Język dokumentacji i komunikatów:** polski (commit messages mogą być po polsku lub angielsku — zgodnie z Conventional Commits)

## Dodatkowy kontekst dla AI

Pełniejszy kontekst oraz konwencje znajdują się w:

- [.llm/context.md](.llm/context.md) — architektura modułu, kluczowe pliki, wejścia/wyjścia, logika wbudowana
- [.llm/conventions.md](.llm/conventions.md) — konwencje kodu HCL, commitów, stylu, testowania

Zawsze zapoznaj się z oboma plikami przed większą zmianą w module.

## Szybkie wskazówki

- Główne zasoby zdefiniowane są w [main.tf](main.tf); logika warunkowa i scalanie map w [locals.tf](locals.tf); zmienne wejściowe w [variable.tf](variable.tf).
- Typy projektów (`project_type`) i powiązane z nimi domyślne tagi, avatar, zmienne CI, chronione gałęzie i tagi definiuje [data/allowed_project_types.json](data/allowed_project_types.json).
- Sekcja `<!-- BEGIN_TF_DOCS --> ... <!-- END_TF_DOCS -->` w [README.md](README.md) jest generowana automatycznie przez `terraform-docs` (konfiguracja: [.terraform-docs.yml](.terraform-docs.yml)) — nie edytuj jej ręcznie.
- Na zasobie `gitlab_project.project` ustawione jest `prevent_destroy = true` — nie próbuj usuwać projektu przez `tofu destroy`.
- Zmiany commituj zgodnie ze standardem Conventional Commits (patrz [CONTRIBUTING.md](CONTRIBUTING.md)).

## Czego nie robić

- Nie modyfikuj bloku generowanego przez `terraform-docs` — zmień zamiast tego dokumentację zmiennych/zasobów i wygeneruj blok ponownie.
- Nie dodawaj nowych providerów ani nie podbijaj wersji providera bez wyraźnej prośby.
- Nie usuwaj ani nie zmieniaj `lifecycle { prevent_destroy = true }` na `gitlab_project.project`.
- Nie commituj plików stanu (`*.tfstate`, `.terraform/`) — są ignorowane w [.gitignore](.gitignore).
