begin
  require 'coffee_script'
  class CoffeeFilter < TextFilter
    def filter(text)
      CoffeeScript.compile text
    end
  end
rescue ExecJS::RuntimeUnavailable
  Rails.logger.warn "There is no support for CoffeeScript"
  class CoffeeFilter;end
end