
#include "topmenu.h"

namespace shob::pages
{
    using namespace shob::general;

    multipleStrings topMenu::getMenu(const season& season) const
    {
        auto menu = multipleStrings();
        const int nEntries = static_cast<int>(archive.size());
        int curPos = 0;
        for (const auto& row : archive)
        {
            auto curSeason = season::findSeason(row);
            auto url = row;
            auto pos = url.find(".csv");
            url.replace(pos, 4, ".html");
            auto year = std::string();
            if (row.find(season.to_part_filename()) != std::string::npos)
            {
                year = curSeason.to_string_short();
                curPos = static_cast<int>(menu.data.size());
            }
            else
                year = "<a href=\"sport_voetbal_" + url + "\">" + curSeason.to_string_short() + "</a>";
            menu.addContent(year + " |");
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

    multipleStrings topMenu::getMenu(const std::string& year) const
    {
        auto menu = multipleStrings();
        const int nEntries = static_cast<int>(archive.size());
        int curPos = 0;
        for (const auto& row : archive)
        {
            auto pos = row.find("K");
            auto yr = row.substr(pos - 1, 7);
            yr[2] = ' ';
            if (row.find(year) != std::string::npos)
            {
                curPos = static_cast<int>(menu.data.size());
                menu.addContent(yr + " |");
            }
            else
            {
                auto url = row + ".html";
                url = "<a href=\"" + url + "\">" + yr + "</a>";
                menu.addContent(url + " |");
            }
        }
        if (nEntries > maxUrls)
        {
            if (curPos <= maxUrls / 2)
            {
                shortenMenuLeft(menu);
            }
            else if (curPos >= nEntries - 1 - maxUrls / 2)
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

    void topMenu::addEllipsis(multipleStrings& rows)
    {
        rows.addContent(" ...  |");
    }

    void topMenu::shortenMenu(multipleStrings& menu, int curPos) const
    {
        auto newMenu = multipleStrings();

        newMenu.addContent(menu.data[0]);
        addEllipsis(newMenu);

        int first = curPos + 1 - maxUrls / 2;
        int last = curPos + maxUrls / 2;
        for( int i = first; i < last; i++)
        {
            newMenu.addContent(menu.data[i]);
        }

        addEllipsis(newMenu);
        newMenu.addContent(menu.data.back());
        std::swap(menu, newMenu);
    }

    void topMenu::shortenMenuLeft(multipleStrings& menu) const
    {
        auto newMenu = multipleStrings();

        for (int i = 0; i < maxUrls; i++)
        {
            newMenu.addContent(menu.data[i]);
        }
        addEllipsis(newMenu);
        newMenu.addContent(menu.data.back());
        std::swap(menu, newMenu);
    }

    void topMenu::shortenMenuRight(multipleStrings& menu) const
    {
        auto newMenu = multipleStrings();

        const int nEntries = static_cast<int>(menu.data.size());

        newMenu.addContent(menu.data[0]);
        addEllipsis(newMenu);
        for (int i = nEntries - maxUrls; i < nEntries; i++)
        {
            newMenu.addContent(menu.data[i]);
        }
        std::swap(menu, newMenu);
    }

}
