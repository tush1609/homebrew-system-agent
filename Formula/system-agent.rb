class SystemAgent < Formula
  desc "Lightweight multi-agent chat orchestrator with Chainlit UI"
  homepage "https://github.com/tush1609/system_agent"
  url "https://github.com/tush1609/system_agent/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "389a9aaff7a84dc920fcfd97fa8dfc699bf25c493c51712222486d27b49b2735"
  license "NOASSERTION"

  depends_on "python@3.11"
  depends_on "openssl@3"
  depends_on "pkg-config"
  depends_on "rust"

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["PIP_NO_BINARY"] = "cryptography"
    ENV["LDFLAGS"] = "-Wl,-headerpad_max_install_names"
    ENV["RUSTFLAGS"] = "-C link-arg=-headerpad_max_install_names"

    system "python3.11", "-m", "venv", libexec
    system libexec/"bin/python", "-m", "pip", "install", "--upgrade", "pip", "setuptools", "wheel"
    system libexec/"bin/python", "-m", "pip", "install", "--no-cache-dir", "--no-binary", "jiter,orjson,ormsgpack", "-r", "requirements.txt"

    libexec.install Dir["*"]

    (bin/"system-agent").write <<~EOS
      #!/bin/bash
      set -e
      exec "#{libexec}/bin/python" "#{libexec}/main.py" --ui terminal "$@"
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
end
