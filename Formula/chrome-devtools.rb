class ChromeDevtools < Formula
  desc "Chrome DevTools Protocol CLI — auto-connects to existing Chrome"
  version "0.1.1"
  homepage "https://github.com/opzero1/chrome-devtools-cli"
  version "0.1.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/opzero1/chrome-devtools-cli/releases/download/v#{version}/chrome-devtools-macos-arm64.zip"
      sha256 "ebc35352b4e05d8aa6eaa4fa2c7280eecbb174431338bbd129e6886de622f607"
    end
  end

  def install
    bin.install "chrome-devtools"
  end

  test do
    assert_match "Chrome DevTools Protocol CLI", shell_output("#{bin}/chrome-devtools --help")
  end
end
