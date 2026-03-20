class SystemAgent < Formula
  include Language::Python::Virtualenv

  desc "Lightweight multi-agent chat orchestrator with Chainlit UI"
  homepage "https://github.com/tush1609/system_agent"
  url "https://github.com/tush1609/system_agent/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "40ed5bc2de762d68fb3c21f26e54c3299ebddec915c3e7bb92b357bffb165d9c"
  license "NOASSERTION"

  depends_on "python@3.11"

  def install
    venv = virtualenv_create(libexec, "python3.11")
    venv.pip_install "pip"
    venv.pip_install "-r", "requirements.txt"

    libexec.install Dir["*"]
    (bin/"system-agent").write <<~EOS
      #!/bin/bash
      exec "#{libexec}/bin/python" "#{libexec}/main.py" --ui chainlit
    EOS
  end

  def caveats
    <<~EOS
      This formula installs Python dependencies at install time via pip.
      You must set OPENAI_API_KEY (and any other provider keys) before running:

        export OPENAI_API_KEY=your_key_here

      Then run:
        system-agent
    EOS
  end
end
