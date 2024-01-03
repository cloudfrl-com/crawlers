#!/bin/bash

# Define a function that takes a URL as input and prints the metadata
get_metadata() {
  # Use curl to get the HTML response
  html=$(curl -s "$1")

  # Use grep and sed to extract the metadata elements
  title=$(echo "$html" | grep -oP '(?<=<title>).*(?=</title>)' | sed 's/'/\x27/g')
  description=$(echo "$html" | grep -oP '(?<=<meta name="description" content=").*(?=")' | sed 's/'/\x27/g')
  keywords=$(echo "$html" | grep -oP '(?<=<meta name="keywords" content=").*(?=")' | sed 's/'/\x27/g')

  # Print the metadata
  echo "URL: $1"
  echo "Title: $title"
  echo "Description: $description"
  echo "Keywords: $keywords"
}

# Call the function with an example URL
get_metadata "https://www.cloudfrl.com"
