cask "robomori" do
  arch arm: "arm64", intel: "x64"

  version "1.10.0"
  sha256 arm:   "6c51eb2d6e500522e6bf2c7f3cafc45448195bd9cdbf79563a8d30b2e97eb2a6",
         intel: "ccaa3a0f440112d8245fe475d70af35b644fa64e16bbcd1556ff3788be1497f2"

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
