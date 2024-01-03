// Import the axios and cheerio libraries
import axios from "axios";
import cheerio from "cheerio";

// Define an interface for the metadata object
interface Metadata {
  url: string;
  title: string | null;
  description: string | null;
  keywords: string | null;
}

// Define a function that takes a URL as input and returns a promise with the metadata
async function getMetadata(url: string): Promise<Metadata> {
  // Make a GET request and parse the HTML response
  const response = await axios.get(url);
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
}

// Call the function with an example URL and print the result
getMetadata("https://www.bing.com")
  .then((metadata) => {
    console.log(metadata);
  })
  .catch((error) => {
    console.error(error);
  });
