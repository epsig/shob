#pragma once

#include "FormatEkWk.h"
#include "EkWkDate.h"
#include "PageBlock.h"
#include "../shob.readers/csvReader.h"
#include "../shob.football/route2final.h"

#include <string>
#include <vector>
#include <boost/property_tree/ptree.hpp>

namespace shob::pages
{
    class EkWkOneYear
    {
    public:
        EkWkOneYear(const html::settings settings, const teams::clubTeams& teams,
           const readers::csvAllSeasonsReader& top_scorers, const teams::footballers& players)
            : settings(settings), teams(teams), top_scorers(top_scorers), players(players) {}
        static general::uniqueStrings getGroups(const readers::csvContent& data);
        static groupList getGroupData(const readers::csvContent& data, const std::vector<std::vector<std::string>>& current_remarks);
        static football::footballCompetition getRound2data(const readers::csvContent& data);
        PageBlock getRound2(const football::footballCompetition& round2, int& dd) const;
        PageBlock getLast16(const football::route2final& r2f, int& dd) const;
        PageBlock getGroupResults(const groupList& groups, int& dd) const;
        PageBlock getStats(const football::route2final& r2f, const groupList& groups, const football::footballCompetition& round2) const;
        PageBlock getTopscorers(const EkWkDate& ekwk) const;
        PageBlock printExtras(const groupList& groups, const football::footballCompetition& round2,
            const football::route2final& r2f, const std::string& filename_xml) const;

    private:
        const html::settings settings;
        const teams::clubTeams& teams;
        const readers::csvAllSeasonsReader& top_scorers;
        const teams::footballers& players;
        void getFieldsTable3(const std::vector<football::footballMatch>& matches, std::string& matchNames,
            std::string& results) const;
        general::MultipleStrings table3_to_html(const football::strikingResults& data) const;
        general::MultipleStrings getExtraForOneMatch(const groupData& g, const football::linkInfo& link,
            const std::string& ko_phase, const boost::property_tree::ptree& pt) const;
    };
}

