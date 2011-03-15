class SassFilter < TextFilter
  description_file File.dirname(__FILE__) + "/../sass.html"

  def filter(text)
    begin
      options = Compass.sass_engine_options || {:load_paths => []}
      options[:load_paths].unshift "#{RADIANT_ROOT}/public/stylesheets/sass"
      options[:load_paths].unshift "#{Rails.root}/public/stylesheets/sass"
      # this would need some substitions (as in paperclip) to be useful
      # options[:load_paths] += Radiant::Config['sheets.sass_template_paths'].split(',').map(&:strip) if Radiant::Config['sheets.sass_template_paths']
      Sass::Engine.new(text, options).render
    rescue Sass::SyntaxError
      "Syntax Error at line #{$!.sass_line}: " + $!.to_s
    end
  end
end