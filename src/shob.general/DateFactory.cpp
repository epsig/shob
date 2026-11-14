#include "DateFactory.h"
#include "ItDate.h"
#include "DateAsString.h"

namespace shob::general
{
    std::shared_ptr<ShobDate> DateFactory::getDate(const std::string& dd)
    {
        if (isInt(dd))
        {
            auto date = std::make_shared<ItDate>(std::stoi(dd));
            return date;
        }
        else
        {
            auto date = std::make_shared<DateAsString>(dd);
            return date;
        }
    }

    bool DateFactory::allDigits(const std::string& date)
    {
        for (const char& c : date)
        {
            if (c < '0' || c > '9') return false;
        }
        return true;
    }

    bool DateFactory::isInt(const std::string& date)
    {
        for (size_t i = 0; i < date.size(); i++)
        {
            const auto& c = date[i];
            if (i == 0 && c == '-') continue;
            if (c < '0' || c > '9') return false;
        }
        return true;
    }

}

