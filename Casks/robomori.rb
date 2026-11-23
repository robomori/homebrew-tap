cask "robomori" do
  arch arm: "arm64", intel: "x64"

  version "1.10.1"
  sha256 arm:   "fff05613ef5ce58fee04d04065a84491bbfd76f7b4c748f790f5ad2c0e7e743c",
         intel: "110975fc65c7ed93d97082fc00e6f62595e557b5e03fd3864950a5cc5665f7d2"

  url "https://downloads.robomori.com/releases/#{version}/macos-#{arch}/robomori-#{version}-mac-#{arch}.dmg"
  name "Robomori"
  desc "Run Android emulators and devices outside Android Studio"
  homepage "https://robomori.com/"

  livecheck do
    url "https://downloads.robomori.com/index.json"
    strategy :json do |json|
      json.map { |release| release["version"] }
    end
  end

  auto_updates true
  depends_on macos: :monterey

  app "Robomori.app"
  # The robomori command runs the installed app in its command-line mode.
  command_wrapper "robomori",
                  executable: "#{appdir}/Robomori.app/Contents/MacOS/Robomori",
                  args:       ["cli"]

  # On Intel Macs, Robomori's Settings → Command Line links the same command where Homebrew links its own.
  preflight_steps do
    remove "bin/robomori", base:                    :homebrew_prefix,
                           symlink_target_contains: "Application Support/Robomori/bin/robomori"
  end

  zap trash: [
    "~/Library/Application Support/Robomori",
    "~/Library/Caches/Robomori",
  ]
end
