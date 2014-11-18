Import common GitHub labels
===

Every project in your organization usually has a common set of labels specific to the organization.
Setting up new projects and making sure they have the same set of labels is annoying and error-prone. Therefore this tool lets you define these labels in a YAML file and automatically imports them to a new project.


How to use it:
---

1. Define the labels for your repository in `default_labels.yml`.
2. Run `./label_import.rb` and provide username, password, organization and repository using the interactive shell.

Meaning
---

| Shortcut | Meaning                         |
|----------|-------------------------------------|
| `T`      | **Type**: e.g. task, feature or bug |
| `B`      | **Blocker**: e.g. needs clarifying or reproduction steps before one can continue working on it                       |
| `D`      | **Difficulty**: easy or hard                                   |
| `P`      | **Priority**: high or low                                   |
| `S`      | **Status**: e.g. WIP                                   |
| `meta`      | **Meta**: Used for grouping several connected issues                                   |
