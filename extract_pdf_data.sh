#!/bin/bash

# Define the output directory
OUTPUT_DIR="extracted_output"
IMAGE_DIR="$OUTPUT_DIR/extracted_images"

# Create the directories if they don't exist
mkdir -p "$OUTPUT_DIR"

echo "📂 Created output directory: $OUTPUT_DIR"

# 🔐 Check encryption status before extracting anything
qpdf --show-encryption input.pdf > "$OUTPUT_DIR/encryption_info.txt"
echo "🔐 Encryption info saved to: $OUTPUT_DIR/encryption_info.txt"

# 🔓 Attempt to remove copy protection if needed
qpdf --decrypt input.pdf "$OUTPUT_DIR/unlocked.pdf"
echo "🔓 Unlocked version saved as: $OUTPUT_DIR/unlocked.pdf"

# Use the unlocked version for extraction if it was created successfully
INPUT_FILE="$OUTPUT_DIR/unlocked.pdf"
if [ ! -s "$INPUT_FILE" ]; then
    INPUT_FILE="input.pdf"  # Fallback to original if unlocking failed
fi

echo "📄 Using file: $INPUT_FILE for extraction"

# Ask if the user wants to extract any images (from both HTML conversion and PDF extraction)
read -p "Do you want to extract ANY images (png, jpg) from the PDF? (y/n): " extract_images

# Extract XML representation of the PDF
pdftohtml -xml "$INPUT_FILE" "$OUTPUT_DIR/extracted_content.xml"

# Extract PDF to HTML (skip images if user said no)
if [[ "$extract_images" == "y" ]]; then
    mkdir -p "$IMAGE_DIR"  # Only create the image folder if needed
    pdftohtml -c -noframes -q "$INPUT_FILE" "$OUTPUT_DIR/extracted_html.html"
else
    pdftohtml -noframes -q "$INPUT_FILE" "$OUTPUT_DIR/extracted_html.html"
    echo "🚫 Skipped extracting images from HTML conversion"
fi

# Extract all PDF objects (fonts, images, JavaScript, annotations, etc.)
qpdf --qdf --object-streams=disable "$INPUT_FILE" "$OUTPUT_DIR/extracted_objects.pdf"

# Extract only text from the PDF
pdftotext "$INPUT_FILE" "$OUTPUT_DIR/extracted_text.txt"

# Extract structured XML-based content
tika --xml "$INPUT_FILE" > "$OUTPUT_DIR/extracted_tika.xml"

# Extract embedded XMP metadata
exiftool -X "$INPUT_FILE" > "$OUTPUT_DIR/extracted_xmp.xml"

# Extract all document structure, objects, metadata into JSON
qpdf --json "$INPUT_FILE" > "$OUTPUT_DIR/output.json"

# Extract images using pdfimages only if user agreed
if [[ "$extract_images" == "y" ]]; then
    mkdir -p "$IMAGE_DIR"
    pdfimages -all "$INPUT_FILE" "$IMAGE_DIR/image"
else
    echo "🚫 Skipped extracting images from PDF"
fi

# 🔥 DELETE images if they were extracted by mistake when images were disabled
if [[ "$extract_images" == "n" ]]; then
    rm -f "$OUTPUT_DIR/"*.png "$OUTPUT_DIR/"*.jpg
fi

echo "✅ All files extracted into: $OUTPUT_DIR"
if [[ "$extract_images" == "y" ]]; then
    echo "🖼 All images are stored in: $IMAGE_DIR"
else
    echo "🚫 No images were extracted"
fi
