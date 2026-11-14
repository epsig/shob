#pragma once
#include <vector>
#include <string>
#include "../shob.readers/CsvAllSeasonsReader.h"
#include "../shob.html/Table.h"
#include "../shob.teams/ClubTeams.h"
#include "../shob.teams/Footballer.h"
#include "../shob.html/Settings.h"
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
        Topscorers(const readers::CsvAllSeasonsReader& reader) : reader(reader) {}
        void initFromFile(const general::Season& season);
        void initFromFile(const std::string& season);
        html::TableContent prepareTable(const teams::ClubTeams& teams, const teams::Footballers& players, const html::Settings& settings) const;
        Numbers1 getNumbers1(const teams::ClubTeams& teams, const teams::Footballers& players) const;
        size_t getSizeList() const { return list_tp.size(); }
    private:
        const readers::CsvAllSeasonsReader& reader;
        std::vector<Topscorer> list_tp;
        void initFromFile(const std::vector<std::vector<std::string>>& data);
    };
}

