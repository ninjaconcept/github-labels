Import common GitHub labels
===

Every project in your organization usually has a common set of labels specific to the organization.
Setting up new projects and making sure they have the same set of labels is annoying and error-prone. Therefore this tool lets you define these labels in a YAML file and automatically imports them to a new project.


How to use it:
---

1. Define the labels for your repository in `default_labels.yml`.
2. Run `./label_import.rb` and provide username, password, organization and repository using the interactive shell.
