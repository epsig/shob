#pragma once
#include <string>

namespace shob::main
{
    class HandleAllSportPages
    {
    public:
        static void buildAllSport(const int first_year, const int last_year, int& dd, std::string& part);
    };
}
