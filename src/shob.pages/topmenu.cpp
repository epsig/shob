
#include "topmenu.h"

namespace shob::pages
{
    html::rowContent topmenu::getMenu(const general::season& season) const
    {
        auto menu = html::rowContent();
        for (const auto& row : archive)
        {
            auto curSeason = general::season::findSeason(row);
            auto url = row;
            auto pos = url.find(".csv");
            url.replace(pos, 4, ".html");
            auto year = html::rowContent();
            if (row.find(season.to_part_filename()) != std::string::npos)
                year.addContent(curSeason.to_string());
            else
                year.addContent("<a href=\"sport_voetbal_" + url + "\">" + curSeason.to_string() + "</a>");
            menu.addContent(year);
        }
        return menu;
    };
}
