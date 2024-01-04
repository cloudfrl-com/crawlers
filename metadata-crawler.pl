# Import the LWP::Simple and HTML::Parser modules
use LWP::Simple;
use HTML::Parser;

# Define a function that takes a URL as input and prints the metadata
sub get_metadata {
  # Get the URL parameter
  my $url = shift;

  # Get the HTML content from the URL
  my $content = get($url);

  # Check if the content is valid
  unless (defined $content) {
    print "Error: Could not get content from $url\n";
    return;
  }

  # Create a new HTML parser object
  my $parser = HTML::Parser->new;

  # Define the selectors for the metadata elements
  my $title_selector = "head > title";
  my $description_selector = "meta[name=description]";
  my $keywords_selector = "meta[name=keywords]";

  # Define variables to store the metadata values
  my $title;
  my $description;
  my $keywords;

  # Define a flag to indicate if the current element is a title
  my $is_title = 0;

  # Define a callback function to handle the start tag events
  $parser->handler(start => sub {
    # Get the tag name and attributes
    my ($tag, $attr) = @_;

    # If the tag is a title and it is inside the head element
    if ($tag eq "title" and $parser->in($title_selector)) {
      # Set the flag to true
      $is_title = 1;
    }

    # If the tag is a meta and it has a name attribute
    if ($tag eq "meta" and $attr->{name}) {
      # If the name is description and it matches the selector
      if ($attr->{name} eq "description" and $parser->in($description_selector)) {
        # Get the content attribute
        $description = $attr->{content};
      }

      # If the name is keywords and it matches the selector
      if ($attr->{name} eq "
