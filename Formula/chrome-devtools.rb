class ChromeDevtools < Formula
  desc "Chrome DevTools Protocol CLI — auto-connects to existing Chrome"
  homepage "https://github.com/opzero1/chrome-devtools-cli"
  version "0.1.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/opzero1/chrome-devtools-cli/releases/download/v0.1.1/chrome-devtools-macos-arm64.zip"
      sha256 "ebc35352b4e05d8aa6eaa4fa2c7280eecbb174431338bbd129e6886de622f607"
    elsif Hardware::CPU.intel?
      url "https://github.com/opzero1/chrome-devtools-cli/releases/download/v0.1.1/chrome-devtools-macos-x86_64.zip"
      sha256 "8e96b4c0d1153d69746f951fb35f2c1a097541135fd8f84f4b92ffc629a8048e"
    end
  end

  def install
    bin.install "chrome-devtools"
  end

  test do
    assert_match "Chrome DevTools Protocol CLI", shell_output("#{bin}/chrome-devtools --help")
  end
end
