# Github action for `checkpatch.pl`

The `checkpatch.pl` is a perl script to verify that your code conforms to the Linux kernel coding style. This project uses `checkpatch.pl` to automatically review and leave comments on pull requests.

## Screenshots

### Result of checkpatch

![check](https://raw.githubusercontent.com/wiki/webispy/checkpatch-action/img/action_conversation_check.png)

### Code annotations

![annotations](https://raw.githubusercontent.com/wiki/webispy/checkpatch-action/img/action_annotations.png)

## Action setup guide

### Pull Request

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

Due to the above limitations, you can check the comments directly in the console log.

![console log](https://raw.githubusercontent.com/wiki/webispy/checkpatch-action/img/action_console.png)

## References

### checkpatch tool

Following files are used to this project.

- https://raw.githubusercontent.com/torvalds/linux/master/scripts/checkpatch.pl
- https://raw.githubusercontent.com/torvalds/linux/master/scripts/spelling.txt

### Patch

#### Add option for excluding directories

From [zephyr](https://github.com/zephyrproject-rtos/zephyr) project:

- https://github.com/zephyrproject-rtos/zephyr/commit/92a12a19ae5ac5fdf441c690c48eed0052df326d

#### Disable warning for "No structs that should be const ..."

- https://github.com/nugulinux/docker-devenv/blob/master/patches/0002-ignore_const_struct_warning.patch

### Docker image

You can find the Dockerfile from [docker](https://github.com/webispy/checkpatch-action/tree/docker) branch of this repository.

## License

The `checkpatch.pl` file is a script in the Linux kernel source tree, so **checkpatch-action** projects and forked projects must comply with the GPL-2.0 license (kernel license).
