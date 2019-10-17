# Github action for `checkpatch.pl`

The `checkpatch.pl` is a perl script to verify that your code conforms to the Linux kernel coding style. This project uses `checkpatch.pl` to automatically review and leave comments on pull requests.

## Resources

Following files are used to this project.

- https://raw.githubusercontent.com/torvalds/linux/master/scripts/checkpatch.pl
- https://raw.githubusercontent.com/torvalds/linux/master/scripts/spelling.txt

## Patch

### add option for excluding directories

From [zephyr](https://github.com/zephyrproject-rtos/zephyr) project:

- https://github.com/zephyrproject-rtos/zephyr/commit/92a12a19ae5ac5fdf441c690c48eed0052df326d

### Disable warning for "No structs that should be const ..."

- https://github.com/nugulinux/docker-devenv/blob/master/patches/0002-ignore_const_struct_warning.patch
