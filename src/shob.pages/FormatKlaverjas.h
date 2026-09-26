#pragma once
#include "../shob.general/MultipleStrings.h"
#include <string_view>

namespace shob::pages
{
    class FormatKlaverjas
    {
    public:
        FormatKlaverjas() = default;
        void rebuildKlaverjas(std::string_view type, std::string_view location);
        general::MultipleStrings getKlaverjas(std::string_view type, std::string_view location);
    };
}
