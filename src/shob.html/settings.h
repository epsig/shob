
#pragma once
#include "language.h"

namespace shob::html
{
    class settings
    {
    public:
        language lang = language::Dutch;
        bool dateFormatShort = true;
        bool addCountry = false;
    };
}
