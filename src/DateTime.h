#pragma once
#include <string>

namespace shob::general
{
    enum class DateTimeType {asDdInt, asString, asDdIntWithTime};

    class DateTime
    {
    public:
        DateTime(const int yyyymmdd);
        DateTime(const int yyyymmdd, const int hhmm);
        DateTime(const std::string& raw);
        std::string toString() const;
        static bool allDigits(const std::string& date);
    private:
        DateTimeType type;
        int yyyymmdd = -999; // date in the form 20250419
        int hhmm     = -999; // time in the form 2359
        std::string raw;     // for situations time is not known exactly
    };
}
