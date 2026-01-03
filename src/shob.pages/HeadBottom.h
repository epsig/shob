
#pragma once

#include "../shob.html/table.h"
#include "../shob.general/itdate.h"
#include <string>

namespace shob::pages
{
    enum class StyleSheetType
    {
        InlineInHead,
        SeparateFile,
    };

    /// <summary>
    /// Input struct for class HeadBottom
    /// </summary>
    struct HeadBottomInput
    {
        HeadBottomInput(int d) : dd(general::itdate(d)) {}
        general::multipleStrings body;
        std::string title;
        StyleSheetType css = StyleSheetType::InlineInHead;
        general::itdate dd;
    };

    /// <summary>
    /// Class for adding the head and bottom to the main part of the web page
    /// </summary>
    class HeadBottom
    {
    public:
        static general::multipleStrings getPage(HeadBottomInput& input);
    private:
        static general::multipleStrings getStyleSheet();
        static general::multipleStrings getLinkToStyleSheet();
        static general::multipleStrings getFooter(const general::itdate& dd);
    };
}

