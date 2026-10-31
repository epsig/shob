
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
    struct Topscorer
    {
        int rank = 0;
        std::string name;
        std::string club;
        int goals = 0;
    };

    struct Numbers1
    {
        std::vector<std::string> ListNamesWithClubs;
        int goals = 0;
    };

    class Topscorers
    {
    public:
        Topscorers(const readers::csvAllSeasonsReader& reader) : reader(reader) {}
        void initFromFile(const general::Season& season);
        void initFromFile(const std::string& season);
        html::tableContent prepareTable(const teams::clubTeams& teams, const teams::footballers& players, const html::settings& settings) const;
        Numbers1 getNumbers1(const teams::clubTeams& teams, const teams::footballers& players) const;
        size_t getSizeList() const { return list_tp.size(); }
    private:
        const readers::csvAllSeasonsReader& reader;
        std::vector<Topscorer> list_tp;
        void initFromFile(const std::vector<std::vector<std::string>>& data);
    };
}

