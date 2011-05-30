module NavigationHelpers
  
  PathMatchers = {} unless defined?(PathMatchers)
  PathMatchers.merge!({
    /styles/i => 'admin_styles_path',
    /scripts/i => 'admin_scripts_path'
  })
  
end

World(NavigationHelpers)