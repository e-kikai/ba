# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# compiled file.
#
# Read Sprockets README (https:#github.com/rails/sprockets#sprockets-directives) for details
# about supported directives.
#
#= require jquery
#= require jquery_ujs
# require turbolinks
#= require bootstrap
#= require jquery_nested_form
#= require bootstrap-fileinput
#= require fixed_midashi
#= require bootstrap-select
#= require moment
#= require moment/locale/ja
#= require bootstrap3-datetimepicker
#= require_tree .

# $(document).on 'ready page:load', ->
$(document).ready ->
  # フォーム共通 : フォーム自動全選択
  $('input.allselect').click ->
    @.select()

  # フォーム共通 : datetimepicker
  $('input.datetimepicker').datetimepicker({locale: 'ja', format: 'YYYY/MM/DD HH:mm:ss'})

  # 検索結果ページ : テーブルスクロール制御
  FixedMidashi.create()

  # 検索フォーム : 送信内容制限
  $('#serach_form form').submit ->
    $(@).find('input, select').each ->
      if !$(@).val()
        $(@).prop('disabled', true)
