# Docker Environment 4 Joern Analysis

This Docker setup provides an isolated environment for analyzing C code using Joern, a powerful code analysis tool designed to identify vulnerabilities in code. Built on Ubuntu and including OpenJDK 19, this environment is tailored for secure and efficient code analysis.

## Prerequisites

Before you can build and use this Docker image, you must have Docker installed on your system. Docker version 19.03 or newer is recommended. You can download Docker from [here](https://www.docker.com/products/docker-desktop). Ensure your system meets the minimum requirements for running Docker.

## Building the Docker Image

Ensure you have a Dockerfile in your directory. The Dockerfile should be set up to install Joern and necessary dependencies on an Ubuntu base. To build the Docker image from the Dockerfile, run the following command:

```bash
docker build -t joern-analysis .
```

This command builds the Docker image with the tag `joern-analysis`, ready for use.

## Running the Container

To run the container and start analyzing your C code, use the following command:

```bash
docker run -it -v "${PWD}/src:/root/joern-cli/joern-cli/src" -v "${PWD}/out:/root/joern-cli/joern-cli/out" joern-analysis
```

This mounts your current directory’s `src` and `out` folders into the container, allowing Joern to access and output analysis results.

## Using Joern

Once the container is running, Joern CLI will start automatically. To begin analyzing your C code, follow these steps:

1. **Start the Joern shell**:
   ```bash
   ./joern
   ```

2. **Load your C code into Joern**:
   ```bash
   importCode("./src/code.c")
   ```

3. **Query the code**:
   Inside the Joern shell, run queries to analyze your code. For example:
   ```bash
   joern> val strcpyCalls = cpg.call("strcpy").l
   ```

This command lists all calls to the `strcpy` function, helping identify potential vulnerabilities.

### Advanced Analysis Examples

Here are some advanced queries you can run within the Joern environment to perform deeper analysis of your C code:

#### Create a Visualization of the CPG

1. **Generate the CPG**:
   ```bash
   ./joern-parse ./src/code.c
   ```
2. **Export the CPG**:
   ```bash
   ./joern-export --repr=all --format=dot --out ./out/output
   ```
3. **Visualize using this URL**:
   [GraphvizOnline](https://dreampuf.github.io/GraphvizOnline/)

#### Detailed Code Analysis

1. **Identifying `strcpy` Calls:**
   ```scala
   val strcpyCalls = cpg.call("strcpy").l
   ```
   This query retrieves all calls to the `strcpy` function within the codebase. It stores a list of these function calls for further analysis.

2. **Extracting Line Numbers:**
   ```scala
   val lineNumbers = strcpyCalls.map { strcpyCall =>
     val line = strcpyCall.lineNumber.l.headOption.getOrElse("Unknown")
     line
   }.l
   ```
   For each `strcpy` call, this part of the query extracts the line number where the call occurs. If the line number is not available, it defaults to "Unknown."

3. **Determining Destination Types:**
   ```scala
   val destTypes = strcpyCalls.map { strcpyCall =>
     val destType = strcpyCall.argument(1).typ.fullName.l.headOption.getOrElse("Unknown")
     destType
   }.l
   ```
   This segment analyzes the data type of the first argument to `strcpy` (the destination buffer), helping to identify what type of data the buffer is expected to hold.

4. **Determining Source Types:**
   ```scala
   val srcTypes = strcpyCalls.map { strcpyCall =>
     val srcType = strcpyCall.argument(2).typ.fullName.l.headOption.getOrElse("Unknown")
     srcType
   }.l
   ```
   Similarly, this part fetches the data type of the second argument (the source buffer) of each `strcpy` call.

5. **Aggregating Extracted Details:**
   ```scala
   val extractedDetails = (lineNumbers, destTypes, srcTypes).zipped.toList.map {
     case (line, destType, srcType) => (line, destType, srcType)
   }
   ```
   It combines the line numbers, destination types, and source types into a list of tuples for paired analysis.

6. **Identifying Type Mismatches:**
   ```scala
   val typeMismatches = extractedDetails.filter { case (line, destType, srcType) => destType != srcType }
   ```
   This query filters the list to find instances where the data types of the source and destination arguments differ, which could suggest a potential for type mismatches and buffer overflow vulnerabilities.

7. **Generating Warnings:**
   ```scala
   val warnings = typeMismatches.map { case (line, destType, srcType) =>
     s"Line $line: Mismatch, destType $destType, srcType $srcType, potential buffer overflow risk."
   }.l
   ```
   For each type mismatch found, this query constructs a warning message indicating the line number of the mismatch, the involved data types, and a note about the potential risk of buffer overflow.

Continue with similar detailed explanations for the other provided samples up to the "Generating Warnings" segment.

## Support

If you encounter issues with the Docker setup or Joern usage, consult the [Joern official documentation](https://docs.joern.io/) or file an issue on our [GitHub repository](https://github.com/joernio/joern).

## Acknowledgements

- Joern: https://joern.io
- OpenJDK: https://openjdk.java.net
- Ubuntu: https://ubuntu.com