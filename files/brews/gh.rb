require "formula"

class Gh < Formula
  VERSION = "1.0.0"
  ARCH = if MacOS.prefer_64_bit?
           "amd64"
         else
           "386"
         end

  homepage "https://github.com/jingweno/gh"
  head "https://github.com/jingweno/gh.git"
  url "https://github.com/jingweno/gh/releases/download/v#{VERSION}/gh_#{VERSION}_darwin_#{ARCH}.zip"
  version VERSION

  def install
    bin.install "gh"
    bash_completion.install "gh.bash_completion.sh"
    zsh_completion.install "gh.zsh_completion" => "_gh"
  end

  def caveats; <<-EOS.undent
  To upgrade gh, run `brew upgrade` and `brew upgrade gh`

  More information here: https://github.com/jingweno/gh/blob/master/README.md
    EOS
  end

  test do
    assert_equal VERSION, `#{bin}/gh version`.split.last
  end
end
