#pragma once
#include "../shob.general/MultipleStrings.h"

namespace shob::pages
{
    class FormatHomePage
    {
    public:
        FormatHomePage(const std::string& data_folder) : data_folder(data_folder) {}
        void rebuildHomePage(const int dd) const;
        general::MultipleStrings getHomePage(const int dd) const;
    private:
        std::string data_folder;
        static general::MultipleStrings ownSportLinks();
        general::MultipleStrings currentEventsLinks(const int dd) const;
        static general::MultipleStrings blockTopLeft();
        static general::MultipleStrings blockBottomRight();
        static void AddPunctuation(general::MultipleStrings& extra);
    };
}
