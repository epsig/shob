
#pragma once

#include "footballMatch.h"
#include "../shob.html/table.h"
#include "../shob.html/settings.h"
#include <set>
#include <vector>

namespace shob::football
{
    class footballCompetition
    {
    public:
        std::string id;
        std::vector<footballMatch> matches;
        void readFromCsv(const std::string & filename);
        void readFromCsvData(const std::vector<std::vector<std::string>>& csvData);
        footballCompetition filter(const std::set<std::string>& clubs) const;
        html::tableContent prepareTable(const teams::clubTeams& teams, const html::settings& settings) const;
    };

}

