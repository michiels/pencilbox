if Rails.env.production? && ENV['EXCEPTIONS_TO']
  Pencilbox::Application.config.middleware.use ExceptionNotifier,
    :email_prefix => "[Pencilbox] ",
    :sender_address => %{"Pencilbox Notifier" <#{ENV['EXCEPTIONS_FROM']}>},
    :exception_recipients => %w{#{ENV['EXCEPTIONS_TO']}}
end