
#pragma once
#include <string>
#include <vector>

namespace shob::pages
{
    class format_nl
    {
    public:
        static void get_season_stdout(const std::string& season);
        static std::vector<std::string> get_season(const std::string& season);
    };
}
