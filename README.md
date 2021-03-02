<div align="center">

# asdf-swiftformat ![Build](https://github.com/younke/asdf-swiftformat/workflows/Build/badge.svg) ![Lint](https://github.com/younke/asdf-swiftformat/workflows/Lint/badge.svg)

[SwiftFormat](https://github.com/nicklockwood/SwiftFormat) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Why?](#why)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `bash`, `curl`, `zip`: generic POSIX utilities.

# Install

Plugin:

```shell
asdf plugin add swiftformat
# or
asdf plugin add swiftformat https://github.com/younke/asdf-swiftformat.git
```

swiftformat:

```shell
# Show all installable versions
asdf list-all swiftformat

# Install specific version
asdf install swiftformat latest

# Set a version globally (on your ~/.tool-versions file)
asdf global swiftformat latest

# Now swiftformat commands are available
swiftformat --help
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/younke/asdf-swiftformat/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Vasily Ptitsyn](https://github.com/younke/)
