#include "CurrentDateTime.h"
#include <chrono>

namespace shob::general
{
    using namespace std::chrono;

    int CurrentDateTime::getCurrentYear()
    {
        auto now = system_clock::now();           // 1. get time_point for now
        auto today = time_point_cast<days>(now);  // 2. cast to time_point for today
        auto ymd = year_month_day(today);         // 3. convert to year_month_day 
        auto year = ymd.year();                   // 4. get year from year_month_day
        return static_cast<int>(year);            // 5. an explicit cast is required 
    }
}
