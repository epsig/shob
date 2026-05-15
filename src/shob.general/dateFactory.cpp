
#include "dateFactory.h"
#include "itdate.h"
#include "dateAsString.h"

namespace shob::general
{
    std::shared_ptr<shobDate> dateFactory::getDate(const std::string& dd)
    {
        if (isInt(dd))
        {
            auto date = std::make_shared<itdate>(std::stoi(dd));
            return date;
        }
        else
        {
            auto date = std::make_shared<dateAsString>(dd);
            return date;
        }
    }

    bool dateFactory::allDigits(const std::string& date)
    {
        for (const char& c : date)
        {
            if (c < '0' || c > '9') return false;
        }
        return true;
    }

    bool dateFactory::isInt(const std::string& date)
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

