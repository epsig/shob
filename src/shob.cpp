
#include <filesystem>
#include <iostream>
#include <format>

#include "shob.general/dateFactory.h"
#include "shob.pages/format_ec_factory.h"
#include "shob.pages/format_nl_factory.h"
#include "shob.pages/format_voorr_ekwk.h"
#include "shob.general/season.h"
#include "shob.general/shobException.h"
#include "shob.html/updateIfNewer.h"

int main(int argc, char* argv[])
{
    using namespace shob::pages;
    using namespace shob::general;

    try
    {
        int firstYear = 1993;
        int lastYear = 2025;

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
        auto settings = shob::html::settings();
        settings.dateFormatShort = false;
        auto fmt_ec = format_ec_factory::build("sport", settings);
        for (int year = firstYear; year <= lastYear; year++)
        {
            const auto season = shob::general::season(year);
            if ( std::filesystem::is_directory("../pages_new/"))
            {
                fmt_nl.get_season_to_file(season, "../pages_new/sport_voetbal_nl_" + season.to_part_filename() + ".html");
            }
            if (year >= 1994)
            {
                fmt_ec.get_season_to_file(season, "../pages/sport_voetbal_europacup_" + season.to_part_filename() + ".html");
            }
            if (year % 2 == 0)
            {
                auto national_teams = shob::teams::clubTeams();
                national_teams.InitFromFile("sport/landcodes.csv");

                auto fmt = format_voorr_ekwk("sport/ekwk_qf/", national_teams);
                fmt.get_pages_to_file(year, std::format("../pages_new/voorronde_{}.html", year));
            }
        }
        if (std::filesystem::is_directory("../pages_new/"))
        {
            shob::html::updateIfDifferent::update("../code/test/epsig.css", "../pages_new/epsig.css");
        }
        if (std::filesystem::is_directory("../pages_compatible/"))
        {
            shob::html::updateIfDifferent::update("../code/test/epsig.css", "../pages_compatible/epsig.css");
        }
    }
    catch (const std::exception& e)
    {
        std::cout << e.what() << std::endl;
        return -1;
    }

    return 0;
}
