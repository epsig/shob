
#include "DateTime.h"

namespace shob::general
{
    DateTime::DateTime(const int yyyymmdd)
        : type(DateTimeType::asDdInt), yyyymmdd(yyyymmdd) {}

    DateTime::DateTime(const int yyyymmdd, const int hhmm)
        : type(DateTimeType::asDdIntWithTime), yyyymmdd(yyyymmdd), hhmm(hhmm) {}

    DateTime::DateTime(const std::string& raw)
        : type(DateTimeType::asString), raw(raw) {}

    std::string DateTime::toString() const
    {
        // TODO add validation
        switch (type)
        {
        case DateTimeType::asDdInt:
            return std::to_string(yyyymmdd); // TODO print as "12 mar 2018"
        case DateTimeType::asDdIntWithTime:
            return std::to_string(yyyymmdd) + " " + std::to_string(hhmm);
        case DateTimeType::asString:
            return raw;
        default:  // NOLINT(clang-diagnostic-covered-switch-default)
            return "?";
        }
    }

    bool DateTime::allDigits(const std::string& date)
    {
        for (const char& c : date)
        {
            if (c < '0' || c > '9') return false;
        }
        return true;
    }

}
