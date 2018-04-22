# frozen_string_literal: true

class ApplicationPresenter
  def default_url_options(_options = {})
    { locale: I18n.locale }
  end

  def t(*args, &block)
    I18n.t(*args, &block)
  end
end
