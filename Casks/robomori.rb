cask "robomori" do
  arch arm: "arm64", intel: "x64"

  version "1.10.2"
  sha256 arm:   "3f107e8be01bfd41d7d9d69fdcb6630c19017d69f5522efefecd31728bfdbf35",
         intel: "e1e7419cbe07dce27a020368f36b6c781ceb626c88f4eaa974f975827d3fcfb1"

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
