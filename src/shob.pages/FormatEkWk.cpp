
#include "FormatEkWk.h"
#include "EkWkDate.h"
#include "HeadBottom.h"
#include "../shob.football/route2finalFactory.h"
#include "PageBlock.h"
#include "../shob.football/route2final.h"

#include "EkWkOneYear.h"

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

        const std::string filename_xml = data_sport_folder + "/ekwk/" + ekwk.shortNameUpper() + "_" + std::to_string(year) + ".xml";

        auto helper = EkWkOneYear(settings, teams, top_scorers, players);
        const auto current_remarks = remarks.getSeason(ekwk.shortNameWithYear());

        const auto groups = helper.getGroupData(csv_content, current_remarks);
        const auto r2f = football::route2finaleFactory::create(csv_content);

        const auto round2 = helper.getRound2data(csv_content);

        auto pageBlocks = std::array<PageBlock, 6>();
        pageBlocks[0] = helper.getLast16(r2f, dd);
        pageBlocks[1] = helper.getRound2(round2, dd);
        pageBlocks[2] = helper.getGroupResults(groups, dd);
        pageBlocks[3] = helper.getStats(r2f, groups, round2);
        pageBlocks[4] = helper.getTopscorers(ekwk);
        if (fs::exists(filename_xml))
        {
            pageBlocks[5] = helper.printExtras(groups, round2, r2f, filename_xml);
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
        std::string organizing_country;
        for (const auto& row: current_remarks)
        {
            if (row[0] == "organising_country") organizing_country = row[1];
        }
        hb.title = ekwk.shortNameUpper() + " Voetbal " + std::to_string(year) + " te " + organizing_country;
        hb.css = StyleSheetType::SeparateFile;
        std::swap(hb.body, retVal);

        return HeadBottom::getPage(hb);
    }

}
