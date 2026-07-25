#pragma once

#include "EkWkOneYear.h"

namespace shob::pages
{
    class EkWkOneYearFactory
    {
    public:
        static EkWkOneYear Factory(const EkWkDate ekwk, const html::settings settings, const teams::clubTeams& teams,
            const readers::csvAllSeasonsReader& top_scorers, const teams::footballers& players,
            const std::vector<std::vector<std::string>>& current_remarks, const std::string& data_sport_folder);
    private:
        static groupList getGroupData(const readers::csvContent& csv_content, const std::vector<std::vector<std::string>>& current_remarks);
        static football::footballCompetition getRound2data(const readers::csvContent& csv_content);
        static general::uniqueStrings getGroups(const readers::csvContent& csv_content);
    };
}
