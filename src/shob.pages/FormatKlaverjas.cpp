#include "FormatKlaverjas.h"
#include "HeadBottom.h"

#include "../shob.klaverjas/KlaverjasTable.h"
#include "../shob.html/updateIfNewer.h"

namespace shob::pages
{
    using namespace shob::general;
    using namespace shob::html;

    void FormatKlaverjas::rebuildKlaverjas(std::string_view type, std::string_view location)
    {
        const auto content = getKlaverjas(type, location);
        const auto filename = "../pages/kj_" + std::string(type) + "_" + std::string(location) + ".html";
        updateIfDifferent::update(filename, content);
    }

    general::MultipleStrings FormatKlaverjas::getKlaverjas(std::string_view type, std::string_view location)
    {
        const auto content = klaverjas::kjTable(type);
        auto ret = general::MultipleStrings();
        ret.addContent(content);

        auto hb = HeadBottomInput(-1);
        hb.title = "Klaverjassen";
        hb.css = StyleSheetType::InlineForKlaverjas;
        hb.copyTitleToH1 = false;
        hb.newStyleFooter = true;

        if (type == "gfx")
        {
            hb.js = JavaScriptType::KlaverjasGfx;
        }
        else if (type == "txt")
        {
            hb.js = JavaScriptType::KlaverjasTxt;
        }

        hb.body.addContent(ret);
        auto pageContent = HeadBottom::getPage(hb);
        return pageContent;
    }
}
