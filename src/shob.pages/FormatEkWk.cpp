
#include "FormatEkWk.h"
#include <format>
#include <filesystem>

namespace shob::pages
{
    namespace fs = std::filesystem;
    using namespace shob::general;

    MultipleStrings FormatEkWk::getPages(const int year) const
    {
        return {};
    }

    bool FormatEkWk::isValidYear(const int year) const
    {
        const std::string ekFile = std::format("{}{}{}{}", dataSportFolder, "/ekwk/ek", year, ".csv");
        const std::string wkFile = std::format("{}{}{}{}", dataSportFolder, "/ekwk/wk", year, ".csv");
        return fs::exists(ekFile) || fs::exists(wkFile);
    }

    std::string FormatEkWk::getOutputFilename(const std::string& folder, const int year) const
    {
        constexpr auto fmt_outfile = "../pages/sport_voetbal_{}_{}.html";

        switch (year % 4)
        {
        case 0:
            return std::format(fmt_outfile, "EK", year);
        case 2:
            return std::format(fmt_outfile, "WK", year);
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

}
