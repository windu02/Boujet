ActionMailer::Base.smtp_settings = {
:address              => "ns0.ovh.net",
:port                 => 587,
:domain               => "leijougadou.org",
:user_name            => "boujet@leijougadou.org",
:password             => "boujet8gadou",
:authentication       => "plain",
:enable_starttls_auto => true
}