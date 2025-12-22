
#pragma once

#include "footballMatch.h"
#include "../shob.html/table.h"
#include "../shob.html/settings.h"
#include "../shob.readers/csvReader.h"
#include "../shob.general/itdate.h"
#include <set>
#include <map>
#include <vector>

namespace shob::football
{
    struct coupledMatchesData
    {
        std::map<size_t, size_t> couples;
        std::vector<bool> isSecondMatch;
    };

    class footballCompetition
    {
    public:
        std::string id;
        std::vector<footballMatch> matches;
        void readFromCsv(const std::string & filename);
        void readFromCsvData(const readers::csvContent& csvData);
        coupledMatchesData getReturns() const;
        footballCompetition filter(const std::set<std::string>& clubs) const;
        footballCompetition filterNL() const;
        std::pair<footballCompetition, footballCompetition> split_matches(const std::string& team) const;
        footballCompetition filterDate(const general::itdate& date1, const general::itdate& date2) const;
        html::tableContent prepareTable(const teams::clubTeams& teams, const html::settings& settings) const;
        bool onlyKO = false;
        general::itdate lastDate() const;
        bool doCoupleMatches = true;
    private:
        bool equalTeams(size_t i, size_t j) const;
    };

}

