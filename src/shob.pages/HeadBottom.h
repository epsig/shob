
#pragma once

#include "../shob.html/table.h"
#include "../shob.general/itdate.h"
#include "../shob.bookmarks/ListOfEvents.h"
#include <string>

namespace shob::pages
{
    enum class StyleSheetType
    {
        InlineInHead,
        SeparateFile,
        InlineForKlaverjas,
    };

    enum class JavaScriptType
    {
        None,
        SortTable,
        KlaverjasGfx,
        KlaverjasTxt
    };

    enum class FooterStyle
    {
        Old,
        New,
        Klaverjas
    };

    enum class FooterSubStyle
    {
        KlaverjasAdamGfx,
        KlaverjasAdamTxt,
        KlaverjasRdamGfx,
        KlaverjasRdamTxt,
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
        JavaScriptType js = JavaScriptType::None;
        general::itdate dd;
        bool copyTitleToH1 = true;
        bool withFooter = true;
        FooterStyle footerStyle = FooterStyle::Old;
        FooterSubStyle footerSubStyle = FooterSubStyle::KlaverjasAdamGfx;
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
        static general::MultipleStrings getStyleSheetKlaverjas();
        static general::MultipleStrings getLinkToStyleSheet();
        static general::MultipleStrings getFooter(const general::itdate& dd, FooterStyle footerStyle, FooterSubStyle footerSubStyle);
        static general::MultipleStrings getJsSortTable();
        static bookmarks::ListOfEvents getFooterLinks(const general::itdate& dd);
    };
}

