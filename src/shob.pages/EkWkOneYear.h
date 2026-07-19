#pragma once

#include "EkWkDate.h"
#include "PageBlock.h"
#include "../shob.readers/csvReader.h"
#include "../shob.football/route2final.h"
#include "../shob.readers/csvAllSeasonsReader.h"
#include "../shob.football/standings.h"
#include "../shob.teams/footballer.h"
#include "../shob.readers/xmlReader.h"

#include <string>
#include <vector>

namespace shob::pages
{
    struct groupData
    {
        std::string name;
        std::string long_name;
        football::footballCompetition matches;
        football::standings standings;
    };

    struct groupList
    {
        std::vector<groupData> data;
    };

    class EkWkOneYear
    {
    public:
        EkWkOneYear(const EkWkDate ekwk, const html::settings settings, const teams::clubTeams& teams,
            const readers::csvAllSeasonsReader& top_scorers, const teams::footballers& players,
            const std::vector<std::vector<std::string>>& current_remarks,
            football::route2final r2f,
            groupList groups,
            football::footballCompetition round2,
            readers::xmlReader reader
            );
        std::vector<PageBlock> getAllPageBlocks(int& dd);

    private:
        const EkWkDate ekwk;
        const html::settings settings;
        const teams::clubTeams& teams;
        const readers::csvAllSeasonsReader& top_scorers;
        const teams::footballers& players;
        const std::vector<std::vector<std::string>>& current_remarks;
        readers::csvContent csv_content;
        football::route2final r2f;
        groupList groups;
        football::footballCompetition round2;
        readers::xmlReader reader;

        general::uniqueStrings getGroups() const;
        PageBlock getRound2(int& dd) const;
        PageBlock getLast16(int& dd) const;
        PageBlock getGroupResults(int& dd) const;
        PageBlock getStats() const;
        PageBlock getTopscorers() const;
        PageBlock printExtras();

        void getFieldsTable3(const std::vector<football::footballMatch>& matches, std::string& matchNames,
            std::string& results) const;
        general::MultipleStrings table3_to_html(const football::strikingResults& data) const;
        general::MultipleStrings getExtraForOneMatch(const groupData& g, const football::linkInfo& link,
            const std::string& ko_phase);
    };
}

