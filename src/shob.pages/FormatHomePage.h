#pragma once
#include "../shob.general/MultipleStrings.h"

namespace shob::pages
{
    class FormatHomePage
    {
    public:
        static void rebuildHomePage(const int dd);
    private:
        static general::MultipleStrings ownSportLinks();
        static general::MultipleStrings currentEventsLinks(const int dd);
        static general::MultipleStrings blockTopLeft();
        static general::MultipleStrings blockBottomRight();
        static void AddPunctuation(general::MultipleStrings& extra);
    };
}
