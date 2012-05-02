# Gameplan

Create a state machine for your application for planning purposes

## Usage

Define your app the following way:

  state "home screen" do
    present(:select_media)
    if (:logged_out) do
    end
  end

