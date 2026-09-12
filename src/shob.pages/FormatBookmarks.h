#pragma once
#include "../shob.general/MultipleStrings.h"
#include "../shob.bookmarks/ConfigurableBookmarks.h"

namespace shob::pages
{
    class FormatBookmarks
    {
    public:
        FormatBookmarks(const std::string& folder, const int dd);
        void rebuildBookmarks(const std::string& page, const bool is_tmp = false) const;
        static void rebuildOwnSportLinks();
        static void rebuildOverzicht();
    private:
        bookmarks::ConfigurableBookmarks bookmarks;
        int dd;
        static constexpr int last_dd = 20260912;
        general::MultipleStrings currentEventsLinks() const;
        static void AddPunctuation(general::MultipleStrings& extra);
    };
}
