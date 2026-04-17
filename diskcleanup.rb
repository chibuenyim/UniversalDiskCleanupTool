# Homebrew formula for Universal Disk Cleanup Tool
class Diskcleanup < Formula
  desc "Cross-platform disk cleanup utility for Windows, macOS, and Linux"
  homepage "https://github.com/chibuenyim/UniversalDiskCleanupTool"
  url "https://github.com/chibuenyim/UniversalDiskCleanupTool.git",
    tag: "v3.0.0"
  license "MIT"

  depends_on "pwsh"

  def install
    bin.install "cleanup.ps1" => "diskcleanup"
    bin.install "install.sh" => "diskcleanup-install"
  end

  def caveats
    <<~EOS
      This tool requires PowerShell Core 7+ to be installed.

      To run:
        diskcleanup --all

      For more options:
        diskcleanup --help
    EOS
  end

  test do
    system "pwsh", "-File", "#{bin}/diskcleanup", "--help"
  end
end
