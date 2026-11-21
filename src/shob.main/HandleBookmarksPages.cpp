#include "HandleBookmarksPages.h"
#include "../shob.pages/FormatHomePage.h"
#include "../shob.pages/FormatBookmarks.h"

namespace shob::main
{
    using namespace shob::pages;

    void HandleBookmarksPages::buildAllBookmarks(std::string& part, int dd)
    {
        part = "bookmarks";
        auto fmt_home_page = FormatHomePage("bookmarks/");
        fmt_home_page.rebuildHomePage(dd);

        const auto fmt_bookmarks = FormatBookmarks("bookmarks/", dd);
        fmt_bookmarks.rebuildBookmarks("media");
        fmt_bookmarks.rebuildBookmarks("treinen");
        fmt_bookmarks.rebuildBookmarks("computers");
        fmt_bookmarks.rebuildBookmarks("sport");
        fmt_bookmarks.rebuildBookmarks("science", true);
        fmt_bookmarks.rebuildBookmarks("milieu", true);
        FormatBookmarks::rebuildOwnSportLinks();
        FormatBookmarks::rebuildOverzicht();
    }
}
