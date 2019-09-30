# Query Github Repositories using GraphQL
This is an iOS application that queries Github repositories with the given search term using GraphQL

## Installation
To clone the Git repository to your local machine, including submodules:

```sh
git clone --recursive https://github.com/dileepkumarkotha/QueryGithubRepositoriesUsingGraphQL.git
```

## Dependencies
Make sure you have CocoaPods installed and then run:
```sh
pod install
```

## Starting the app

- You need to go to the [Github developer settings](https://github.com/settings/tokens), get your OAuth token with repo scope and set it to `githubToken` property of `Apollo` class.

- You can then open `GithubQuery.xcworkspace` and press the run button to run the app. It should load a screen where you can input a search text and should be able to see list of repositories and display their owner avatar, name, owner login name and number of votes in a table view.

This is a basic demo app to demonstrate how you can hook up GraphQL query results to your UI.

## Build and Runtime Requirements

- Mac running MacOS 10.14 or later
- Xcode 10.2.1 and Swift 5


