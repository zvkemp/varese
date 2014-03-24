
notification :tmux, color_location: 'status-right-bg', display_message: true

guard 'minitest', :all_on_start => true do
  watch(%r|^spec/(.*)([^/]+)_spec\.rb|)
  watch(%r|^lib/(.*)([^/]+)\.rb|)     { "spec" }
  watch(%r|^spec/spec_helper\.rb|)    { "spec" }
end
