
#include "filterInput.h"

namespace shob::football
{
    bool filterInputList::isFinale() const
    {
        for (const auto& filter : filters)
        {
            if (filter.name == "f")
            {
                return true;
            }
        }
        return false;
    }

    bool filterInputList::checkLine(const readers::csvColContent& col) const
    {
        for (const auto& filter : filters)
        {
            if (col.column[filter.rowIndex] != filter.name) return false;
        }
        return true;
    }
}
