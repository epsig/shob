
#include "dateFactory.h"
#include "itdate.h"
#include "dateAsString.h"

namespace shob::general
{
    std::shared_ptr<shobDate> dateFactory::getDate(const std::string& dd)
    {
        if (allDigits(dd))
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

}

