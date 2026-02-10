# Photocall

**Organize photo collections from multiple directories with automatic renaming and metadata generation**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Shell Script](https://img.shields.io/badge/Shell-POSIX-blue.svg)](https://www.gnu.org/software/bash/)
[![URJC](https://img.shields.io/badge/University-URJC-red.svg)](https://www.urjc.es/)

A POSIX-compliant shell script for creating organized photo collections with standardized naming conventions and detailed metadata.

## Description

`photocall.sh` scans multiple directories recursively for image files, copies them to a centralized collection directory with standardized naming conventions, and generates detailed metadata about the collection.

## Features

- Recursive directory scanning
- Support for multiple image formats (JPEG, PNG, TIFF)
- Automatic file renaming with parent directory context
- Extension normalization (.jpeg → .jpg, .PNG → .png)
- Space-to-dash conversion in filenames
- Collision detection with safe rollback
- Metadata generation with file sizes
- Sorted output by file size
- Handles filenames and paths with spaces

## Requirements

- POSIX-compliant shell (`sh`, `bash`, `dash`, etc.)
- Standard Unix utilities: `find`, `grep`, `sed`, `awk`, `sort`

Works on Linux, macOS, and BSD systems.

## Installation

```bash
git clone https://github.com/Jsanchezv2201/photocall.git
cd photocall
chmod +x photocall.sh
```

## Usage

```bash
./photocall.sh <collection_directory> <source_dir1> [source_dir2 ...]
```

### Arguments

- `<collection_directory>`: Target directory where the collection will be created
- `<source_dir1> [source_dir2 ...]`: One or more source directories containing photos

### Supported Image Formats

| Format | Extensions | Normalized Extension |
|--------|-----------|---------------------|
| JPEG   | `.jpg`, `.jpeg`, `.JPG`, `.JPEG` | `.jpg` |
| PNG    | `.png`, `.PNG` | `.png` |
| TIFF   | `.tiff`, `.TIFF` | `.tiff` |

## Examples

### Basic Usage

```bash
./photocall.sh collection d1 d2 d3
```

### With Absolute Paths

```bash
./photocall.sh /home/user/photos/collection /home/user/vacation /home/user/events
```

### Complete Example

**Before:**
```
.
├── collection/
├── d1/
│   ├── img01.JPEG
│   ├── img02.jpeg
│   └── img04.jpg
├── d2/
│   ├── img01.jpeg
│   └── img04.tiff
└── d3/
    └── verano/
        ├── avion.PNG
        ├── Cena de gala.png
        └── PLAYA.png
```

**Command:**
```bash
./photocall.sh collection d1 d2 d3
```

**After:**
```
collection/
├── d1_img01.jpg
├── d1_img02.jpg
├── d1_img04.jpg
├── d2_img01.jpg
├── d2_img04.tiff
├── metadata.txt
├── verano_avion.png
├── verano_cena-de-gala.png
└── verano_playa.png
```

**metadata.txt:**
```
d1_img02.jpg 3211
d1_img01.jpg 21124
d1_img04.jpg 21312
d2_img04.tiff 32345
verano_cena-de-gala.png 43233
d2_img01.jpg 56432
verano_playa.png 88944
verano_avion.png 434132
TOTAL: 700733 bytes
```

## Naming Convention

Files are renamed according to the following pattern:

```
<parent_directory>_<original_name>.<normalized_extension>
```

Where:
- `<parent_directory>`: The name of the immediate parent directory (lowercase, spaces → dashes)
- `<original_name>`: The original filename without extension (lowercase, spaces → dashes)
- `<normalized_extension>`: Standardized extension (`.jpg`, `.png`, or `.tiff`)

### Example Transformations

| Original Path | New Name |
|--------------|----------|
| `vacation/Beach Photo.JPEG` | `vacation_beach-photo.jpg` |
| `events/Birthday 2024.PNG` | `events_birthday-2024.png` |
| `archive/IMG_001.jpg` | `archive_img_001.jpg` |

## Behavior

### Collection Directory

- **Doesn't exist**: Created automatically
- **Exists and empty**: Used as-is
- **Exists and not empty**: All contents are deleted before creating the new collection

### Error Handling

The script terminates with an error exit code if:

1. **Insufficient arguments**: Less than 2 arguments provided
2. **Directory doesn't exist**: Any source directory is invalid
3. **Name collision**: Two files would have the same final name
   - All files are removed from the collection directory
   - An error message is displayed

### Success

On successful execution:
- No output is written to stdout
- Exit code is 0
- Collection directory contains all photos and `metadata.txt`

## Testing

Example test directories are provided in the repository:

```bash
# Run with test data
./photocall.sh collection d1 d2

# Check the results
ls -lh collection/
cat collection/metadata.txt
```

## Exit Codes

| Code | Meaning |
|------|---------|
| 0 | Success |
| 1 | Error (insufficient arguments, invalid directory, collision) |

## License

MIT License

## Contributing

Contributions are welcome. Feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## Author

**Juan Sánchez Vinuesa**

Universidad Rey Juan Carlos (URJC) - Operating Systems Course Project
