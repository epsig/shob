
#include <iostream>

#include "shob.general/dateFactory.h"
#include "shob.pages/format_ec_factory.h"
#include "shob.pages/format_nl_factory.h"
#include "shob.general/season.h"
#include "shob.general/shobException.h"

int main(int argc, char* argv[])
{
    try
    {
        int firstYear = 1994;
        int lastYear = 2024;

        if (argc >= 3)
        {
            if (shob::general::dateFactory::allDigits(argv[1]) && shob::general::dateFactory::allDigits(argv[2]))
            {
                firstYear = std::atoi(argv[1]);
                lastYear = std::atoi(argv[2]);
            }
            else
            {
                throw shob::general::shobException("first two command line arguments must be years");
            }
        }
        auto fmt_nl = shob::pages::format_nl_factory::build("sport");
        constexpr auto settings = shob::html::settings();
        auto fmt_ec = shob::pages::format_ec_factory::build("sport", settings);
        for (int year = firstYear; year <= lastYear; year++)
        {
            const auto season = shob::general::season(year);
            fmt_nl.get_season_to_file(season, "../pages_new/sport_nl_" + season.to_part_filename() + ".html");
            fmt_ec.get_season_to_file(season, "../pages_new/sport_ec_" + season.to_part_filename() + ".html");
        }
    }
    catch (const std::exception& e)
    {
        std::cout << e.what() << std::endl;
        return -1;
    }

    return 0;
}
