
#include <iostream>

#include "shob.pages/format_ec_factory.h"
#include "shob.pages/format_nl_factory.h"

int main(int argc, char* argv[])
{
    int firstYear = 1994;
    int lastYear = 2024;

    try
    {
        if (argc >= 3)
        {
            firstYear = std::atoi(argv[1]);
            lastYear = std::atoi(argv[2]);
        }
        auto fmt_nl = shob::pages::format_nl_factory::build("sport");
        constexpr auto settings = shob::html::settings();
        auto fmt_ec = shob::pages::format_ec_factory::build("sport", settings);
        for (int year = firstYear; year <= lastYear; year++)
        {
            int yp1 = year + 1;
            std::string season = std::to_string(year) + "-" + std::to_string(yp1);
            fmt_nl.get_season_to_file(season, "../pages_new/sport_nl_"+std::to_string(year)+".html"); // TODO season with underscore
            fmt_ec.get_season_to_file(season, "../pages_new/sport_ec_" + std::to_string(year) + ".html");
        }
    }
    catch (const std::exception& e)
    {
        std::cout << e.what() << std::endl;
        return -1;
    }

    return 0;
}
