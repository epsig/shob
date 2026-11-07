#pragma once
#include "Language.h"

namespace shob::html
{
    enum class AddCountryType
    {
        notAtAll,
        withAcronym,
        fullCountryName
    };

    class Settings
    {
    public:
        Language lang = Language::Dutch;
        bool dateFormatShort = true;
        AddCountryType addCountry = AddCountryType::notAtAll;
    };
}
