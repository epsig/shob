
#pragma once

#include "../shob.html/table.h"
#include <string>

namespace shob::pages
{
    enum class styleSheetType
    {
        inlineInHead, separateFile,
    };

    struct headBottumInput
    {
        html::rowContent body;
        std::string title;
        styleSheetType css = styleSheetType::inlineInHead;
    };

    class headBottum
    {
    public:
        static html::rowContent getPage(headBottumInput& input);
    private:
        static html::rowContent getStyleSheet();
        static html::rowContent getLinkToStyleSheet();
    };
}

