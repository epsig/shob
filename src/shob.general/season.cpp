
#include "season.h"

namespace shob::general
{
    std::string season::to_string() const
    {
        return to_string('-');
    }

    std::string season::to_part_filename() const
    {
        return to_string('_');
    }

    std::string season::to_string(const char c) const
    {
        const int yp1 = year + 1;
        return std::to_string(year) + c + std::to_string(yp1);
    }

}
