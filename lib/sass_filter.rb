class SassFilter < TextFilter
  description_file File.dirname(__FILE__) + "/../sass.html"

  def filter(text)
    begin
      Sass::Engine.new(text, {}).render
    rescue Sass::SyntaxError
      "Syntax Error at line #{$!.sass_line}: " + $!.to_s
    end
  end
end