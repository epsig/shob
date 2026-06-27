
#include "FormatEkWk.h"
#include "EkWkDate.h"
#include "HeadBottom.h"
#include "../shob.football/route2finalFactory.h"
#include "../shob.football/filterResults.h"
#include "../shob.football/results2standings.h"
#include "../shob.football/topscorers.h"
#include "../shob.general/MathSupport.h"
#include "../shob.readers/xmlReader.h"

#include <format>
#include <filesystem>
#include <array>
#include <boost/property_tree/xml_parser.hpp>

namespace shob::pages
{
    namespace fs = std::filesystem;
    using namespace shob::general;

    bool FormatEkWk::isValidYear(const int year) const
    {
        const std::string ek_file = std::format("{}{}{}{}", data_sport_folder, "/ekwk/ek", year, ".csv");
        const std::string wk_file = std::format("{}{}{}{}", data_sport_folder, "/ekwk/wk", year, ".csv");
        return fs::exists(ek_file) || fs::exists(wk_file);
    }

    std::string FormatEkWk::getOutputFilename(const std::string& folder, const int year) const
    {
        constexpr auto fmt_out_file = "{}/sport_voetbal_{}_{}.html";

        switch (year % 4)
        {
        case 0:
            return std::format(fmt_out_file, folder, "EK", year);
        case 2:
            return std::format(fmt_out_file, folder, "WK", year);
        default:
            return "";
        }
    }

    std::string FormatEkWk::getOutputFilename(const std::string& folder) const
    {
        return "";
    }

    int FormatEkWk::getLastYear() const
    {
        return 2026;
    }

    MultipleStrings FormatEkWk::getPages(const int year) const
    {
        const auto ekwk = EkWkDate(year);
        auto retVal = MultipleStrings();
        retVal.addContent("<hr>");
        auto topMenu = top_menu.getMenu(std::to_string(year));
        retVal.addContent(topMenu);
        retVal.addContent("<hr>");

        int dd = 19920101;
        const std::string filename = data_sport_folder + "/ekwk/" + ekwk.shortName() + std::to_string(year) + ".csv";
        const readers::csvContent csv_content = readers::csvReader::readCsvFile(filename);

        const std::string filename_xml = data_sport_folder + "/ekwk/" + ekwk.shortNameUpper() + "_" + std::to_string(year) + ".xml";

        const auto groups = getGroupData(csv_content);
        const auto r2f = football::route2finaleFactory::create(csv_content);

        const auto round2 = getRound2data(csv_content);

        auto pageBlocks = std::array<PageBlock, 6>();
        pageBlocks[0] = getLast16(r2f, dd);
        pageBlocks[1] = getRound2(round2, dd);
        pageBlocks[2] = getGroupResults(groups, dd);
        pageBlocks[3] = getStats(r2f, groups, round2);
        pageBlocks[4] = getTopscorers(ekwk);
        if (fs::exists(filename_xml))
        {
            pageBlocks[5] = printExtras(groups, r2f, filename_xml);
        }

        retVal.addContent("<ul>");
        retVal.addContent("<li> <a href=\"sport_voetbal_" + ekwk.shortNameUpper() + "_" + std::to_string(year)
            + "_voorronde.html\">voorrondes en oefenduels</a> </li>");
        for (const auto& block : pageBlocks)
        {
            if (!block.data.data.empty())
            {
                retVal.addContent("<li> <a href=\"#" + block.linkName + "\">" + block.description + "</a> </li>");
            }
        }
        retVal.addContent("</ul> <hr>");

        for (auto& block : pageBlocks)
        {
            if (!block.data.data.empty())
            {
                retVal.addContent(block.data);
            }
        }

        auto hb = HeadBottomInput(dd);
        const auto organizingCountries = remarks.getAll("organising_country");
        hb.title = ekwk.shortNameUpper() + " Voetbal " + std::to_string(year) + " te " + organizingCountries.at(ekwk.shortNameWithYear());
        hb.css = StyleSheetType::SeparateFile;
        std::swap(hb.body, retVal);

        return HeadBottom::getPage(hb);
    }

    football::footballCompetition FormatEkWk::getRound2data(const readers::csvContent& data)
    {
        auto filter = football::filterInputList();
        filter.filters.push_back({ 0, "round2" });
        const auto round2 = football::filterResults::readFromCsvData(data, filter);

        return round2;
    }

    PageBlock FormatEkWk::getRound2(const football::footballCompetition& round2, int& dd) const
    {
        PageBlock ret_val;

        auto prepTable = round2.prepareTable(teams, settings);
        prepTable.title = "Tussenronde";
        dd = std::max(dd, round2.lastDate().toInt());

        auto Table = html::table(settings);
        auto content = Table.buildTable(prepTable);
        ret_val.data.addContent(content);
        ret_val.linkName = "round2";
        ret_val.description = "tussenronde";
        return ret_val;
    }

    PageBlock FormatEkWk::getLast16(const football::route2final& r2f, int& dd) const
    {
        PageBlock retval;
        auto Table = html::table(settings);
        Table.withBorder = false;
        if (!r2f.empty())
        {
            auto prepTable = r2f.prepareTable(teams, settings);
            prepTable[0].header.addContent("de laatste 16");
            auto content = Table.buildTable(prepTable);
            retval.data.addContent("<p/> <a name=\"last16\"/>");
            retval.data.addContent(content);
            retval.linkName = "last16";
            retval.description = "de laatste 16";
            dd = std::max(dd, r2f.lastDate().toInt());
        }
        return retval;
    }

    uniqueStrings FormatEkWk::getGroups(const readers::csvContent& data)
    {
        auto groups = uniqueStrings();
        for (const auto& row : data.body)
        {
            if (row.column[0].at(0) == 'g')
            {
                groups.insert(row.column[0]);
            }
        }
        return groups;
    }

    groupList FormatEkWk::getGroupData(const readers::csvContent& data)
    {
        const auto groups = getGroups(data).list();
        auto retval = groupList();

        for (const auto& group : groups)
        {
            auto filter = football::filterInputList();
            filter.filters.push_back({ 0, group });
            const auto groupsPhase = football::filterResults::readFromCsvData(data, filter);
            const auto stand = football::results2standings::u2s(groupsPhase);
            std::string long_name = std::format("group{}", group.back());
            retval.data.push_back({group, long_name, groupsPhase, stand});
        }
        return retval;
    }

    PageBlock FormatEkWk::getGroupResults(const groupList& groups, int& dd) const
    {
        auto tables = std::vector<html::tableContent>();

        for (const auto& g : groups.data)
        {
            auto group = g.name;
            auto prepTable = g.standings.prepareTable(teams, settings);
            prepTable.title = std::format("Groep {}", group.back());
            const auto prepTable2 = g.matches.prepareTable(teams, settings);
            tables.push_back(prepTable);
            tables.push_back(prepTable2);
            dd = std::max(dd, g.matches.lastDate().toInt());
        }

        auto Table = html::table(settings);
        auto ret_val = PageBlock();
        if (!groups.data.empty())
        {
            ret_val.data.addContent("<p/> <a name=\"groepsfase\"/>");
        }
        auto content = Table.buildTable(tables);
        ret_val.data.addContent(content);
        ret_val.linkName = "groepsfase";
        ret_val.description = "de groepswedstrijden";
        return ret_val;
    }

    PageBlock FormatEkWk::getStats(const football::route2final& r2f, const groupList& groups, const football::footballCompetition& round2) const
    {
        auto ret_val = PageBlock();

        auto all_matches = r2f.getAllMatches();
        for (const auto& group : groups.data)
        {
            for (auto& m : group.matches.matches)
            {
                all_matches.matches.push_back(m);
            }
        }
        for (const auto& m : round2.matches)
        {
            all_matches.matches.push_back(m);
        }

        const auto [total, matches] = all_matches.getStatsSpectators();

        ret_val.data.addContent(" <a name=\"stats\"/> <h2> Statistieken </h2>");

        const auto mean = MathSupport::divide(total, matches);
        const auto spectators = std::format("Na {} wedstrijden: {:.2f} miljoen toeschouwers; gemiddeld = {:.0f} duizend.",
            matches,  1e-6 * static_cast<double>(total), 1e-3 * mean);
        ret_val.data.addContent(spectators);

        ret_val.linkName = "stats";
        ret_val.description = "statistieken";

        return ret_val;
    }

    MultipleStrings FormatEkWk::getExtraForOneMatch(const groupData& g, const football::linkInfo& link, const std::string& ko_phase,
        const boost::property_tree::ptree& pt ) const
    {
        auto retval = MultipleStrings();

        retval.addContent("<a name=\"" + link.link_name + "\"/> ");
        std::string base_path;
        if (ko_phase.empty())
        {
            retval.addContent(std::format("Groep {}: {}<br/>", g.name.back(), link.match_name));
            base_path = "games.group_phase." + g.long_name + "." + link.link_name;
        }
        else
        {
            retval.addContent(std::format("{}: {}<br/>", ko_phase, link.match_name));
            base_path = "games.ko." + ko_phase + "." + link.link_name ;
        }
        std::string path = base_path + ".stats.stadium";
        const auto stadium = loadSingleValue(pt, path);

        path = base_path + ".stats.arbiter";
        const auto arbiter = loadSingleValue(pt, path);

        path = base_path + ".stats.spectators";
        const auto spectators = loadSingleValue(pt, path);

        if (!stadium.empty() && !spectators.empty())
        retval.addContent(std::format("Gespeeld te {} voor {} toeschouwers. </br>", stadium, spectators));
        if (!arbiter.empty())
        retval.addContent(std::format("Scheidsrechter: {}. </br>", arbiter));

        path = base_path + ".stats.chronological";
        const auto games = loadPairs(pt, path, "min");
        for (const auto& [time, remark] : games)
        {
            const auto trimmed = readers::csvReader::trim(remark, " ");
            const auto splitted = readers::csvReader::split(trimmed, " ");
            if (splitted.column.size() == 2)
            {
                auto expanded = players.expand(splitted.column[1]);
                retval.addContent(time + " min " + splitted.column[0] + " " + expanded + "<br/>");
            }
            else
            {
                retval.addContent(time + " min" + remark + "<br/>");
            }
        }

        return retval;
    }

    PageBlock FormatEkWk::printExtras(const groupList& groups, const football::route2final& r2f, const std::string& filename_xml) const
    {
        auto subBlocks = std::vector<MultipleStrings>();

        boost::property_tree::ptree pt;
        read_xml(filename_xml, pt);

        for (const auto& g : groups.data)
        {
            auto links = g.matches.getLinks(teams);
            for (const auto& link : links)
            {
                subBlocks.push_back(getExtraForOneMatch(g, link, "", pt));
            }
        }

        auto m = r2f.getAllMatches();
        auto links = m.getLinks(teams);
        for (const auto& link : links)
        {
            subBlocks.push_back(getExtraForOneMatch(groupData(), link, link.ko_phase, pt));
        }

        if (subBlocks.empty()) return {};

        auto retval = PageBlock();
        retval.description = "details enkele wedstrijden";
        retval.linkName = "details";
        retval.data.addContent("<p/> <a name=\"details\"/> <h2> Details enkele wedstrijden </h2> <hr>");
        for (auto& subBlock : subBlocks)
        {
            retval.data.addContent(subBlock);
            retval.data.addContent("<hr>");
        }

        return retval;
    }

    PageBlock FormatEkWk::getTopscorers(const EkWkDate& ekwk) const
    {
        auto retval = PageBlock();
        auto tp = football::topscorers(top_scorers);
        tp.initFromFile(ekwk.shortNameWithYear());
        if (tp.getSizeList() > 0)
        {
            auto table = tp.prepareTable(teams, players, settings);
            table.title = "Topscorers " + ekwk.shortName();
            auto Table = html::table(settings);
            auto out = Table.buildTable(table);
            retval.data.addContent("<p/> <a name =\"topscorers\"/>");
            retval.data.addContent(out);
            retval.description = "topscorers";
            retval.linkName = retval.description;
        }
        return retval;
    }

}
