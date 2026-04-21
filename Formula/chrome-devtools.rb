class ChromeDevtools < Formula
  desc "Chrome DevTools Protocol CLI — auto-connects to existing Chrome"
  homepage "https://github.com/opzero1/chrome-devtools-cli"
  version "0.1.2"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/opzero1/chrome-devtools-cli/releases/download/v#{version}/chrome-devtools-macos-arm64.zip"
      sha256 "8d2c91fb07e01fa8915ae619a9b9fee2e9c41547f417dc8a9d7db4ca3eb707b5"
    end
  end

  def install
    bin.install "chrome-devtools"
  end

  test do
    assert_match "Chrome DevTools Protocol CLI", shell_output("#{bin}/chrome-devtools --help")
  end
end
