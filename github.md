# GitHub

## Organizations
```
# get id, repos_url, events_url, hooks_url, issues_url, members_url, description, name, disk_usage, plan
curl -Ss https://<username>:<token>@<github-hostname>/api/v3/orgs/<org-name>

curl -iSs -X GET -u <username>:<token> -H "Accept: application/vnd.github+json" https://github.company.com/api/v3/orgs/<org-name>/repos
```

## Repositories
```
curl -iSs -X GET -u <username>:<token> -H "Accept: application/vnd.github+json" https://github.company.com/api/v3/repos/<org-name>/<repo-name>
```

## Actions
```
name: <name>
on:
  workflow_call:
    inputs:
      <input-name>:
        required: false
        type: string
        default: "0"
    secrets:
      <repo-actions-secret-name>:
        required: true
concurrency:
  group: ${{ github.ref }}
# permissions for the automatically generated short-lived install access token named GITHUB_TOKEN
# issued by the github-actions app scoped to the repository of the workflow
permissions:
  contents: read
env:
  <env-var-name>: ${{ inputs.<input-name> }}
jobs:
  <job-id>:
    if: ${ github.event.pull_request.merged == true }
    name: "<job-name>"
    runs-on: [ <autoscalingrunnerset-name> ]
    env:
      <job-env-var-name>: ${{ secrets.<repo-actions-secret-name> }}
    steps:
      - name: "<step-name>"
        env:
          <step-env-var-name>: ${{ secrets.<repo-actions-secret-name> }}
        shell: bash
        run: |
          ls -lah
          pwd
          # Define in job or step env: block
          # RUNNER variables
          echo "RUNNER_GITHUB_USER=${RUNNER_GITHUB_USER}" >> "${GITHUB_ENV}"
          echo "RUNNER_GITHUB_TOKEN=${RUNNER_GITHUB_TOKEN}" >> "${GITHUB_ENV}"
          # GITHUB variables
          echo "GITHUB_WORKFLOW=${GITHUB_WORKFLOW}" >> "${GITHUB_ENV}"
          echo "GITHUB_RUN_NUMBER=${GITHUB_RUN_NUMBER}" >> "${GITHUB_ENV}"
      - name: "Checkout repo"
        uses: actions/checkout@v4
        with:
          # ref: ${{ github.event.pull_request.base.ref }}
          fetch-depth: 0
          fetch-tags: true
          token: ${{ secrets.<repo-actions-secret-name> }}
      - name: "Checkout <org>/<repo>"
        uses: actions/checkout@v4
        with:
          repository: <org>/<repo>
          ref: main
          token: ${{ secrets.<repo-actions-secret-name> }}
          path: <repo>
      - name: "Checkout shared actions"
        uses: actions/checkout@v4
        with:
          repository: <org>/.github
          ref: "v1"
          token: ${{ secrets.<repo-actions-secret-name> }}
          path: .shared-actions
      - name: "Get secrets from AWS"
        uses: ./.shared-actions/.github/actions/get-aws-secrets
        with:
          shell: bash
          secret-id: <prefix>/github-secrets
          keys: |
            AWS_ACCESS_KEY_ID
            AWS_SECRET_ACCESS_KEY
            AWS_ROLE_ARN_ECR_PUSHPULL
            TU_DOCKERHUB_USER
            TU_DOCKERHUB_PW
            TU_REDHAT_USER
            TU_REDHAT_PW
            RUNNER_EMAIL
            RUNNER_GITHUB_USER=RUNNER_USER
            GH_PUBLIC_TOKEN
      - name: "Cleanup resources"
        if: always()
        run: cleanup.sh
  notify:
    runs-on: [ <autoscalingrunnerset-name> ]
    needs: <job-id>
    if: failure()
    steps:
      - name: Send notification
        run: |
          echo "TODO: send notification about failed build"
```
