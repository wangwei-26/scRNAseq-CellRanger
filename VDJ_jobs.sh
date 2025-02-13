#!/bin/bash

########generate CellRanger jobs for submission for all samples#######

# Initialize variables
sequencing_directory=""
reference_location=""

# Parse named parameters
for arg in "$@"; do
  case $arg in
    --sequencing_directory=*)
      sequencing_directory="${arg#*=}"
      ;;
    --reference_location=*)
      reference_location="${arg#*=}"
      ;;
    *)
      echo "Invalid parameter: $arg"
      exit 1
      ;;
  esac
done

# Check if required parameters are provided
if [ -z "$sequencing_directory" ]; then
  echo "Error: sequencing_directory parameter is missing."
  exit 1
fi
if [ -z "$reference_location" ]; then
  echo "Error: reference_location parameter is missing."
  exit 1
fi

# Check if the sequencing_folder exists
if [ ! -d "$sequencing_folder" ]; then
  echo "Error: sequencing_folder does not exist."
  exit 1
fi

# Check if the reference_location exists
if [ ! -d "$reference_location" ]; then
  echo "Error: reference_location=$reference_location does not exist."
  exit 1
fi

# Create an empty array to store the extracted names
names=()

# Extract names from each file ***no '_' in sample names please!
for file in "$sequencing_directory"/*; do
  name=$(basename "$file" | cut -d '_' -f 1)
  names+=("$name")
done

# Remove duplicates from the array
unique_names=($(printf "%s\n" "${names[@]}" | sort -u))

# Create the CellRanger_jobs folder if it doesn't exist
jobs_folder="CellRanger_jobs"
mkdir -p "$jobs_folder"
cd "$jobs_folder"

# Generate and submit CellRanger VDJ jobs for all samples
for name in "${unique_names[@]}"; do
  job_name="$name"
  output_file="$name.out"
  error_file="$name.err"

  job_script="#!/bin/bash -l\n\n\
#\$ -o $output_file\n\
#\$ -e $error_file\n\
#\$ -N $job_name\n\
#\$ -cwd\n\
#\$ -q all.q\n\
#\$ -l mfree=64G\n\
#\$ -pe smp 2\n\n\
module load cellranger/7.1.0\n\
cellranger vdj --id=$job_name --reference=$reference_location --fastqs=../$sequencing_folder/$project_name/ --sample=$job_name --localcores=2 --localmem=64"

  # Save the job as an individual shell script in CellRanger_jobs folder
  job_file="$name.CellRanger.sh"
  echo -e "$job_script" > "$job_file"

  # Submit the job
  qsub "$job_file"
  
  echo "Submission job generated and added to CellRanger_jobs for $name"
done
