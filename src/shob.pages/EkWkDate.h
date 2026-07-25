#pragma once

#include <string>

namespace shob::pages
{
    class EkWkDate
    {
    public:
        EkWkDate(const int year, const char DH = 'H');
        std::string shortName() const;
        std::string shortNameUpper() const;
        std::string shortNameWithYear() const;
        const int year;
        bool isWk() const;
    private:
        const char DH;
    };

}
