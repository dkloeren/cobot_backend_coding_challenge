# Backend support engineer coding challenge

General Cobot concepts:

- Cobot customers are coworking spaces, so each customer is modeled as a `Space` on Cobot
- spaces have members, which are modeled as `Membership`s
- spaces have plans which determine how much each member has to pay.
- a plan is associated with each member via the `plan_id` when the membership is created
- memberships are invoiced regularly. one of the relevant fields is
  `first_invoice_at` which determines when a member's first invoice is sent
- memberships can be created/imported before they start. the `starts_at` field
  determines when a membership actually starts

You can find the Cobot API docs at https://www.cobot.me/api-docs.

Before you start:

This is a stripped-down Rails app to help you save time for your implementation.

- API credentials are hard-coded (see `ImportService`)
- no user authentication
- no CSS
- there is a class called `ImportService` that will take care of actually sending data to the Cobot API

The intended audience for this app is our internal support team.
You should spend not more than 4h on the tasks below.

Your tasks are as follows:

## Implement Excel upload

Our customers regularly want us to add members to their account in bulk. For that they send us Excel files with list of people. So far we've been doing this by hand, but now we want to automate this task. Your are tasked to implement an app that allows our support team to upload the Excel files sent by our customers and which then automatically imports the members into their Cobot account.

- add controllers, views etc. to let a user upload an Excel file (see the `fixtures` folder - you can assume that all Excel files will have the same structure as the one in the repo)
- - you must not make any changes to the Excel file
- add at least one test that demonstrates uploading a file and posting it to the API
  - we recommend using [Capybara](https://github.com/teamcapybara/capybara/blob/3.34_stable/README.md) to upload the file in the test
  - and [Webmock](https://github.com/bblimke/webmock/blob/master/README.md) to mock and assert that the data was sent to the API
  - [RSpec](https://relishapp.com/rspec) is already set up so we recommend using it for testing
- create a new git branch and submit your work by creating a PR aginst the `main` branch of this repository on GitHub
- you are only done once your PR's CI checks pass on GitHub Actions (see _.github/workflows/rubyci.yml_)

### Additional information

- the Excel file contains a column "Plan" which contains plan names, but the endpoint expects plan ids. You can pull plans via [our plans endpoint](https://www.cobot.me/api-docs/plans#list-plans).
- feel free to create a [free trial account](https://www.cobot.me/sign-up-space) on Cobot to explore in a live environment, but you can also just work with API stubs and fake data.

The `/membership_import` import endpoint (see `ImportService`) is a private endpoint and not publicly documented. It expects the following attributes as JSON:

```json
{
  "membership": {
    "address": {
      "name": "Mike Smith",
      "company": "Company",
      "full_address": "1189 Kafvuh Drive"
    },
    "phone": "(341) 638-5789",
    "email": "mail@domain.com",
    "plan": {
      "id": "59774b78-835e-5a76-a551-59efc2e1e3c5"
    },
    "starts_at": "2015/01/01",
    "first_invoice_at" "2015/01/10"
  }
}
```

- `address` is required
  - either `name` or `company` are required
  - `full_address` is required
- `plan` -> `id` is required
- `starts_at` is required
- `first_invoice_at` is required and must not be in the past and not before `starts_at`
- dates need to be formatted as `YYYY/MM/DD`

For any errors the endpoint will return a 422 HTTP status and a JSON document describing the error:

```json
{
  "errors": {
    "address": ["Name or company missing"]
  }
}
```

## Fix bug

The support team has now run several imports and it turns out that only some members have been imported. Find out what the problem is and find/implement a solution.

You can find a log of the import endpoint of the API in `docs/import.log` (personal information redacted).

- create a GitHub issue in this repo describing the problem, how you found it, where in the code it is and potential solutions
- implement _one_ solution and create a PR on top of your first PR describing how it solves the problem
- write a Ruby script that will re-import the members that were not imported according to the log
  - the script will be run in the Rails console of this app so you have access to all its code
  - attach the script to the GitHub issue as a comment
  - describe what the script will do as another comment on the issue
