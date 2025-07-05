if Rails.env.development? || Rails.env.test?
  Rails.application.config.to_prepare do
    LetterOpenerWeb::LettersController.class_eval do
      skip_before_action :verify_authenticity_token
    end
  end
end

