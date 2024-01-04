# Import the Invoke-WebRequest cmdlet
Import-Module Microsoft.PowerShell.Utility

# Define a function that takes a URL as input and returns a hashtable with the metadata
function Get-Metadata {
  # Get the URL parameter
  param($url)

  # Invoke the web request and get the response
  $response = Invoke-WebRequest -Uri $url

  # Check if the response is successful
  if ($response.StatusCode -eq 200) {
    # Define the selectors for the metadata elements
    $titleSelector = "head > title"
    $descriptionSelector = "meta[name=description]"
    $keywordsSelector = "meta[name=keywords]"

    # Extract the metadata from the response
    $title = $response.ParsedHtml.getElementsByTagName("title") | Select-Object -ExpandProperty innerText
    $description = $response.ParsedHtml.getElementsByTagName("meta") | Where-Object {$_.name -eq "description"} | Select-Object -ExpandProperty content
    $keywords = $response.ParsedHtml.getElementsByTagName("meta") | Where-Object {$_.name -eq "keywords"} | Select-Object -ExpandProperty content

    # Create a hashtable with the metadata
    $metadata = @{
      "url" = $url
      "title" = $title
      "description" = $description
      "keywords" = $keywords
    }

    # Return the metadata hashtable
    return $metadata
  } else {
    # Throw an error
    throw "Error: The request failed with status code $($response.StatusCode)"
  }
}

# Call the function with an example URL and print the result
$metadata = Get-Metadata -url "https://www.bing.com"
$metadata
