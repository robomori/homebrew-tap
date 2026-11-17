cask "robomori" do
  arch arm: "arm64", intel: "x64"

  version "1.9.0"
  sha256 arm:   "9c23d1e3560edeef5b4a126cdcc7f3973a78d3c56a9c292eda235e6ead05219b",
         intel: "4f119eb273d22257eb023836a20b1213c21c3975641d59ef4dd0b64794b57b79"

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
