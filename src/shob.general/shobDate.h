
#pragma once
#include <string>
#include <vector>

namespace shob::general
{
    static const std::vector<std::string> monthsDutch =
    { "jan", "feb", "mar", "apr", "mei", "jun", "jul", "aug", "sep", "okt", "nov", "dec" };

    class shobDate
    {
    public:
        virtual std::string toString() const { return ""; }
        virtual std::string toShortString() const { return ""; }
    };
}
