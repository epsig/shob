
#include <iostream>
#include <filesystem>

#include "shob.general/dateFactory.h"
#include "shob.pages/format_ec_factory.h"
#include "shob.pages/format_nl_factory.h"
#include "shob.general/season.h"
#include "shob.general/shobException.h"

int main(int argc, char* argv[])
{
    using namespace std::filesystem;
    using namespace shob::pages;
    using namespace shob::general;

    try
    {
        int firstYear = 1993;
        int lastYear = 2024;

        if (argc >= 3)
        {
            if (dateFactory::allDigits(argv[1]) && dateFactory::allDigits(argv[2]))
            {
                firstYear = std::atoi(argv[1]);
                lastYear = std::atoi(argv[2]);
            }
            else
            {
                throw shobException("first two command line arguments must be years");
            }
        }
        auto fmt_nl = format_nl_factory::build("sport");
        constexpr auto settings = shob::html::settings();
        auto fmt_ec = format_ec_factory::build("sport", settings);
        for (int year = firstYear; year <= lastYear; year++)
        {
            const auto season = shob::general::season(year);
            fmt_nl.get_season_to_file(season, "../pages_new/sport_voetbal_nl_" + season.to_part_filename() + ".html");
            if (year >= 1994)
            {
                fmt_ec.get_season_to_file(season, "../pages_new/sport_voetbal_europacup_" + season.to_part_filename() + ".html");
            }
        }
        copy("../code/test/epsig.css", "../pages_new/epsig.css");
    }
    catch (const std::exception& e)
    {
        std::cout << e.what() << std::endl;
        return -1;
    }

    return 0;
}
