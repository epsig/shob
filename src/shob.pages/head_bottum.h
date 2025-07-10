
#pragma once

#include "../shob.html/table.h"
#include <string>

namespace shob::pages
{
    struct headBottumInput
    {
        html::rowContent body;
        std::string title;
    };

    class headBottum
    {
    public:
        static html::rowContent getPage(headBottumInput& input);
    };
}

