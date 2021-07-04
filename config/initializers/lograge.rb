Rails.application.configure do
  # Enable lograge
 config.lograge.enabled = true
  # Assign lograge log formatting
  # All formatters are available here: https://github.com/roidrage/lograge/tree/master/lib/lograge/formatters

  config.lograge.formatter = Class.new do |fmt|
    def fmt.call(data)
      data.merge(log_type: 'request')
    end
  end
  config.lograge_sql.extract_event = proc do |event|
    { name: event.payload[:name], duration: event.duration.to_f.round(2), sql: event.payload[:sql] }
  end
  config.lograge_sql.formatter = proc do |sql_queries|
    sql_queries
  end

  # config.time_zone = "Central Time (US & Canada)"
  config.lograge.custom_payload do |controller|
    {
      host: controller.request.host,
      user_id: controller.current_user.try(:id)

    }
  end

  # Add additional fields and process additional
  # payload parameters defined in controller/application.rb
  # Time ISO format taken from
  # https://www.reddit.com/r/rails/comments/5u1lzn/rails_production_logging_in_2017/ddrrqei/
  config.lograge.custom_options = lambda do |event|
    {
      time: event.time,
      remote_ip: event.payload[:remote_ip]
    }
  end
end
