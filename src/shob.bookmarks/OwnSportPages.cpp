#include "OwnSportPages.h"
#include "../shob.general/Season.h"
#include <format>

namespace shob::bookmarks
{
    ListOfEvents OwnSportPages::getOlympicIceSkating()
    {
        constexpr int first_year = 1994;
        constexpr int last_year = 2026;
        constexpr int step = 4;
        ListOfEvents return_value;
        for (int i = first_year; i <= last_year; i += step)
        {
            Event e;
            e.name = std::format("{}", i);
            e.url = std::format("sport_schaatsen_OS_{}.html", i);
            return_value.add(e);
        }
        return return_value;
    }

    ListOfEvents OwnSportPages::getEkWkSoccer()
    {
        constexpr int first_year = 1996;
        constexpr int last_year = 2026;
        constexpr int step = 2;
        ListOfEvents return_value;
        for (int i = first_year; i <= last_year; i += step)
        {
            Event e;
            if (i % 4 == 2)
            {
                e.name = std::format("WK {}", i);
                e.url = std::format("sport_voetbal_WK_{}.html", i);
            }
            else
            {
                e.name = std::format("EK {}", i);
                e.url = std::format("sport_voetbal_EK_{}.html", i);
            }
            return_value.add(e);
        }
        return return_value;
    }

    ListOfEvents OwnSportPages::getDutchSoccer()
    {
        constexpr int first_year = 1993;
        constexpr int last_year = 2026;
        ListOfEvents return_value;
        for (int i = first_year; i <= last_year; i++)
        {
            auto szn = general::Season(i);
            Event e;
            e.name = szn.toString();
            e.url = std::format("sport_voetbal_nl_{}.html", szn.toPartFilename());
            return_value.add(e);
        }
        return return_value;
    }

    ListOfEvents OwnSportPages::getEuropacupSoccer()
    {
        constexpr int first_year = 1994;
        constexpr int last_year = 2026;
        ListOfEvents return_value;
        for (int i = first_year; i <= last_year; i++)
        {
            auto szn = general::Season(i);
            Event e;
            e.name = szn.toString();
            e.url = std::format("sport_voetbal_europacup_{}.html", szn.toPartFilename());
            return_value.add(e);
        }
        return return_value;
    }
}
