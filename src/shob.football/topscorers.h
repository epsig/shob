
#pragma once
#include <vector>
#include <string>
#include "../shob.readers/csvAllSeasonsReader.h"
#include "../shob.html/table.h"
#include "../shob.teams/clubTeams.h"
#include "../shob.teams/footballer.h"
#include "../shob.html/settings.h"
#include "../shob.general/Season.h"

namespace shob::football
{
    struct topscorer
    {
        int rank = 0;
        std::string name;
        std::string club;
        int goals = 0;
    };

    struct numbers1
    {
        std::vector<std::string> ListNamesWithClubs;
        int goals = 0;
    };

    class topscorers
    {
    public:
        topscorers(const readers::csvAllSeasonsReader& reader) : reader(reader) {}
        void initFromFile(const general::Season& season);
        html::tableContent prepareTable(const teams::clubTeams& teams, const teams::footballers& players, const html::settings& settings) const;
        numbers1 getNumbers1(const teams::clubTeams& teams, const teams::footballers& players) const;
        size_t getSizeList() const { return list_tp.size(); }
    private:
        const readers::csvAllSeasonsReader& reader;
        std::vector<topscorer> list_tp;
    };
}

