
#pragma once
#include <string>

namespace shob::general
{
    class season
    {
    public:
        season(const int year) : year(year){}
        std::string to_string() const;
        std::string to_part_filename() const;
    private:
        std::string to_string(const char c) const;
        const int year;
    };
}
