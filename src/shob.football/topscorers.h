
#pragma once
#include <vector>
#include <string>
#include "../shob.readers/csvAllSeasonsReader.h"

namespace shob::football
{
    struct topscorer
    {
        int rank;
        std::string name;
        std::string club;
        int goals;
    };

    class topscorers
    {
    public:
        topscorers(const readers::csvAllSeasonsReader& reader) : reader(reader) {}
        void initFromFile(const std::string& season);
    private:
        const readers::csvAllSeasonsReader& reader;
        std::vector<topscorer> list_tp;
    };
}

