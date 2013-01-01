ActionMailer::Base.smtp_settings = {
:address              => ENV['BOUJET_MAILER_ADDRESS'],
:port                 => ENV['BOUJET_MAILER_PORT'],
:domain               => ENV['BOUJET_MAILER_DOMAIN'],
:user_name            => ENV['BOUJET_MAILER_USERNAME'],
:password             => ENV['BOUJET_MAILER_PASSWORD'],
:authentication       => ENV['BOUJET_MAILER_AUTHENTICATION'],
:enable_starttls_auto => true
}