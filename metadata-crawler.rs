// Import the reqwest and scraper libraries
use reqwest::Url;
use scraper::{Html, Selector};

// Define a function that takes a URL as input and returns a Result with the metadata
async fn get_metadata(url: &str) -> Result<(), Box<dyn std::error::Error>> {
    // Parse the URL and make a GET request
    let url = Url::parse(url)?;
    let response = reqwest::get(url.clone()).await?;

    // Check if the response is successful
    if response.status().is_success() {
        // Parse the HTML body
        let html = Html::parse_document(&response.text().await?);

        // Define the selectors for the metadata elements
        let title_selector = Selector::parse("head > title").unwrap();
        let description_selector = Selector::parse("meta[name=description]").unwrap();
        let keywords_selector = Selector::parse("meta[name=keywords]").unwrap();

        // Extract the metadata from the HTML
        let title = html.select(&title_selector).next().map(|e| e.text().collect::<String>());
        let description = html.select(&description_selector).next().and_then(|e| e.value().attr("content"));
        let keywords = html.select(&keywords_selector).next().and_then(|e| e.value().attr("content"));

        // Print the metadata
        println!("URL: {}", url);
        println!("Title: {:?}", title);
        println!("Description: {:?}", description);
        println!("Keywords: {:?}", keywords);
    } else {
        // Print the error status
        println!("Error: {}", response.status());
    }

    Ok(())
}

// Call the function with an example URL
#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    get_metadata("https://www.bing.com").await
}
