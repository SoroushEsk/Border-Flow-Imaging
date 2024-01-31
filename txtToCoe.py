def convert_to_coe(input_file, output_file, data_width):
    with open(input_file, 'r') as f:
        lines = f.readlines()

    with open(output_file, 'w') as f:
        f.write(f"memory_initialization_radix=2;\n")
        f.write(f"memory_initialization_vector=\n")

        for line in lines:
            # Assuming the input data is in binary format in the text file
            binary_data = line.strip()
            
            # Ensure the binary data has the correct width
            binary_data = binary_data.zfill(data_width)

            # Write the binary data to the COE file
            f.write(f"{binary_data},\n")

if __name__ == "__main__":
    input_file = "image2.txt"
    output_file = "image2.coe"
    data_width = 64  # Adjust this based on your actual data width

    convert_to_coe(input_file, output_file, data_width)
