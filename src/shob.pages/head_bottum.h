
#pragma once

#include "../shob.html/table.h"
#include "../shob.general/itdate.h"
#include <string>

namespace shob::pages
{
    enum class styleSheetType
    {
        inlineInHead, separateFile,
    };

    struct headBottumInput
    {
        headBottumInput(int d) : dd(general::itdate(d)) {}
        general::multipleStrings body;
        std::string title;
        styleSheetType css = styleSheetType::inlineInHead;
        general::itdate dd;
    };

    class headBottum
    {
    public:
        static general::multipleStrings getPage(headBottumInput& input);
    private:
        static general::multipleStrings getStyleSheet();
        static general::multipleStrings getLinkToStyleSheet();
        static general::multipleStrings getFooter(const general::itdate& dd);
    };
}

