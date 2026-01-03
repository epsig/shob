
#include "TopMenu.h"

namespace shob::pages
{
    using namespace shob::general;

    multipleStrings TopMenu::getMenu(const Season& season) const
    {
        auto menu = multipleStrings();
        int curPos = 0;
        for (const auto& row : archive)
        {
            auto curSeason = Season::findSeason(row);
            auto url = row;
            auto pos = url.find(".csv");
            url.replace(pos, 4, ".html");
            auto year = std::string();
            if (row.find(season.toPartFilename()) != std::string::npos)
            {
                year = curSeason.toStringShort();
                curPos = static_cast<int>(menu.data.size());
            }
            else
                year = "<a href=\"sport_voetbal_" + url + "\">" + curSeason.toStringShort() + "</a>";
            menu.addContent(year + " |");
        }
        shortenMenu(menu, curPos);
        return menu;
    }

    multipleStrings TopMenu::getMenu(const std::string& year) const
    {
        auto menu = multipleStrings();
        int curPos = 0;
        for (const auto& row : archive)
        {
            auto pos = row.find(id);
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
        shortenMenu(menu, curPos);
        return menu;
    }

    void TopMenu::addEllipsis(multipleStrings& rows)
    {
        rows.addContent(" ...  |");
    }

    void TopMenu::shortenMenu(multipleStrings& menu, int curPos) const
    {
        const int nEntries = static_cast<int>(archive.size());
        if (nEntries > max_urls)
        {
            if (curPos <= max_urls / 2)
            {
                shortenMenuLeft(menu);
            }
            else if (curPos >= nEntries - 1 - max_urls / 2)
            {
                shortenMenuRight(menu);
            }
            else
            {
                shortenMenuCenter(menu, curPos);
            }
        }
    }

    void TopMenu::shortenMenuCenter(multipleStrings& menu, int curPos) const
    {
        auto newMenu = multipleStrings();

        newMenu.addContent(menu.data[0]);
        addEllipsis(newMenu);

        int first = curPos + 1 - max_urls / 2;
        int last = curPos + max_urls / 2;
        for( int i = first; i < last; i++)
        {
            newMenu.addContent(menu.data[i]);
        }

        addEllipsis(newMenu);
        newMenu.addContent(menu.data.back());
        std::swap(menu, newMenu);
    }

    void TopMenu::shortenMenuLeft(multipleStrings& menu) const
    {
        auto newMenu = multipleStrings();

        for (int i = 0; i < max_urls; i++)
        {
            newMenu.addContent(menu.data[i]);
        }
        addEllipsis(newMenu);
        newMenu.addContent(menu.data.back());
        std::swap(menu, newMenu);
    }

    void TopMenu::shortenMenuRight(multipleStrings& menu) const
    {
        auto newMenu = multipleStrings();

        const int nEntries = static_cast<int>(menu.data.size());

        newMenu.addContent(menu.data[0]);
        addEllipsis(newMenu);
        for (int i = nEntries - max_urls; i < nEntries; i++)
        {
            newMenu.addContent(menu.data[i]);
        }
        std::swap(menu, newMenu);
    }

}
