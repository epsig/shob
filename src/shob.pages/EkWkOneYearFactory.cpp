#include "EkWkOneYearFactory.h"

#include <format>
#include <filesystem>

#include "../shob.football/route2finalFactory.h"
#include "../shob.football/route2final.h"
#include "../shob.football/filterResults.h"
#include "../shob.football/results2standings.h"

namespace shob::pages
{
    namespace fs = std::filesystem;
    EkWkOneYear EkWkOneYearFactory::Factory(const EkWkDate ekwk, const html::settings settings, const teams::clubTeams& teams,
            const readers::csvAllSeasonsReader& top_scorers, const teams::footballers& players,
            const std::vector<std::vector<std::string>>& current_remarks, const std::string& data_sport_folder)
    {
        int year = ekwk.year;
        const std::string filename = data_sport_folder + "/ekwk/" + ekwk.shortName() + std::to_string(year) + ".csv";
        auto csv_content = readers::csvReader::readCsvFile(filename);

        auto r2f = football::route2finaleFactory::create(csv_content);

        auto groups = getGroupData(csv_content, current_remarks);
        auto round2 = getRound2data(csv_content);

        auto filename_xml = data_sport_folder + "/ekwk/" + ekwk.shortNameUpper() + "_" + std::to_string(year) + ".xml";
        readers::xmlReader reader;
        if (fs::exists(filename_xml))
        {
            reader = readers::xmlReader(filename_xml);
        }

        auto result = EkWkOneYear(ekwk, settings, teams, top_scorers, players, current_remarks,
            r2f, groups, round2, reader);
        return result;
    }

    football::footballCompetition EkWkOneYearFactory::getRound2data(const readers::csvContent& csv_content)
    {
        auto filter = football::filterInputList();
        filter.filters.push_back({ 0, "round2" });
        const auto round2 = football::filterResults::readFromCsvData(csv_content, filter);

        return round2;
    }

    general::uniqueStrings EkWkOneYearFactory::getGroups(const readers::csvContent& csv_content)
    {
        auto groups = general::uniqueStrings();
        for (const auto& row : csv_content.body)
        {
            if (row.column[0].at(0) == 'g')
            {
                groups.insert(row.column[0]);
            }
        }
        return groups;
    }

    groupList EkWkOneYearFactory::getGroupData(const readers::csvContent& csv_content, const std::vector<std::vector<std::string>>& current_remarks)
    {
        const auto groups = getGroups(csv_content).list();
        auto retval = groupList();

        int ster_default = 0;
        int sort_rule = 5;
        for (const auto& cur_rem : current_remarks)
        {
            if (cur_rem[0] == "allgroups")
            {
                ster_default = std::stoi(cur_rem[1].substr(5, 1));
            }
            else if (cur_rem[0] == "sort_rule")
            {
                sort_rule = std::stoi(cur_rem[1]);
            }
        }

        for (const auto& group : groups)
        {
            auto filter = football::filterInputList();
            filter.filters.push_back({ 0, group });
            const auto groupsPhase = football::filterResults::readFromCsvData(csv_content, filter);
            auto stand = football::results2standings::u2s(groupsPhase, 3, sort_rule);
            int ster_cur_group = ster_default;
            for (const auto& cur_rem : current_remarks)
            {
                if (cur_rem[0] == group) ster_cur_group = std::stoi(cur_rem[1].substr(5, 1));
            }
            stand.wns_cl = ster_cur_group;
            std::string long_name = std::format("group{}", group.back());
            retval.data.push_back({ group, long_name, groupsPhase, stand });
        }
        return retval;
    }

}

