module Admin::StylesHelper
  def stylesheet_filter_options_for_select(selected=nil)
    options_for_select([[t('select.none'), '']] + SheetsExtension.stylesheet_filters.map { |s| s.filter_name }.sort, selected)
  end
end
