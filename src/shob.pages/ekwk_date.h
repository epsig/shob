#pragma once

#include <string>

namespace shob::pages
{
    class ekwk_date
    {
    public:
        ekwk_date(const int year);
        std::string shortName() const;
        const int year;
    private:
        bool isWk;
    };

}
