module ApplicationHelper
  def column_format(v, column_type, page = :search)
    case column_type
    when "integer"
      v.to_i.to_s(:delimited)
    when "float"
      v.to_f.to_s(:delimited)
    when "yen"
      v.to_i.to_s(:delimited) + "円"
    when "company"
      ColumnTypes::Company.replace_kabu(v).presence || "(UNKNOWN)"
    when "zip"
      v.match(/\A([0-9]{3})\-?([0-9]{4})/) { |m| "#{m[1]}-#{m[2]}" }
    when "address"
      if page == :show && v.present?
        ("#{v} " + link_to("https://maps.google.co.jp/maps?f=q&q=#{v}&source=embed&hl=ja&geocode=&ie=UTF8&t=m&z=14", target: "_blank") do
          content_tag(:span, "", class: "glyphicon glyphicon-map-marker") + "MAP"
        end).html_safe
      else
        v
      end
    when "mail"
      page == :show ? mail_to(v) : v
    when "url"
      page == :show ? link_to(v, v, target: "_blank"): v
    else
      v
    end
  end
end
