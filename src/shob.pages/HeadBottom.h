
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
        general::MultipleStrings body;
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
        static general::MultipleStrings getPage(HeadBottomInput& input);
    private:
        static general::MultipleStrings getStyleSheet();
        static general::MultipleStrings getLinkToStyleSheet();
        static general::MultipleStrings getFooter(const general::itdate& dd);
    };
}

