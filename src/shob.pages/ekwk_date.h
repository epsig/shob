#pragma once

#include <string>

namespace shob::pages
{
    class ekwk_date
    {
    public:
        ekwk_date(const int year);
        std::string shortName() const;
        std::string shortNameUpper() const;
        std::string shortNameWithYear() const;
        const int year;
    private:
        bool isWk;
    };

}
