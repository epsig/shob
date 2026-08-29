#pragma once
#include "../shob.general/MultipleStrings.h"
#include "../shob.bookmarks/ConfigurableBookmarks.h"

namespace shob::pages
{
    class FormatBookmarks
    {
    public:
        FormatBookmarks(const std::string& folder, const int dd);
        void RebuildBookmarks(const std::string& page, const bool is_tmp = false) const;
    private:
        bookmarks::ConfigurableBookmarks bookmarks;
        int dd;
        static general::MultipleStrings InList(const general::MultipleStrings& data);
        general::MultipleStrings CurrentEventsLinks() const;
    };
}
