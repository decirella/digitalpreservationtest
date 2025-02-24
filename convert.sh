#!/bin/bash

# Define filenames
MARKDOWN_FILE="input.md"
TEMPLATE_FILE="template.html"
OUTPUT_FILE="./public/index.html"

# Convert Markdown to HTML
HTML_CONTENT=$(pandoc "$MARKDOWN_FILE" -f markdown -t html)

# Extract list items and wrap them in checkbox containers
LIST_ITEMS=$(echo "$HTML_CONTENT" | grep -oP '(?<=<li>).+?(?=</li>)' | awk '{print "<div class=\"checkbox-container\"><label><input type=\"checkbox\" value=\"1\" onclick=\"calculateSum()\">" $0 "</label></div>"}' | tr '\n' '\0')

# Read the template
TEMPLATE=$(cat "$TEMPLATE_FILE")

# Replace placeholders with extracted content, ensuring proper escaping of special characters
TEMPLATE=$(printf "%s" "$TEMPLATE" | sed "s|<div id=\"checkboxList\"></div>|<div id=\"checkboxList\">$LIST_ITEMS</div>|")

# Write the final HTML to the output file
echo "$TEMPLATE" > "$OUTPUT_FILE"

echo "Conversion complete. Output written to $OUTPUT_FILE"
