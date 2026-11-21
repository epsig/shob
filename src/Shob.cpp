#include <filesystem>
#include <iostream>

#include "shob.main/GetDefaultFirstLastYear.h"
#include "shob.main/HandleAllSportPages.h"
#include "shob.main/HandleKlaverjasPages.h"
#include "shob.main/HandleBookmarksPages.h"
#include "shob.main/HandleRemainingPages.h"
#include "shob.main/CommandLine.h"
#include "shob.html/UpdateIfNewer.h"

int main(int argc, char* argv[])
{
    using namespace shob::general;
    using namespace shob::main;

    std::string part;
    try
    {
        int first_year;
        int last_year;
        GetDefaultFirstLastYear::get(first_year, last_year);
        bool skip_kj = true;

        CommandLine::readCommandLine(argc, argv, first_year, last_year, skip_kj);

        int dd = 0;
        HandleAllSportPages::buildAllSport(first_year, last_year, dd, part);

        HandleBookmarksPages::buildAllBookmarks(part, dd);

        HandleKlaverjasPages::buildAllKJ(part, skip_kj);

        HandleRemainingPages::buildAllRemaining(part, dd);

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
