
#pragma once
#include <string>

namespace shob::general
{
    /// <summary>
    /// class to hold a season starting in first_year and continuing in the next year
    /// </summary>
    class Season
    {
    public:
        Season(const int first_year) : first_year(first_year){}

        /// <summary>
        /// returns e.g. 2020-2021
        /// </summary>
        std::string toString() const;

        /// <summary>
        /// returns e.g. 20-21
        /// </summary>
        std::string toStringShort() const;

        /// <summary>
        /// returns e.g. 2020_2021
        /// </summary>
        std::string toPartFilename() const;

        static Season findSeason(const std::string& text);

        int getFirstYear() const { return first_year; }

    private:
        std::string toString(const char separator) const;
        const int first_year;
    };
}
