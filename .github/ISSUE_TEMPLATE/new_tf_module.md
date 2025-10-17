---
name: 'New Dev Factory Terraform Module'
about: 'Assign a new Dev Factory tf module implementation task to the GitHub Copilot Coding Agent'
title: 'Implement {module_name}'
labels: 'enhancement'
assignees: 'copilot-swe-agent[bot]'
---

Your goal is to implement the specified terraform module by following the steps below.

## Module to implement
module_name=REPLACE_WITH_MODULE_NAME

## STEPS
1. Read and follow the instructions in `.github/copilot-instructions.md`.
2. Create an implementation plan by running `/1-plan {module_name}`. This follows the prompt in `.github/prompts/1-plan.prompt.md` and outputs a new file: {module_name}.plan.md
3. Implement the created implementation plan by running `/2-implement #file:docs/plans/{module_name}.plan.md`. This follows the prompt in `.github/prompts/2-implement.prompt.md` for the plan created in step 2.