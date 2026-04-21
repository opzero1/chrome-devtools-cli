#!/usr/bin/env python3

from __future__ import annotations

import argparse
from pathlib import Path


def normalize_version(tag: str) -> str:
    return tag[1:] if tag.startswith("v") else tag


def build_formula(repository: str, tag: str, arm64_sha: str, x86_64_sha: str) -> str:
    version = normalize_version(tag)

    return f'''class ChromeDevtools < Formula
  desc "Chrome DevTools Protocol CLI — auto-connects to existing Chrome"
  homepage "https://github.com/{repository}"
  version "{version}"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/{repository}/releases/download/{tag}/chrome-devtools-macos-arm64.zip"
      sha256 "{arm64_sha}"
    elsif Hardware::CPU.intel?
      url "https://github.com/{repository}/releases/download/{tag}/chrome-devtools-macos-x86_64.zip"
      sha256 "{x86_64_sha}"
    end
  end

  def install
    bin.install "chrome-devtools"
  end

  test do
    assert_match "Chrome DevTools Protocol CLI", shell_output("#{{bin}}/chrome-devtools --help")
  end
end
'''


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--repository", required=True)
    parser.add_argument("--tag", required=True)
    parser.add_argument("--arm64-sha", required=True)
    parser.add_argument("--x86-64-sha", required=True, dest="x86_64_sha")
    parser.add_argument(
        "--output",
        default=Path(__file__).resolve().parents[1] / "Formula" / "chrome-devtools.rb",
        type=Path,
    )
    args = parser.parse_args()

    args.output.write_text(
        build_formula(args.repository, args.tag, args.arm64_sha, args.x86_64_sha)
    )


if __name__ == "__main__":
    main()
