Certainly! Here’s the revised version:

---

### README for Image Encoding and Decoding Project

---

#### Overview

This project involves developing an image encoding and decoding system utilizing the Code Chain algorithm. The aim is to effectively encode and describe the edges of objects within an image, with the system comprising an encoder and a decoder that communicate via UART.

#### Project Structure

- **Encoder Code Chain**: Encodes the edges of objects within an image by following the Code Chain algorithm.
- **Decoder Code Chain**: Decodes the received data to reconstruct the original image.
- **UART Communication**: Handles the transmission of encoded data between the encoder and decoder modules.

#### Code Chain Algorithm

1. **Edge Detection**: The algorithm starts by identifying the initial edge pixel of an object in the image.
2. **Direction Encoding**: Each edge pixel is encoded based on one of eight possible directional vectors (refer to Figure 1 in the original description).
3. **Sequential Processing**: The algorithm processes each edge pixel in sequence, encoding the direction of movement until it returns to the starting pixel.
4. **Priority Rules**:
   - The algorithm prefers counterclockwise movement.
   - Right and top edges are prioritized over other edges.
   - Direction 0 has the highest priority, while direction 7 has the lowest.

#### Implementation Details

*   **Input Ports**:
    *   **Reset**: Resets the entire module.
    *   **CLK**: The main clock signal for synchronizing hardware operations.
    *   **Start**: Initiates the encoding or decoding process on the provided image.
*   **Output Ports**:
    *   **Code**: Outputs the generated encoded data.
    *   **Done**: Signals the completion of the encoding or decoding process.
    *   **Error**: Indicates the presence of any errors during processing.
    *   **Perimeter**: Outputs the calculated perimeter of the object in the image based on edge pixels.
    *   **Area**: Outputs the calculated area of the object, i.e., the number of illuminated pixels in the image.
    *   **Pixel Start**: Outputs the coordinates of the first detected edge pixel.

#### Hardware Implementation

*   **Encoder**:
    *   Reads binary image data from memory.
    *   Encodes the image by implementing the Code Chain algorithm.
    *   Transmits the encoded data to the decoder using UART communication.
*   **Decoder**:
    *   Receives the encoded data via UART.
    *   Decodes the received data to reconstruct the original image.

#### UART Communication Specifications

*   **Clock Frequency**: 50 MHz
*   **Communication Protocol**: UART is used for serial communication between the encoder and decoder.

#### Sample Images and Testing

*   Provide sample binary images in a compatible format (e.g., MATLAB or Python).
*   Store pixel data in a file and load it into the appropriate memory block (ipcore) for processing.

#### Project Delivery

1.  **Module Implementation**: Implement all necessary sub-modules for the encoder, decoder, and UART components.
2.  **Report Submission**: Submit a detailed report that explains the functionality of each sub-module and includes simulation results.
3.  **Project Files**: Include all source codes for the sub-modules and associated testbenches.
4.  **Group Work**: If the project is done in pairs, the report should clearly state the contributions of each group member.

---

This version provides a more polished and structured description of the project and its requirements.
