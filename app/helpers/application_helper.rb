module ApplicationHelper

  # カラムごとにフォーマットしたHTMLタグ出力
  #
  # @param  [Iinteger] v           表示させる値
  # @param  [String]   column_type カラム型
  # @param  [String]   page        表示させるページ
  # @return [String]   HTMLタグ
  def column_format(v, column_type, page = :search)
    v = v.to_s

    case column_type
    when "integer"
      v.to_i.to_s(:delimited)
    when "float"
      v.to_f.to_s(:delimited)
    when "yen"
      v.to_i.to_s(:delimited) + "円"
    when "sen_yen"
      v.to_i.to_s(:delimited) + "千円"
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
      page == :show ? mail_to(v) : v if v.present?
    when "url"
      page == :show ? link_to(v, v, target: "_blank") : v if v.present?
    else
      v
    end
  end

  # 検索結果の項目ごとのソートダイアログHTMLタグ
  #
  # @param  [Iinteger] column_name カラム名
  # @return [string]   HTMLタグ
  def column_sorter(column_name)
    content_tag(:div, class: "dropdown", style: "display:inline-block;") do
      concat( button_tag(type: :button, class: "dropdown-toggle btn btn-primary btn-xs", data: { toggle: "dropdown" }) do
        tag :span, class: "glyphicon glyphicon-option-vertical"
      end)

      concat( content_tag(:ul, class: "dropdown-menu", role:"menu") do
        concat( content_tag(:li) do
          link_to params.merge("order[column]" => column_name, "order[type]" => :asc) do
            tag(:span, class: "glyphicon glyphicon-sort-by-alphabet") + " 昇順でソート"
          end
        end)
        concat( content_tag(:li) do
          link_to params.merge("order[column]" => column_name, "order[type]" => :desc) do
            tag(:span, class: "glyphicon glyphicon-sort-by-alphabet-alt") + " 降順でソート"
          end
        end)
        concat( tag :li, class: "divider")

        concat( content_tag(:li) do
          link_to "空白", params.merge("s[][column_name]" => column_name, "s[][value]" => "", "s[][cond]" => :blank)
        end)
        concat( content_tag(:li) do
          link_to "空白でない", params.merge("s[][column_name]" => column_name, "s[][value]" => "", "s[][cond]" => :present)
        end)
        concat( content_tag(:li) do
          link_to "重複している", params.merge("s[][column_name]" => column_name, "s[][value]" => "", "s[][cond]" => :overlap)
        end)
        concat( content_tag(:li) do
          link_to "重複していない", params.merge("s[][column_name]" => column_name, "s[][value]" => "", "s[][cond]" => :unique)
        end)
      end)
    end

  end
end
