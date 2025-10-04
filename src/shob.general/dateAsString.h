#pragma once
#include "shobDate.h"

namespace shob::general
{
    class dateAsString : public shobDate
    {
    public:
        dateAsString(std::string dd) : dd(std::move(dd)) {}
        std::string toString(bool isCompatible) const override { return dd; }
        std::string toShortString() const override { return dd; }
    private:
        const std::string dd;
    };
}
