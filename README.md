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

## Action setup guide

### Pull Request from owned repository

.github/workflows/main.yml

```yml
name: checkpatch review
on: [pull_request]
jobs:
  my_review:
    name: checkpatch review
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v1
    - name: Run checkpatch review
      uses: webispy/checkpatch-action@master
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

The checkpatch action will posting comments for error/warning result to the PR conversation.

### Pull Request from forked repository

The Github action has a limitation that doesn't have write permission for PR from forked repository. So the action cannot write a comment to the PR.

.github/workflows/main.yml

```yml
name: checkpatch review
on: [pull_request]
jobs:
  my_review:
    name: checkpatch review
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v1
    - name: Run checkpatch review
      uses: webispy/checkpatch-action@master
```

You can find the error/waring result from Github action console log.

# License

Since the `checkpatch.pl` file is a script in the Linux kernel source tree, you must follow the [GPL-2.0](https://github.com/torvalds/linux/blob/master/COPYING) license, which is your kernel license.
