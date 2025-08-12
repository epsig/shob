
#include "funcs.h"

namespace shob::html
{
    std::string funcs::acronym(const std::string& shortName, const std::string& longName)
    {
        return "<acronym title=\"" + longName + "\">" + shortName + "</acronym>";
    }
}
