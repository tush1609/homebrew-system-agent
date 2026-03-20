class SystemAgent < Formula
  desc "Lightweight multi-agent chat orchestrator with Chainlit UI"
  homepage "https://github.com/tush1609/system_agent"
  url "https://github.com/tush1609/system_agent/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "de2dc0ae5c40be45bbe57778b56139e3b660e97a784634a468310119b20bca1d"
  license "NOASSERTION"

  depends_on "python@3.11"
  depends_on "openssl@3"
  depends_on "pkg-config"
  depends_on "rust"

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV.append "LDFLAGS", "-Wl,-headerpad_max_install_names"
    ENV["RUSTFLAGS"] = [ENV["RUSTFLAGS"], "-C", "link-arg=-headerpad_max_install_names"].compact.join(" ")

    ENV["PIP_NO_BINARY"] = ":all:"
    ENV["PIP_ONLY_BINARY"] = ":none:"

    system "python3.11", "-m", "venv", libexec
    system libexec/"bin/python", "-m", "pip", "install", "--upgrade", "pip", "setuptools", "wheel"

    system libexec/"bin/python", "-m", "pip", "install",
           "--no-cache-dir",
           "--no-binary", ":all:",
           "-r", "requirements.txt"

    pkgshare.install Dir["*"]

    (bin/"system-agent").write <<~EOS
      #!/bin/bash
      set -e
      export PYTHONPATH="#{pkgshare}:$PYTHONPATH"
      exec "#{libexec}/bin/python" "#{pkgshare}/main.py" --ui terminal
    EOS
  end

  def caveats
    <<~EOS
      Set provider keys before running:

        export OPENAI_API_KEY=your_key_here

      Then run:
        system-agent
    EOS
  end

  test do
    system "#{bin}/system-agent", "--help"
  end
end
