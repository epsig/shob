
#include "FormatEkWk.h"
#include "EkWkDate.h"
#include "HeadBottom.h"
#include "../shob.football/route2finalFactory.h"

#include <format>
#include <filesystem>

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
        readers::csvContent csv_content;
        if (fs::exists(filename))
        {
            csv_content = readers::csvReader::readCsvFile(filename);
            auto pb = getLast16(csv_content, dd);
            retVal.addContent(pb.data);
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
                retval.description = "last16";
                dd = std::max(dd, r2f.lastDate().toInt());
            }
        }
        return retval;
    }


}
