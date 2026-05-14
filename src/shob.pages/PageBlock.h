
#pragma once

#include "../shob.general/MultipleStrings.h"

namespace shob::pages
{
    struct PageBlock
    {
        general::MultipleStrings data;
        std::string linkName;
        std::string description;
    };
}
