ActionMailer::Base.smtp_settings = {
:address              => "smtp.gmail.com",
:port                 => 587,
:domain               => "leijougadou.org",
:user_name            => "testbrel@gmail.com",
:password             => "test!brel",
:authentication       => "plain",
:enable_starttls_auto => true
}