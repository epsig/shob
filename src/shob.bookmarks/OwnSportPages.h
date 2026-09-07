#pragma once
#include "ListOfEvents.h"

namespace shob::bookmarks
{
    class OwnSportPages
    {
    public:
        static ListOfEvents getOlympicIceSkating();
        static ListOfEvents getEkWkSoccerWoman();
        static ListOfEvents getEkWkSoccer();
        static ListOfEvents getDutchSoccer(const bool short_format = false);
        static ListOfEvents getEuropacupSoccer(const bool short_format = false);
    };
}
