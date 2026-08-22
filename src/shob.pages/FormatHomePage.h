#pragma once
#include "../shob.general/MultipleStrings.h"

namespace shob::pages
{
    class FormatHomePage
    {
    public:
        static void RebuildHomePage(const int dd);
    private:
        static general::MultipleStrings OwnSportLinks();
    };
}
