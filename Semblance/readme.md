# Common Errors in Ollama

## Memory Related
- "Model requires more system memory" when running in Docker containers
- CUDA OOM (Out of Memory) errors when using vision models
- Memory allocation issues with multiple GPUs

## Pointer/Runtime Errors  
- Unsafe pointer errors (e.g. "unsafe.Slice: ptr is nil and len is not zero")
- Segmentation faults when using multiple GPUs
- Connection refused errors between containerized components

## Model Loading Issues
- Inconsistent results between different API endpoints
- Error code 500 crashes when using specific models via API
- Unknown GGML assertion failures during model execution

## GPU Related
- CUDA device ordering inconsistency between runtime and management
- Token generation issues with dual GPUs
- System crashes when running with certain GPU configurations

## Installation/Configuration
- Windows installer compatibility problems
- WSL-specific issues on Windows
- Root/sudo requirement concerns on Linux

## Best Practices to Avoid Common Errors
1. Ensure sufficient system memory (16GB+ recommended)
2. Properly configure Docker memory limits
3. Check GPU compatibility and drivers
4. Verify network connectivity between components
5. Follow platform-specific installation guides
6. Monitor resource usage during model runs