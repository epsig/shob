#pragma once
#include "ShobDate.h"

namespace shob::general
{
    class DateAsString : public ShobDate
    {
    public:
        DateAsString(std::string dd) : dd(std::move(dd)) {}
        std::string toString() const override { return dd; }
        std::string toShortString() const override { return dd; }
    private:
        const std::string dd;
    };
}
