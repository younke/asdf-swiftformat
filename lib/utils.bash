#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/nicklockwood/SwiftFormat"
TOOL_NAME="swiftformat"
TOOL_TEST="swiftformat --help"

fail() {
	echo -e "asdf-$TOOL_NAME: $*"
	exit 1
}

# Detect platform and return download details
# Returns: "macos" | "linux" or fails
get_platform() {
	local kernel
	kernel="$(uname -s)"

	case "$kernel" in
	Darwin)
		echo "macos"
		;;
	Linux)
		echo "linux"
		;;
	*)
		fail "Unsupported OS: $kernel"
		;;
	esac
}

# Returns the binary name for the current platform and architecture
get_binary_name() {
	local platform arch
	platform="$(get_platform)"
	arch="$(uname -m)"

	case "$platform" in
	macos)
		echo "swiftformat"
		;;
	linux)
		case "$arch" in
		aarch64)
			echo "swiftformat_linux_aarch64"
			;;
		*)
			echo "swiftformat_linux"
			;;
		esac
		;;
	esac
}

curl_opts=(-fsSL)

if [ -n "${GITHUB_TOKEN:-}" ]; then
	curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_TOKEN")
fi

sort_versions() {
	sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
		LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
	git ls-remote --tags --refs "$GH_REPO" |
		grep -o 'refs/tags/.*' | cut -d/ -f3- |
		sed 's/^v//'
}

list_all_versions() {
	list_github_tags
}

download_release() {
	local version filename url binary_name
	version="$1"
	filename="$2"
	binary_name="$(get_binary_name)"

	url="$GH_REPO/releases/download/${version}/${binary_name}.zip"

	echo "* Downloading $TOOL_NAME release $version..."
	curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
	local install_type="$1"
	local version="$2"
	local install_path="${3%/bin}/bin"

	if [ "$install_type" != "version" ]; then
		fail "asdf-$TOOL_NAME supports release installs only"
	fi

	(
		mkdir -p "$install_path"

		local binary_name
		binary_name="$(get_binary_name)"

		# Copy binary from download path
		cp "${ASDF_DOWNLOAD_PATH}/${binary_name}" "$install_path/${TOOL_NAME}"

		local tool_cmd
		tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
		test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

		echo "$TOOL_NAME $version installation was successful!"
	) || (
		rm -rf "$install_path"
		fail "An error occurred while installing $TOOL_NAME $version."
	)
}
