
#pragma once

#include "shobDate.h"
#include <memory>

namespace shob::general
{
    class dateFactory
    {
    public:
        static std::shared_ptr<shobDate> getDate(const std::string& dd);
    private:
        static bool allDigits(const std::string& date);
    };
}
