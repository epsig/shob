
#include <iostream>

#include "shob.pages/format_ec_factory.h"
#include "shob.pages/format_nl_factory.h"

int main(int argc, char* argv[])
{
    if (argc < 3)
    {
        std::cout << "usage: " << argv[0] << " type season" << std::endl;
        std::cout << "example type season : nl 2022-2023." << std::endl;
        std::cout << "                 or : ec 2012-2013." << std::endl;
        std::cout << "must be run in the 'data' folder." << std::endl;
        return -1;
    }
    std::string type = argv[1];
    std::string season = argv[2];

    try
    {
        if (type == "nl")
        {
            auto fmt_nl = shob::pages::format_nl_factory::build("sport");
            fmt_nl.get_season_stdout(season);
        }
        else if (type == "ec")
        {
            auto fmt_ec = shob::pages::format_ec_factory::build("sport");
            fmt_ec.get_season_stdout(season);
        }
    }
    catch (const std::exception& e)
    {
        std::cout << e.what() << std::endl;
        return -1;
    }

    return 0;
}
