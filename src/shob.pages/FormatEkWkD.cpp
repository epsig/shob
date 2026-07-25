
#include "FormatEkWkD.h"
#include "HeadBottom.h"
#include "EkWkOneYear.h"
#include "EkWkOneYearFactory.h"
#include <format>
#include <filesystem>

namespace shob::pages
{
    namespace fs = std::filesystem;
    using namespace shob::general;

    bool FormatEkWkD::isValidYear(const int year) const
    {
        const std::string ek_file = std::format("{}{}{}{}", data_sport_folder, "/ekwk/ekD", year, ".csv");
        const std::string wk_file = std::format("{}{}{}{}", data_sport_folder, "/ekwk/wkD", year, ".csv");
        return fs::exists(ek_file) || fs::exists(wk_file);
    }

    std::string FormatEkWkD::getOutputFilename(const std::string& folder, const int year) const
    {
        constexpr auto fmt_out_file = "{}/sport_voetbal_{}D{}.html";

        switch (year)
        {
        case 2022: case 2025:
            return std::format(fmt_out_file, folder, "EK", year);
        case 2019: case 2023:
            return std::format(fmt_out_file, folder, "WK", year);
        default:
            return "";
        }
    }

    std::string FormatEkWkD::getOutputFilename(const std::string& folder) const
    {
        return "";
    }

    int FormatEkWkD::getLastYear() const
    {
        return 2025;
    }

    MultipleStrings FormatEkWkD::getPages(const int year) const
    {
        const auto ekwk = EkWkDate(year, 'D');
        auto retVal = MultipleStrings();
        retVal.addContent("<hr>");
        auto topMenu = top_menu.getMenu(std::to_string(year));
        retVal.addContent(topMenu);
        retVal.addContent("<hr>");

        int dd = 19920101;

        const auto current_remarks = remarks.getSeason(ekwk.shortNameWithYear());
        auto helper = EkWkOneYearFactory::Factory(ekwk, settings, teams, top_scorers, players, current_remarks, data_sport_folder);

        auto pageBlocks = helper.getAllPageBlocks(dd);

        retVal.addContent("<ul>");
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
        const auto shortName = ekwk.shortNameUpper().substr(0, 2);
        hb.title = shortName + " Voetbal vrouwen " + std::to_string(year) + " te " + organizing_country;
        hb.css = StyleSheetType::SeparateFile;
        std::swap(hb.body, retVal);

        return HeadBottom::getPage(hb);
    }

}
