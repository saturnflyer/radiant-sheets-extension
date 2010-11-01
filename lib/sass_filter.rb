require 'compass'

class SassFilter < TextFilter
  description_file File.dirname(__FILE__) + "/../sass.html"

  def filter(text)
    begin
      Sass::Engine.new(text, Compass.sass_engine_options || {}).render
    rescue Sass::SyntaxError
      "Syntax Error at line #{$!.sass_line}: " + $!.to_s
    end
  end
end