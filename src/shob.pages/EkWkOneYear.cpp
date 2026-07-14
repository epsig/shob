
#include "EkWkOneYear.h"

#include <format>
#include <filesystem>

#include "../shob.general/MathSupport.h"
#include "../shob.football/topscorers.h"
#include "../shob.readers/xmlReader.h"

#include <boost/property_tree/xml_parser.hpp>

#include "PageBlock.h"

namespace shob::pages
{
    namespace fs = std::filesystem;
    using namespace shob::general;

    EkWkOneYear::EkWkOneYear(const EkWkDate ekwk, const html::settings settings, const teams::clubTeams& teams,
        const readers::csvAllSeasonsReader& top_scorers, const teams::footballers& players,
        const std::vector<std::vector<std::string>>& current_remarks, const std::string& data_sport_folder,
        football::route2final r2f, groupList groups, football::footballCompetition round2)
        : ekwk(ekwk), settings(settings), teams(teams), top_scorers(top_scorers), players(players), current_remarks(current_remarks),
        r2f(std::move(r2f)), groups(std::move(groups)), round2(std::move(round2))
    {
        int year = ekwk.year;
        filename_xml = data_sport_folder + "/ekwk/" + ekwk.shortNameUpper() + "_" + std::to_string(year) + ".xml";
    }

    std::vector<PageBlock> EkWkOneYear::getAllPageBlocks(int& dd) const
    {
        auto pageBlocks = std::vector<PageBlock>(6);
        pageBlocks[0] = getLast16(dd);
        pageBlocks[1] = getRound2(dd);
        pageBlocks[2] = getGroupResults(dd);
        pageBlocks[3] = getStats();
        pageBlocks[4] = getTopscorers();
        pageBlocks[5] = printExtras();
        return pageBlocks;
    }

    PageBlock EkWkOneYear::getRound2(int& dd) const
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

    PageBlock EkWkOneYear::getLast16(int& dd) const
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

    PageBlock EkWkOneYear::getGroupResults(int& dd) const
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

        MultipleStrings content;
        for (size_t i = 0; i < tables.size() / 4; i++)
        {
            auto left = Table.buildTable({ tables[4 * i] , tables[4 * i + 1] });
            auto right = Table.buildTable({ tables[4 * i + 2] , tables[4 * i + 3] });
            auto combined = html::table::tableOfTwoTables(left, right);
            content.addContent(combined);
        }
        if (tables.size() % 4 != 0)
        {
            auto last = Table.buildTable({ tables[tables.size() - 2], tables.back() });
            content.addContent(last);
        }

        ret_val.data.addContent(content);
        ret_val.linkName = "groepsfase";
        ret_val.description = "de groepswedstrijden";
        return ret_val;
    }

    PageBlock EkWkOneYear::getStats() const
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

        const auto results = all_matches.getStrikingResults();
        auto lines = table3_to_html(results);
        ret_val.data.addContent(lines);

        const auto mean = MathSupport::divide(total, matches);
        const auto spectators = std::format("<p/> Na {} wedstrijden: {:.2f} miljoen toeschouwers; gemiddeld = {:.0f} duizend.",
            matches, 1e-6 * static_cast<double>(total), 1e-3 * mean);
        ret_val.data.addContent(spectators);

        ret_val.linkName = "stats";
        ret_val.description = "statistieken";

        return ret_val;
    }

    void EkWkOneYear::getFieldsTable3(const std::vector<football::footballMatch>& matches, std::string& matchNames, std::string& results) const
    {   // copied from getFieldsTable3 in FormatStatsEredivisie
        // TODO avoid duplication
        for (size_t i = 0; i < matches.size(); i++)
        {
            if (i > 0)
            {
                matchNames += "<br>";
                results += "<br>";
            }
            matchNames += matches[i].matchName(teams);
            results += matches[i].result;
        }
    }

    MultipleStrings EkWkOneYear::table3_to_html(const football::strikingResults& data) const
    {   // based on table3_to_html in FormatStatsEredivisie
        html::tableContent content1;

        if (settings.lang == html::language::English)
        {
            content1.header.data = { "biggest victory", "most goals per team", "most goals per match" };
        }
        else
        {
            content1.header.data = { "ruimste zege", "meeste treffers (&eacute;&eacute;n van beide)", "hoogste totaal" };
        }

        content1.colWidths = { 2, 2, 2 };

        html::tableContent content;
        content.header.data = {};

        MultipleStrings body;
        body.data = std::vector<std::string>(6);
        getFieldsTable3(data.biggestVictory, body.data[0], body.data[1]);
        getFieldsTable3(data.mostGoalsPerTeam, body.data[2], body.data[3]);
        getFieldsTable3(data.mostGoalsPerMatch, body.data[4], body.data[5]);
        content.body.push_back(body);

        auto Table = html::table(settings);
        auto return_value = MultipleStrings();
        auto table = Table.buildTable({ content1, content });
        return_value.addContent(table);
        return return_value;
    }

    PageBlock EkWkOneYear::getTopscorers() const
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

    MultipleStrings EkWkOneYear::getExtraForOneMatch(const groupData& g, const football::linkInfo& link, const std::string& ko_phase,
        const boost::property_tree::ptree& pt) const
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
            base_path = "games.ko." + ko_phase + "." + link.link_name;
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

    PageBlock EkWkOneYear::printExtras() const
    {
        auto sub_blocks = std::vector<MultipleStrings>();
        if (!fs::exists(filename_xml)) return PageBlock();

        boost::property_tree::ptree pt;
        read_xml(filename_xml, pt);

        for (const auto& g : groups.data)
        {
            auto links = g.matches.getLinks(teams);
            for (const auto& link : links)
            {
                sub_blocks.push_back(getExtraForOneMatch(g, link, "", pt));
            }
        }

        const auto links2 = round2.getLinks(teams);
        for (const auto& link : links2)
        {
            sub_blocks.push_back(getExtraForOneMatch(groupData(), link, "last32", pt));
        }

        const auto m = r2f.getAllMatches();
        const auto links = m.getLinks(teams);
        for (const auto& link : links)
        {
            sub_blocks.push_back(getExtraForOneMatch(groupData(), link, link.ko_phase, pt));
        }

        if (sub_blocks.empty()) return {};

        auto retval = PageBlock();
        retval.description = "details enkele wedstrijden";
        retval.linkName = "details";
        retval.data.addContent("<p/> <a name=\"details\"/> <h2> Details enkele wedstrijden </h2> <hr>");
        for (auto& subBlock : sub_blocks)
        {
            retval.data.addContent(subBlock);
            retval.data.addContent("<hr>");
        }

        return retval;
    }

}
