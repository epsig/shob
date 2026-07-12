#pragma once

#include "FormatEkWk.h"
#include "EkWkDate.h"
#include "PageBlock.h"
#include "../shob.readers/csvReader.h"
#include "../shob.football/route2final.h"

#include <string>
#include <vector>
#include <memory>
#include <boost/property_tree/ptree.hpp>

namespace shob::pages
{
    class EkWkOneYear
    {
    public:
        EkWkOneYear(const EkWkDate ekwk, const html::settings settings, const teams::clubTeams& teams,
            const readers::csvAllSeasonsReader& top_scorers, const teams::footballers& players, const std::string& data_sport_folder);
        general::uniqueStrings getGroups();
        groupList getGroupData(const std::vector<std::vector<std::string>>& current_remarks);
        football::footballCompetition getRound2data() const;
        PageBlock getRound2(const football::footballCompetition& round2, int& dd) const;
        PageBlock getLast16(int& dd) const;
        PageBlock getGroupResults(const groupList& groups, int& dd) const;
        PageBlock getStats(const groupList& groups, const football::footballCompetition& round2) const;
        PageBlock getTopscorers(const EkWkDate& ekwk) const;
        PageBlock printExtras(const groupList& groups, const football::footballCompetition& round2) const;

    private:
        const EkWkDate ekwk;
        const html::settings settings;
        const teams::clubTeams& teams;
        const readers::csvAllSeasonsReader& top_scorers;
        const teams::footballers& players;
        readers::csvContent csv_content;
        std::shared_ptr<football::route2final> r2f;
        std::string filename_xml;
        void getFieldsTable3(const std::vector<football::footballMatch>& matches, std::string& matchNames,
            std::string& results) const;
        general::MultipleStrings table3_to_html(const football::strikingResults& data) const;
        general::MultipleStrings getExtraForOneMatch(const groupData& g, const football::linkInfo& link,
            const std::string& ko_phase, const boost::property_tree::ptree& pt) const;
    };
}

