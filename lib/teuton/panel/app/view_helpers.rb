# frozen_string_literal: true

module Teuton::Panel
  # Small HTML helpers shared by the views
  class App < Sinatra::Base
    ICONS = {
      server: '<rect x="3" y="4" width="18" height="7" rx="2"/><rect x="3" y="13" width="18" height="7" rx="2"/><path d="M7 7.5h.01M7 16.5h.01"/>',
      users: '<circle cx="9" cy="8" r="3.5"/><path d="M2.5 20c.8-3.5 3.4-5.5 6.5-5.5s5.7 2 6.5 5.5"/><path d="M16 4.6a3.5 3.5 0 0 1 0 6.8M18.5 14.8c1.6.8 2.6 2.6 3 5.2"/>',
      play: '<circle cx="12" cy="12" r="9"/><path d="M10 8.5l5 3.5-5 3.5z"/>',
      chart: '<path d="M4 20V10M10 20V4M16 20v-7M22 20H2"/>',
      book: '<path d="M4 5.5A2.5 2.5 0 0 1 6.5 3H20v15H6.5A2.5 2.5 0 0 0 4 20.5z"/><path d="M4 20.5A2.5 2.5 0 0 1 6.5 18H20v3H6.5"/>',
      gear: '<circle cx="12" cy="12" r="3"/><path d="M12 2v3M12 19v3M4.9 4.9l2.1 2.1M17 17l2.1 2.1M2 12h3M19 12h3M4.9 19.1L7 17M17 7l2.1-2.1"/>',
      archive: '<rect x="3" y="4" width="18" height="5" rx="1.5"/><path d="M5 9v10a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1V9M10 13h4"/>',
      clock: '<circle cx="12" cy="12" r="9"/><path d="M12 7v5l3 2"/>',
      terminal: '<rect x="2.5" y="4" width="19" height="16" rx="2"/><path d="M7 9l3 3-3 3M12.5 15H17"/>',
      form: '<rect x="4" y="3" width="16" height="18" rx="2"/><path d="M8 8h8M8 12h8M8 16h5"/>',
      spark: '<path d="M12 3v4M12 17v4M3 12h4M17 12h4M6 6l2.5 2.5M15.5 15.5L18 18M6 18l2.5-2.5M15.5 8.5L18 6"/>'
    }

    helpers do
      def icon(name, size = 22)
        paths = ICONS[name.to_sym]
        %(<svg width="#{size}" height="#{size}" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">#{paths}</svg>)
      end

      def grade_class(grade)
        return "low" if grade.to_f < 50
        return "mid" if grade.to_f < 80

        "high"
      end

      def grade_text(grade)
        value = grade.to_f
        (value == value.round) ? value.round.to_s : value.round(1).to_s
      end

      def grade_bar(grade, disabled = false)
        return "&mdash;" if grade.nil? && disabled
        return %(<span class="badge pending">#{h t("status.pending")}</span>) if grade.nil?

        %(<div class="grade #{grade_class(grade)}"><span class="grade-value">#{grade_text(grade)}</span>) +
          %(<span class="grade-bar"><span style="width: #{grade.to_f.clamp(0, 100)}%"></span></span></div>)
      end

      ##
      # [css class, text] for a roster row or a result
      def row_state(disabled, result)
        return ["disabled", t("status.disabled")] if disabled
        return ["pending", t("status.pending")] if result.nil?
        return ["conn", t("status.conn_error")] unless result["conn_status"].to_h.empty?
        return ["fail", t("status.copy")] if result["unique_fault"].to_i > 0
        return ["fail", t("status.low")] if result["grade"].to_f < 50

        ["ok", t("status.ok")]
      end

      def state_badge(disabled, result)
        css, text = row_state(disabled, result)
        %(<span class="badge #{css}">#{h text}</span>)
      end

      def field_label(field, mode)
        return t("fields.name") if mode == "AS NAME"
        return t("fields.email") if mode == "AS EMAIL"

        field.tr("_", " ").capitalize
      end

      def field_type(field, mode)
        return "email" if mode == "AS EMAIL"
        return "password" if field.include?("password")

        "text"
      end

      def field_autocomplete(field, mode)
        return "name" if mode == "AS NAME"
        return "email" if mode == "AS EMAIL"

        "off"
      end

      def nav_link(path, label)
        current = (request.path_info == path || (path != "/teacher" && request.path_info.start_with?(path))) ? "current" : ""
        %(<a href="#{path}" class="#{current}">#{h label}</a>)
      end

      def lang_link(code)
        current = (@lang == code) ? "current" : ""
        query = request.query_string.to_s.gsub(/(^|&)lang=[a-z]+/, "")
        query = [query, "lang=#{code}"].reject(&:empty?).join("&")
        %(<a href="#{request.path_info}?#{query}" class="#{current}" lang="#{code}">#{code.upcase}</a>)
      end
    end
  end
end
