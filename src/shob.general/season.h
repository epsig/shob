
#pragma once
#include <string>

namespace shob::general
{
    /// <summary>
    /// class to hold a season starting in firstYear and continuing in the next year
    /// </summary>
    class season
    {
    public:
        season(const int firstYear) : firstYear(firstYear){}

        /// <summary>
        /// returns e.g. 2020-2021
        /// </summary>
        std::string to_string() const;

        /// <summary>
        /// returns e.g. 20-21
        /// </summary>
        std::string to_string_short() const;

        /// <summary>
        /// returns e.g. 2020_2021
        /// </summary>
        std::string to_part_filename() const;

        static season findSeason(const std::string& text);

    private:
        std::string to_string(const char separator) const;
        const int firstYear;
    };
}
