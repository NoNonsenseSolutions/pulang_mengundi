class ApplicationPresenter
  def default_url_options(options = {})
    { locale: I18n.locale }
  end

  def t(*args, &block)
    I18n.t(*args, &block)
  end
end