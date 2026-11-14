#include <filesystem>
#include <iostream>
#include <format>
#include <algorithm>

#include "shob.main/HandleAllSportPages.h"
#include "shob.main/CommandLine.h"
#include "shob.pages/FormatHomePage.h"
#include "shob.pages/FormatBookmarks.h"
#include "shob.pages/FormatRest.h"
#include "shob.pages/FormatKlaverjas.h"
#include "shob.klaverjas/MergeJavaScript.h"
#include "shob.general/Season.h"
#include "shob.general/ShobException.h"
#include "shob.html/UpdateIfNewer.h"

int main(int argc, char* argv[])
{
    using namespace shob::pages;
    using namespace shob::general;
    using namespace shob::main;

    std::string part;
    try
    {
        int first_year = 1993;
        int last_year = 2026; // TODO function of current date
        bool skip_kj = true;

        CommandLine::readCommandLine(argc, argv, first_year, last_year, skip_kj);

        int dd = 0;
        HandleAllSportPages::buildAllSport(first_year, last_year, dd, part);

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
        fmt_bookmarks.rebuildOwnSportLinks();
        fmt_bookmarks.rebuildOverzicht();

        part = "klaverjas";
        if (!skip_kj)
        {
            shob::klaverjas::MergeJavaScript::mergeFiles("gfx");
            shob::klaverjas::MergeJavaScript::mergeFiles("txt");
            auto fmt_klaverjas = FormatKlaverjas();
            for (const auto& location : { "adam", "rdam" })
            {
                for (const auto& type : { "gfx", "txt", "klein" })
                {
                    fmt_klaverjas.rebuildKlaverjas(type, location);
                }
            }
            fmt_klaverjas.rebuildFaq();
        }

        part = "rest";
        auto fmt_rest = FormatRest("doc/");
        fmt_rest.rebuildTechDoc(TechDocType::Klaverjas, 20261023);
        fmt_rest.rebuildTechDoc(TechDocType::Shob, 20261023);
        fmt_rest.rebuildLetters();
        fmt_rest.rebuildAsciiCodes();
        fmt_rest.rebuildEpsig(20261023);
        fmt_rest = FormatRest("./Data_stats_website/");
        fmt_rest.rebuildStats(dd);

        part = "copy style sheets";
        shob::html::UpdateIfDifferent::update("../code/test/epsig.css", "../pages/epsig.css");
    }
    catch (const std::exception& e)
    {
        std::cout << part << "\n";
        std::cout << e.what() << "\n";
        return -1;
    }

    return 0;
}
