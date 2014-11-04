module ApplicationHelper
    def active_path(page)
        if(current_page?(page))
            return "class=active"
        else
            return ""
        end
    end

    # converts kbps to mbps
    def to_mbps(kbps)
      kbps / 1000
    end
end
