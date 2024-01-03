// Import the axios and cheerio libraries
const axios = require("axios");
const cheerio = require("cheerio");

// Define a function that takes a URL as input and returns a promise with the metadata
function getMetadata(url) {
  // Make a GET request and parse the HTML response
  return axios.get(url).then((response) => {
    const html = response.data;
    const $ = cheerio.load(html);

    // Define the selectors for the metadata elements
    const titleSelector = "head > title";
    const descriptionSelector = "meta[name=description]";
    const keywordsSelector = "meta[name=keywords]";

    // Extract the metadata from the HTML
    const title = $(titleSelector).text();
    const description = $(descriptionSelector).attr("content");
    const keywords = $(keywordsSelector).attr("content");

    // Return an object with the metadata
    return {
      url: url,
      title: title,
      description: description,
      keywords: keywords,
    };
  });
}

// Call the function with an example URL and print the result
getMetadata("https://www.bing.com")
  .then((metadata) => {
    console.log(metadata);
  })
  .catch((error) => {
    console.error(error);
  });
