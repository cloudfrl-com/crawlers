// Import the net/http and golang.org/x/net/html packages
import (
	"fmt"
	"net/http"
	"strings"

	"golang.org/x/net/html"
)

// Define a function that takes a URL as input and returns a map with the metadata
func getMetadata(url string) (map[string]string, error) {
	// Make a GET request and check for errors
	resp, err := http.Get(url)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	// Parse the HTML response and check for errors
	doc, err := html.Parse(resp.Body)
	if err != nil {
		return nil, err
	}

	// Define the selectors for the metadata elements
	titleSelector := "head > title"
	descriptionSelector := "meta[name=description]"
	keywordsSelector := "meta[name=keywords]"

	// Create a map to store the metadata
	metadata := make(map[string]string)

	// Define a recursive function to traverse the HTML tree
	var traverse func(*html.Node)
	traverse = func(n *html.Node) {
		// If the node is an element
		if n.Type == html.ElementNode {
			// If the node matches the title selector
			if n.Data == "title" && strings.Contains(titleSelector, n.Parent.Data) {
				// Get the text content of the node
				if n.FirstChild != nil {
					metadata["title"] = n.FirstChild.Data
				}
			}
			// If the node matches the meta selector
			if n.Data == "meta" {
				// Get the name and content attributes of the node
				var name, content string
				for _, a := range n.Attr {
					if a.Key == "name" {
						name = a.Val
					}
					if a.Key == "content" {
						content = a.Val
					}
				}
				// If the name matches the description or keywords selector
				if name == "description" && descriptionSelector == "meta[name=description]" {
					metadata["description"] = content
				}
				if name == "keywords" && keywordsSelector == "meta[name=keywords]" {
					metadata["keywords"] = content
				}
			}
		}
		// Recursively visit the child nodes
		for c := n.FirstChild; c != nil; c = c.NextSibling {
			traverse(c)
		}
	}

	// Start the traversal from the root node
	traverse(doc)

	// Return the metadata map
	return metadata, nil
}

// Call the function with an example URL and print the result
func main() {
	metadata, err := getMetadata("https://www.cloudfrl.com")
	if err != nil {
		fmt.Println(err)
	} else {
		fmt.Println(metadata)
	}
}
