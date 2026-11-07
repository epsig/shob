
#pragma once

#include "ShobDate.h"
#include <memory>

namespace shob::general
{
    class DateFactory
    {
    public:
        static std::shared_ptr<ShobDate> getDate(const std::string& dd);
        static bool allDigits(const std::string& date);
        static bool isInt(const std::string& date);
    };
}
