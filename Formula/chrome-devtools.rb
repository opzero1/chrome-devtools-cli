class ChromeDevtools < Formula
  desc "Chrome DevTools Protocol CLI — auto-connects to existing Chrome"
  homepage "https://github.com/opzero1/chrome-devtools-cli"
  version "0.1.3"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/opzero1/chrome-devtools-cli/releases/download/v#{version}/chrome-devtools-macos-arm64.zip"
      sha256 "894ad5f9d042cb1a378c49a7f71f5a9f711948f34d34287de117daf99426b7cd"
    end
  end

  def install
    bin.install "chrome-devtools"
  end

  test do
    assert_match "Chrome DevTools Protocol CLI", shell_output("#{bin}/chrome-devtools --help")
  end
end
