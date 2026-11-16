cask "robomori" do
  arch arm: "arm64", intel: "x64"

  version "1.8.0"
  sha256 arm:   "15b1f91faf74bc4bc3fc6428d0ffc1f9c18b9727c3d13b1f4623d49745a64dcc",
         intel: "8d23f982699a546ca33a08672365266fce76c6f23d344684ce2ca5ca3120831c"

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
