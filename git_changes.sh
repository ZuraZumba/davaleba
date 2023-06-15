#!/bin/bash
# Check if the required arguments are provided
if [ $# -ne 2 ]; then
  echo "Usage: $0 <repository_url> <branch_name>"
  exit 1
fi

repository_url=$1
branch_name=$2

# Clone the repository if it doesn't exist
if [ ! -d "repo" ]; then
  git clone $repository_url repo
fi

# Change to the repository directory
cd repo || exit

# Checkout the specified branch
git checkout $branch_name


# Function to check for changes and output commit hashes
check_changes() {
  local latest_commit_hash=""
  local current_commit_hash=""

  while true; do
    # Fetch the latest changes from the remote repository
    git fetch

    # Get the latest commit hash for the branch
    latest_commit_hash=$(git rev-parse origin/$branch_name)

    # Check if the commit hash has changed
    if [[ "$latest_commit_hash" != "$current_commit_hash" ]]; then
      # Output the commit hashes
      git log --pretty=format:"%h" --no-merges $current_commit_hash..$latest_commit_hash
      current_commit_hash=$latest_commit_hash
    fi

    # Sleep for 15 seconds
    sleep 3 
    echo "checking"
  done
}

# Call the function to check for changes
check_changes

