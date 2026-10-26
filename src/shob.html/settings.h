
#pragma once
#include "language.h"

namespace shob::html
{
    enum class addCountryType
    {
        notAtAll,
        withAcronym,
        fullCountryName
    };

    class settings
    {
    public:
        language lang = language::Dutch;
        bool dateFormatShort = true;
        addCountryType addCountry = addCountryType::notAtAll;
    };
}
