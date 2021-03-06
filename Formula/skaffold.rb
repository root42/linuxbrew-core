class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://github.com/GoogleContainerTools/skaffold"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      :tag      => "v0.24.0",
      :revision => "6a829c4b29e3a102b0b14c4584cd174f780402e9"
  head "https://github.com/GoogleContainerTools/skaffold.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles"
    cellar :any_skip_relocation
    sha256 "8920c3eaf8cbd485ea0c779aa06c4257145b441786b6606375fca32fba70a804" => :mojave
    sha256 "3f69aa328360fdea89cc8e0f9e73ebc5f95dddb19d7037154ced3c4e260be399" => :high_sierra
    sha256 "0bcad18b482453349da81921ee1816923256ca7707f4f31a6b836b2e3247cf11" => :sierra
    sha256 "cb977ff262ee0a81caef6d7299bf9da2a5c0c860d8bdc7e553af845bc7abecc9" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/GoogleContainerTools/skaffold"
    dir.install buildpath.children - [buildpath/".brew_home"]
    cd dir do
      system "make"
      bin.install "out/skaffold"

      output = Utils.popen_read("#{bin}/skaffold completion bash")
      (bash_completion/"skaffold").write output

      output = Utils.popen_read("#{bin}/skaffold completion zsh")
      (zsh_completion/"_skaffold").write output

      prefix.install_metafiles
    end
  end

  test do
    output = shell_output("#{bin}/skaffold version --output {{.GitTreeState}}")
    assert_match "clean", output
  end
end
