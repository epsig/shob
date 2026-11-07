#include "Funcs.h"

namespace shob::html
{
    std::string Funcs::acronym(const std::string& shortName, const std::string& longName)
    {
        return "<acronym title=\"" + longName + "\">" + shortName + "</acronym>";
    }

    bool Funcs::isAcronymOnly(const std::string& cell)
    {
        return cell.starts_with("<acronym") && cell.ends_with("</acronym>");
    }

}
