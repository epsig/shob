
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
        const std::string ek_file = std::format("{}{}{}{}", data_sport_folder, "/ekwk/ek", year, ".csv");
        const std::string wk_file = std::format("{}{}{}{}", data_sport_folder, "/ekwk/wk", year, ".csv");
        return fs::exists(ek_file) || fs::exists(wk_file);
    }

    std::string FormatEkWk::getOutputFilename(const std::string& folder, const int year) const
    {
        constexpr auto fmt_out_file = "../pages/sport_voetbal_{}_{}.html";

        switch (year % 4)
        {
        case 0:
            return std::format(fmt_out_file, "EK", year);
        case 2:
            return std::format(fmt_out_file, "WK", year);
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
