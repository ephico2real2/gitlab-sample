#!/bin/bash

# Check if branch ends with "hotfix"
if [[ ! "${CI_COMMIT_BRANCH}" =~ -hotfix$ ]]; then
  echo "This script should only run on branches ending with '-hotfix'. Exiting."
  exit 1
fi

# Checkout the current branch
git checkout "${CI_COMMIT_BRANCH}"

# Update the project version
current_version=$(mvn org.apache.maven.plugins:maven-help-plugin:3.2.0:evaluate -Dexpression=project.version -q -DForceStdout)
new_version="${current_version}-${CI_COMMIT_BRANCH}"
mvn versions:set -DnewVersion="${new_version}"
mvn versions:commit

# Add and commit the updated pom.xml file
git config user.email "gitlab@example.com"
git config user.name "GitLab CI"
git add pom.xml
git commit -m "Update project version to ${new_version}"

# Create tag and push to remote repository
git tag "${CI_COMMIT_BRANCH}-${new_version}"
git push origin "${CI_COMMIT_BRANCH}-${new_version}"
