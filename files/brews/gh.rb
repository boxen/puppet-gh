require "formula"

class Gh < Formula
  VERSION = "0.25.0"
  ARCH = if MacOS.prefer_64_bit?
           "amd64"
         else
           "386"
         end

  homepage "https://github.com/jingweno/gh"
  head "https://github.com/jingweno/gh.git"
  url "https://github.com/jingweno/gh/releases/download/v#{VERSION}/gh_#{VERSION}-snapshot_darwin_#{ARCH}.zip"
  version VERSION

  def install
    bin.install "gh"
    bash_completion.install "gh.bash_completion.sh"
    zsh_completion.install "gh.zsh_completion" => "_gh"
  end

  def caveats; <<-EOS.undent
  To upgrade gh, run `brew upgrade https://raw.github.com/jingweno/gh/master/homebrew/gh.rb`

  More information here: https://github.com/jingweno/gh/blob/master/README.md
    EOS
  end

  test do
    assert_equal VERSION, `#{bin}/gh version`.split.last
  end
end
