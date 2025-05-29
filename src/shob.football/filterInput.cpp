
#include "filterInput.h"

namespace shob::football
{
    bool filterInputList::isFinale() const
    {
        for (const auto& dat : data)
        {
            if (dat.name == "f")
            {
                return true;
            }
        }
        return false;
    }

    bool filterInputList::checkLine(const readers::csvColContent& col) const
    {
        for (const auto& dat : data)
        {
            if (col.column[dat.rowIndex] != dat.name) return false;
        }
        return true;
    }
}
