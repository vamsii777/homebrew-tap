class NginxUi < Formula
    desc "Nginx UI - A web interface for Nginx"
    homepage "https://github.com/0xJacky/nginx-ui"
    version "2.0.0-beta.32-patch.1"
    license "AGPL-3.0"
  
    on_macos do
      if Hardware::CPU.intel?
        url "https://github.com/0xJacky/nginx-ui/releases/download/v#{version}/nginx-ui-macos-64.tar.gz"
        sha256 "cd95b79d14bf6c0ab87d653762cef56e8c3b755b9de7eb143cfe220e64e74b93"
      else
        url "https://github.com/0xJacky/nginx-ui/releases/download/v#{version}/nginx-ui-macos-arm64-v8a.tar.gz"
        sha256 "b4a8106499ecb43f7946a45fb4765e071554393bf06895ebf7ef14206f4e0ae7"
      end
    end
  
    on_linux do
      if Hardware::CPU.intel?
        if Hardware::CPU.is_64_bit?
          url "https://github.com/0xJacky/nginx-ui/releases/download/v#{version}/nginx-ui-linux-64.tar.gz"
          sha256 "a5a1e8b059cf43d664eef7aeab478e33af205053cc242f51a280070eef8acd2f"
        else
          url "https://github.com/0xJacky/nginx-ui/releases/download/v#{version}/nginx-ui-linux-32.tar.gz"
          sha256 "1e635fd82169797a2761a5776550e056cb83bef2e788b4a202b2a29bef052a2a"
        end
      else
        if Hardware::CPU.arm?
          if Hardware::CPU.is_64_bit?
            url "https://github.com/0xJacky/nginx-ui/releases/download/v#{version}/nginx-ui-linux-arm64-v8a.tar.gz"
            sha256 "79cf1d033a6e52961eb5a833200d9b45f34cfae0d35bde448d83c048149bfc7d"
          else
            url "https://github.com/0xJacky/nginx-ui/releases/download/v#{version}/nginx-ui-linux-arm32-v7a.tar.gz"
            sha256 "51cdf0228904c32a6ceae2ed289ace286af7a3ee8a60a993e220ddb910124b71"
          end
        end
      end
    end
  
    def install
      bin.install "nginx-ui"
    end
  
    def post_install
      (var/"log/nginx-ui").mkpath
      (var/"nginx-ui").mkpath
    end
  
    service do
      run [opt_bin/"nginx-ui"]
      keep_alive true
      log_path var/"log/nginx-ui/nginx-ui.log"
      error_log_path var/"log/nginx-ui/error.log"
      working_dir var/"nginx-ui"
    end
  
    test do
      port = free_port
      ENV["NGINX_UI_PORT"] = port.to_s
      pid = fork { exec bin/"nginx-ui" }
      sleep 5
      assert_match "Nginx UI", shell_output("curl -s http://localhost:#{port}")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end  