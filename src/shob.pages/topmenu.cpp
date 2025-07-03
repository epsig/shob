
#include "topmenu.h"

namespace shob::pages
{
    html::rowContent topmenu::getMenu(const general::season& season) const
    {
        auto menu = html::rowContent();
        const int nEntries = static_cast<int>(archive.size());
        int curPos = 0;
        for (const auto& row : archive)
        {
            auto curSeason = general::season::findSeason(row);
            auto url = row;
            auto pos = url.find(".csv");
            url.replace(pos, 4, ".html");
            auto year = html::rowContent();
            if (row.find(season.to_part_filename()) != std::string::npos)
            {
                year.addContent(curSeason.to_string_short());
                curPos = static_cast<int>(menu.data.size());
            }
            else
                year.addContent("<a href=\"sport_voetbal_" + url + "\">" + curSeason.to_string_short() + "</a>");
            menu.addContent(year);
        }
        if (nEntries > maxUrls)
        {
            if (curPos <= maxUrls/2)
            {
                shortenMenuLeft(menu);
            }
            else if (curPos >= nEntries - 1 - maxUrls/2)
            {
                shortenMenuRight(menu);
            }
            else
            {
                shortenMenu(menu, curPos);
            }
        }
        return menu;
    }

    void topmenu::shortenMenu(html::rowContent& menu, int curPos) const
    {
        auto newMenu = html::rowContent();

        const int nEntries = static_cast<int>(menu.data.size());

        newMenu.addContent(menu.data[0]);
        newMenu.addContent("...");
        for( int i = 2; i < nEntries-1; i++)
        {
            if (std::abs(i - curPos) < maxUrls/2)
            {
                newMenu.addContent(menu.data[i]);
            }
        }
        newMenu.addContent("...");
        newMenu.addContent(menu.data.back());
        menu.data.clear();
        menu.addContent(newMenu);
    }

    void topmenu::shortenMenuLeft(html::rowContent& menu) const
    {
        auto newMenu = html::rowContent();

        for (int i = 0; i < maxUrls; i++)
        {
            newMenu.addContent(menu.data[i]);
        }
        newMenu.addContent("...");
        newMenu.addContent(menu.data.back());
        menu.data.clear();
        menu.addContent(newMenu);
    }

    void topmenu::shortenMenuRight(html::rowContent& menu) const
    {
        auto newMenu = html::rowContent();

        const int nEntries = static_cast<int>(menu.data.size());

        newMenu.addContent(menu.data[0]);
        newMenu.addContent("...");
        for (int i = nEntries - maxUrls; i < nEntries; i++)
        {
            newMenu.addContent(menu.data[i]);
        }
        menu.data.clear();
        menu.addContent(newMenu);
    }

}
