#pragma once
#include <string>

namespace shob::general
{
    class shobDate
    {
    public:
        virtual std::string toString() const { return ""; }
        virtual std::string toShortString() const { return ""; }
    };
}
