cask "robomori" do
  arch arm: "arm64", intel: "x64"

  version "1.7.0"
  sha256 arm:   "7f9ed08ae086426861819176b2ca39d58ead7a25552291e60049df38462b27a6",
         intel: "5781c5a7d643e5071322e5d963fc182cc5435fb817178592b5c5cdacdece8704"

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

  zap trash: [
    "~/Library/Application Support/Robomori",
    "~/Library/Caches/Robomori",
  ]
end
