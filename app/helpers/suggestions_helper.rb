module SuggestionsHelper
  FILTER_OPTION = {all: 0, approved: 1, not_approved: 2}.freeze

  def load_filters_suggest
    FILTER_OPTION.map{|k, v| [I18n.t("filter_suggest")[k], v]}
  end

  def load_value_filter sort_id
    case sort_id
    when FILTER_OPTION[:approved]
      true
    when FILTER_OPTION[:not_approved]
      false
    end
  end
end
