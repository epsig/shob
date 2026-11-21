#include "GetDefaultFirstLastYear.h"

#include "../shob.general/CurrentDateTime.h"
#include "../shob.readers/CsvReader.h"

#include <filesystem>

namespace shob::main
{
    namespace fs = std::filesystem;

    namespace
    {
        bool containsSeason(const std::string& filename, const std::string& season)
        {
            const auto csv = shob::readers::CsvReader::readCsvFile(filename);
            for (const auto& row : csv.body)
            {
                if (row.column.empty()) continue;
                if (row.column[0] == season) return true;
            }
            return false;
        }
    }

    void GetDefaultFirstLastYear::get(int& first_year, int& last_year)
    {
        first_year = 1993;

        const auto current_year = shob::general::CurrentDateTime::getCurrentYear();
        last_year = current_year;

        const auto next_year = current_year + (current_year % 2 == 0 ? 2 : 1);
        const auto season_prefix = next_year % 4 == 0 ? "ek" : "wk";
        const auto next_season = std::string(season_prefix) + std::to_string(next_year);

        constexpr auto remarks_file_1 = "sport/ekwk_qf/ekwk_qf_remarks.csv";
        constexpr auto remarks_file_2 = "data/sport/ekwk_qf/ekwk_qf_remarks.csv";
        if ((fs::exists(remarks_file_1) && containsSeason(remarks_file_1, next_season)) ||
            (fs::exists(remarks_file_2) && containsSeason(remarks_file_2, next_season)))
        {
            last_year = next_year;
        }
    }
}

