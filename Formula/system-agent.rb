class SystemAgent < Formula
  include Language::Python::Virtualenv

  desc "Lightweight multi-agent chat orchestrator with Chainlit UI"
  homepage "https://github.com/tush1609/system_agent"
  url "https://github.com/tush1609/system_agent/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "4255004d066b6559cc96caca90b3f3077e47d5b8fc59dad5694c9f17d8dc22de"
  license "NOASSERTION"

  depends_on "python@3.11"

  def install
      venv = virtualenv_create(libexec, "python3.11")
      venv.pip_install resources

      prefix.install Dir["*"]

      (bin/"system-agent").write <<~EOS
        #!/bin/bash
        exec "#{libexec}/bin/python" "#{prefix}/main.py" --ui terminal
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
