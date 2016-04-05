class ApplicationFormBuilder < ActionView::Helpers::FormBuilder
  def column_field(co, options={class: "form-control"})
    if co.db_type == :text
      text_area co.column_name, options
    elsif co.db_type == :integer
      number_field co.column_name, options
    elsif co.def_selector.present?
      select co.column_name, [["▼#{co.label}を選択▼", ""]] + co.def_selector, {}, options
    elsif co.selector?
      select co.column_name, [["▼#{co.name}を選択▼", ""]] + co.selector.split("\n").map(&:strip), {}, options
    else
      text_field co.column_name, options
    end
  end
end
