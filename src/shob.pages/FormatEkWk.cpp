
#include "FormatEkWk.h"
#include "EkWkDate.h"
#include "HeadBottom.h"
#include "../shob.football/route2finalFactory.h"
#include "../shob.football/filterResults.h"
#include "../shob.football/results2standings.h"
#include "../shob.football/topscorers.h"

#include <format>
#include <filesystem>
#include <array>

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

        auto pageBlocks = std::array<PageBlock, 3>();
        pageBlocks[0] = getLast16(csv_content, dd);
        pageBlocks[1] = getGroupResults(csv_content, dd);
        pageBlocks[2] = getTopscorers(ekwk);

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

    PageBlock FormatEkWk::getLast16(const readers::csvContent& csv_content, int& dd) const
    {
        PageBlock retval;
        auto Table = html::table(settings);
        Table.withBorder = false;
        if (!csv_content.body.empty())
        {
            const auto r2f = football::route2finaleFactory::create(csv_content);
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

    PageBlock FormatEkWk::getGroupResults(const readers::csvContent& data, int& dd) const
    {
        const auto groups = getGroups(data).list();
        auto tables = std::vector<html::tableContent>();


        for (const auto& group : groups)
        {
            auto filter = football::filterInputList();
            filter.filters.push_back({ 0, group });
            const auto groupsPhase = football::filterResults::readFromCsvData(data, filter);
            auto stand = football::results2standings::u2s(groupsPhase);
            auto prepTable = stand.prepareTable(teams, settings);
            prepTable.title = std::format("Groep {}", group.back());
            const auto prepTable2 = groupsPhase.prepareTable(teams, settings);
            tables.push_back(prepTable);
            tables.push_back(prepTable2);
            dd = std::max(dd, groupsPhase.lastDate().toInt());
        }

        auto Table = html::table(settings);
        auto ret_val = PageBlock();
        if (!groups.empty())
        {
            ret_val.data.addContent("<p/> <a name=\"groepsfase\"/>");
        }
        auto content = Table.buildTable(tables);
        ret_val.data.addContent(content);
        ret_val.linkName = "groepsfase";
        ret_val.description = "de groepswedstrijden";
        return ret_val;
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
