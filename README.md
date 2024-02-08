# repoflatten
Flatten all files in a directory and subdirectories to a single file. Useful when feeding to chatgpt.

```
Examples:

# Flatten all, exclude hidden files by default
./flatten.sh --flatten

#Flatten all, exclude given patterns
./flatten.sh --flatten -i "./dir1/dir1_subdir2/*"

# Flatten all, include hidden files, exclude given patterns
./flatten.sh --flatten --include-hidden -i "./dir1/dir1_subdir2/*" -i "./dir2/*"
```
