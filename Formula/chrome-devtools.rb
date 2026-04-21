class ChromeDevtools < Formula
  # Bootstrap formula until the fork publishes its first arm64/x86_64 release assets.
  desc "Chrome DevTools Protocol CLI — auto-connects to existing Chrome"
  homepage "https://github.com/opzero1/chrome-devtools-cli"
  version "0.1.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/aeroxy/chrome-devtools-cli/releases/download/0.1.0/chrome-devtools-macos-arm64.zip"
      sha256 "18f63ab500200e8b5d6614a18dd2457cf7d36716e17e7fdb469d08bf9062323e"
    end
  end

  def install
    bin.install "chrome-devtools"
  end

  test do
    assert_match "Chrome DevTools Protocol CLI", shell_output("#{bin}/chrome-devtools --help")
  end
end
