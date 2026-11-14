#pragma once

#include "EkWkDate.h"
#include "PageBlock.h"
#include "../shob.readers/CsvReader.h"
#include "../shob.football/RouteToFinal.h"
#include "../shob.readers/CsvAllSeasonsReader.h"
#include "../shob.football/Standings.h"
#include "../shob.teams/Footballer.h"
#include "../shob.readers/XmlReader.h"

#include <string>
#include <vector>

namespace shob::pages
{
    struct groupData
    {
        std::string name;
        std::string long_name;
        football::FootballCompetition matches;
        football::Standings standings;
    };

    struct groupList
    {
        std::vector<groupData> data;
    };

    class EkWkOneYear
    {
    public:
        EkWkOneYear(const EkWkDate ekwk, const html::Settings settings, const teams::ClubTeams& teams,
            const readers::CsvAllSeasonsReader& top_scorers, const teams::Footballers& players,
            const std::vector<std::vector<std::string>>& current_remarks,
            football::RouteToFfinal r2f,
            groupList groups,
            football::FootballCompetition round2,
            readers::XmlReader reader
            );
        std::vector<PageBlock> getAllPageBlocks(int& dd);

    private:
        const EkWkDate ekwk;
        const html::Settings settings;
        const teams::ClubTeams& teams;
        const readers::CsvAllSeasonsReader& top_scorers;
        const teams::Footballers& players;
        const std::vector<std::vector<std::string>>& current_remarks;
        readers::CsvContent csv_content;
        football::RouteToFfinal r2f;
        groupList groups;
        football::FootballCompetition round2;
        readers::XmlReader reader;

        general::UniqueStrings getGroups() const;
        PageBlock getRound2(int& dd) const;
        PageBlock getLast16(int& dd) const;
        PageBlock getGroupResults(int& dd) const;
        PageBlock getStats() const;
        PageBlock getTopscorers() const;
        PageBlock printExtras();

        void getFieldsTable3(const std::vector<football::FootballMatch>& matches, std::string& matchNames,
            std::string& results) const;
        general::MultipleStrings table3_to_html(const football::strikingResults& data) const;
        general::MultipleStrings getExtraForOneMatch(const groupData& g, const football::linkInfo& link,
            const std::string& ko_phase);
    };
}

