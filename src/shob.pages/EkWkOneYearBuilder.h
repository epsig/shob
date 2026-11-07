#pragma once

#include "EkWkOneYear.h"

namespace shob::pages
{
    class EkWkOneYearBuilder
    {
    public:
        static EkWkOneYear build(const EkWkDate ekwk, const html::Settings settings, const teams::ClubTeams& teams,
            const readers::CsvAllSeasonsReader& top_scorers, const teams::Footballers& players,
            const std::vector<std::vector<std::string>>& current_remarks, const std::string& data_sport_folder);
    private:
        static groupList getGroupData(const readers::CsvContent& csv_content, const std::vector<std::vector<std::string>>& current_remarks);
        static football::FootballCompetition getRound2data(const readers::CsvContent& csv_content);
        static general::UniqueStrings getGroups(const readers::CsvContent& csv_content);
    };
}
