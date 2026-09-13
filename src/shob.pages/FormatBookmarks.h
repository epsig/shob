#pragma once
#include "../shob.general/MultipleStrings.h"
#include "../shob.bookmarks/ConfigurableBookmarks.h"

namespace shob::pages
{
    struct SportLinks
    {
        general::MultipleStrings os;
        general::MultipleStrings ekwk;
        general::MultipleStrings ekwk_D;
        general::MultipleStrings eredivisie;
        general::MultipleStrings europacup;
    };

    class FormatBookmarks
    {
    public:
        FormatBookmarks(const std::string& folder, const int dd);
        void rebuildBookmarks(const std::string& page, const bool is_tmp = false) const;
        static void rebuildOwnSportLinks();
        static void rebuildOverzicht();
        general::MultipleStrings getBookmarks(const std::string& page, const bool is_tmp) const;
    private:
        bookmarks::ConfigurableBookmarks bookmarks;
        int dd;
        std::string folder;
        static constexpr int last_dd = 20260912;
        static SportLinks FillSportLinks();
        general::MultipleStrings currentEventsLinks() const;
        static void AddPunctuation(general::MultipleStrings& extra);
    };
}
