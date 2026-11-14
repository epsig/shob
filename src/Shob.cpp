#include <filesystem>
#include <iostream>
#include <format>
#include <algorithm>

#include "shob.general/DateFactory.h"
#include "shob.main/HandleAllSportPages.h"
#include "shob.pages/FormatHomePage.h"
#include "shob.pages/FormatBookmarks.h"
#include "shob.pages/FormatRest.h"
#include "shob.pages/FormatKlaverjas.h"
#include "shob.klaverjas/MergeJavaScript.h"
#include "shob.general/Season.h"
#include "shob.general/ShobException.h"
#include "shob.html/UpdateIfNewer.h"

void read_command_line(int argc, char* argv[], int& yr1, int&yr2, bool& skip_kj)
{
    using namespace shob::general;
    if (argc >= 3)
    {
        if (DateFactory::allDigits(argv[1]) && DateFactory::allDigits(argv[2]))
        {
            const std::string arg1 = argv[1];
            const std::string arg2 = argv[2];
            yr1 = std::stoi(arg1);
            yr2 = std::stoi(arg2);
            if (argc >= 4)
            {
                skip_kj = (std::string(argv[3]) != "with_kj");
            }
        }
        else
        {
            throw ShobException("first two command line arguments must be years");
        }
    }
    else if (argc == 2)
    {
        if (DateFactory::allDigits(argv[1]))
        {
            const std::string arg1 = argv[1];
            yr1 = std::stoi(arg1);
            yr2 = yr1;
        }
        else
        {
            throw ShobException("first command line argument must be a year");
        }
    }
}


int main(int argc, char* argv[])
{
    using namespace shob::pages;
    using namespace shob::general;
    using namespace shob::main;

    std::string part;
    try
    {
        int firstYear = 1993;
        int lastYear = 2026; // TODO function of current date
        bool skip_kj = true;

        read_command_line(argc, argv, firstYear, lastYear, skip_kj);

        int dd = 0;
        HandleAllSportPages::build_all_sport(firstYear, lastYear, dd, part);

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
