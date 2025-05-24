
#include "itdate.h"

#include <vector>

namespace shob::general
{
    std::string itdate ::toString() const
    {
        return std::to_string(dd);
    };

    std::string itdate::toShortString() const
    {
        size_t year = dd / 10000;
        size_t day = dd % 100;
        size_t mon = (dd - day - 10000 * year) / 100;
        return std::to_string(day) + " " + months[mon-1];
    };
}
