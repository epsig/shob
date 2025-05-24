
#include <iostream>

#include "shob.pages/format_nl_factory.h"

int main(int argc, char* argv[])
{
    if (argc < 2)
    {
        std::cout << "usage: " << argv[0] << " season" << std::endl;
        std::cout << "example season : 2022-2023." << std::endl;
        std::cout << "must be run in the 'data' folder." << std::endl;
        return -1;
    }
    std::string season = argv[1];

    try
    {
        auto fmt_nl = shob::pages::format_nl_factory::build("sport");
        fmt_nl.get_season_stdout(season);
    }
    catch (const std::exception& e)
    {
        std::cout << e.what() << std::endl;
        return -1;
    }

    return 0;
}
