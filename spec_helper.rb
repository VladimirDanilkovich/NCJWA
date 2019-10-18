

RSpec.configure do |config|
    
    # ... other configuration options
    
    def save_timestamped_screenshot(page, meta)
    filename = File.basename(meta[:file_path])
    line_number = meta[:line_number]
    
    time_now = Time.now
    timestamp = "#{time_now.strftime('%Y-%m-%d-%H-%M-%S.')}#{'%03d' % (time_now.usec/1000).to_i}"
    
    screenshot_name = "screenshot-#{filename}-#{line_number}-#{timestamp}.png"
    screenshot_path = "#{ENV.fetch('CIRCLE_ARTIFACTS', Rails.root.join('tmp/capybara'))}/#{screenshot_name}"
    
    page.save_screenshot(screenshot_path)
    
    puts "\n  Screenshot: #{screenshot_path}"
end

config.after(:each) do
    if example.metadata[:js]
        save_timestamped_screenshot(Capybara.page, example.metadata) if example.exception
    end
end

# ... other configuration options
end
