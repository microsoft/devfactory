# Using the GitHub Coding Agent with Dev Factory

This documents how to use the GitHub Coding Agent to implement terraform modules.

## Configure MCP Servers

Before starting, go to your `https://github.com/org/repo/settings/copilot/coding_agent` and configure the MCP servers.

```json
{
    "mcpServers": {
        "Terraform-MCP-Server": {
            "type": "local",
            "command": "docker",
            "args": [
                "run",
                "-i",
                "--rm",
                "hashicorp/terraform-mcp-server"
            ],
            "tools": ["*"]
        },
        "Azure-MCP-Server": {
            "type": "local",
            "command": "npx",
            "args": [
                "-y",
                "@azure/mcp@0.0.21",
                "server",
                "start"
            ],
            "tools": ["*"]
        }
    }
}
```

## Assigning Issues to the GitHub Coding Agent

1. Create a new issue using the [New Dev Factory Terraform Module](/.github/ISSUE_TEMPLATE/new_tf_module.md) template.

2. Replace REPLACE_WITH_MODULE_NAME with the module name that you want to implement. For example `dev_center_project_environment_type`. (Note: This template should automatically assign the issue to `Copilot` with label `enhancement`).

3. Assign the issue to Copilot

4. Click Create

5. Monitor or have a break, wait for GitHub Copilot to finish the implementation

6. Review the PR submitted by Copilot by
    1. Fetching the PR code change by the coding agent and opening it in VSCode
    2. Switching to the `aztf-agent`
    3. and running `/3-apply {module_name}`.

7. If everything is in order, approve and merge the PR, close the issue.
