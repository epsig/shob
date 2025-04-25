#pragma once
#include "shobDate.h"

namespace shob::general
{
    class dateAsString : public shobDate
    {
    public:
        dateAsString(const std::string& dd) : dd(dd) {}
        std::string toString()  const override { return dd; }
    private:
        const std::string dd;
    };
}
