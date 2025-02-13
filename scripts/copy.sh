#!/bin/bash

##### Copy sequencing result to the working directory ######

# Initialize variables
source_directory=""
destination_directory=""

# Parse named parameters
for arg in "$@"; do
  case $arg in
    --source_directory=*)
      source_directory="${arg#*=}"
      ;;
    --destination_directory=*)
      destination_directory="${arg#*=}"
      ;;
    *)
      echo "Invalid parameter: $arg"
      exit 1
      ;;
  esac
done

# Check if required parameters are provided
if [ -z "$source_directory" ]; then
  echo "Error: source directory is missing."
  exit 1
fi

if [ -z "$destination_directory" ]; then
  echo "Error: destination directory is missing."
  exit 1
fi

# Create the destination directory if it doesn't exist
mkdir -p "$destination_directory"

# Copy the source directory to the destination directory using rsync
rsync -avz --progress "$source_directory" "$destination_directory"

# Display a message indicating the completion of the copy
echo "Directory copied successfully!"
