#include "FormatKlaverjas.h"
#include "HeadBottom.h"

#include "../shob.klaverjas/KlaverjasTable.h"
#include "../shob.html/updateIfNewer.h"
#include "../shob.general/FileIO.h"
#include "../shob.readers/csvReader.h"

namespace shob::pages
{
    using namespace shob::general;
    using namespace shob::html;

    void FormatKlaverjas::rebuildKlaverjas(std::string_view type, std::string_view location)
    {
        const auto content = type == "klein" ? getKlaverjasKleinScherm(location) : getKlaverjas(type, location);
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
        hb.footerStyle = FooterStyle::Klaverjas;

        if (type == "gfx")
        {
            hb.js = JavaScriptType::KlaverjasGfx;
            hb.footerSubStyle = location == "rdam" ? FooterSubStyle::KlaverjasRdamGfx : FooterSubStyle::KlaverjasAdamGfx;
        }
        else if (type == "txt")
        {
            hb.js = JavaScriptType::KlaverjasTxt;
            hb.footerSubStyle = location == "rdam" ? FooterSubStyle::KlaverjasRdamTxt : FooterSubStyle::KlaverjasAdamTxt;
        }

        hb.body.addContent(ret);
        auto pageContent = HeadBottom::getPage(hb);
        return pageContent;
    }

    general::MultipleStrings FormatKlaverjas::getKlaverjasKleinScherm(std::string_view location)
    {
        auto content = FileIO::readFile("../code/Klaverjas/palmtop_scherm.html");
        for (auto& line : content.data)
        {
            const auto pos = line.find("InfoHelp");
            if (pos != std::string::npos)
            {
                line.replace(pos, 8, "nL");
            }
            line = readers::csvReader::trim(line, " ");
        }

        auto hb = HeadBottomInput(-1);
        hb.title = "Klaverjassen";
        hb.css = StyleSheetType::InlineForKlaverjasKlein;
        hb.copyTitleToH1 = false;
        hb.footerStyle = FooterStyle::Klaverjas;

        hb.js = JavaScriptType::KlaverjasTxt;
        hb.footerSubStyle = location == "rdam" ? FooterSubStyle::KlaverjasRdamKlein : FooterSubStyle::KlaverjasAdamKlein;

        hb.body.addContent(content);
        auto pageContent = HeadBottom::getPage(hb);
        return pageContent;
    }
}
