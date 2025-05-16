
#pragma once
#include <vector>
#include <string>
#include "../shob.readers/csvAllSeasonsReader.h"
#include "../shob.html/table.h"
#include "../shob.teams/clubTeams.h"
#include "../shob.html/settings.h"

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
        html::tableContent prepareTable(const teams::clubTeams& teams, const html::settings& settings) const;
    private:
        const readers::csvAllSeasonsReader& reader;
        std::vector<topscorer> list_tp;
    };
}

