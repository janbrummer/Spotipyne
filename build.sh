#!/bin/sh

dir="$(dirname "$(readlink -f "$0" )" )"
buildDir="${dir}/build"

die() {
	printf '%s\n' "$1"
	exit 1
}

not_installed() {
	die "$1 needs to be installed to build this."
}

check_installed_bin() {
	which "$1" || not_installed "$1"
}

check_installed_lib() {
	pkg-config "$1" || not_installed "$1"
}


as_flatpak() {
	check_installed_bin dex
	check_installed_bin flatpak-builder
	check_installed_bin flatpak

	flatpak-builder --force-clean "${buildDir}" xyz.merlinx.Spotipyne.json
	dex "${buildDir}/export/share/applications/xyz.merlinx.Spotipyne.desktop"
}

as_bin() {
	check_installed_bin "meson"
	check_installed_bin "ninja"
	check_installed_bin "gettext"
	check_installed_lib "libhandy-1"

	meson "${dir}/build" "${dir}" && \
	ninja -C "${dir}/build"
}

as_bin
