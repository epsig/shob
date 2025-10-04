
#include "funcs.h"

namespace shob::html
{
    std::string funcs::acronym(const std::string& shortName, const std::string& longName)
    {
        return "<acronym title=\"" + longName + "\">" + shortName + "</acronym>";
    }

    bool funcs::isAcronymOnly(const std::string& cell)
    {
        return cell.starts_with("<acronym") && cell.ends_with("</acronym>");
    }

}
