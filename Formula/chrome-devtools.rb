class ChromeDevtools < Formula
  desc "Chrome DevTools Protocol CLI — auto-connects to existing Chrome"
  homepage "https://github.com/opzero1/chrome-devtools-cli"
  version "0.1.4"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/opzero1/chrome-devtools-cli/releases/download/v#{version}/chrome-devtools-macos-arm64.zip"
      sha256 "e8470b3c2d69f048086eb8698af806de05ff7ef6ef6322c81af4dc1587987bee"
    end
  end

  def install
    bin.install "chrome-devtools"
  end

  test do
    assert_match "Chrome DevTools Protocol CLI", shell_output("#{bin}/chrome-devtools --help")
  end
end
