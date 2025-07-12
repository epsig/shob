
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
        html::multipleStrings body;
        std::string title;
        styleSheetType css = styleSheetType::inlineInHead;
    };

    class headBottum
    {
    public:
        static html::multipleStrings getPage(headBottumInput& input);
    private:
        static html::multipleStrings getStyleSheet();
        static html::multipleStrings getLinkToStyleSheet();
    };
}

