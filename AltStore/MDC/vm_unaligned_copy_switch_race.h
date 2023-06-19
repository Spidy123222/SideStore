#ifdef MDC
#pragma once
#include <stdlib.h>
#include <stdbool.h>
/// Uses CVE-2022-46689 to overwrite `overwrite_length` bytes of `file_to_overwrite` with `overwrite_data`, starting from `file_offset`.
/// `file_to_overwrite` should be a file descriptor opened with O_RDONLY.
/// `overwrite_length` must be less than or equal to `PAGE_SIZE`.
/// Returns `true` if the overwrite succeeded, and `false` if the device is not vulnerable.
bool unaligned_copy_switch_race(int file_to_overwrite, off_t file_offset, const void* overwrite_data, size_t overwrite_length);
#endif /* MDC */
