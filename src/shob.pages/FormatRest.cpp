#include "FormatRest.h"
#include "HeadBottom.h"
#include "../shob.html/updateIfNewer.h"
#include "../shob.general/FileIO.h"
#include <map>

namespace shob::pages
{
    void FormatRest::rebuildTechDoc(const TechDocType type, const int dd) const
    {
        const auto type_str = std::map<TechDocType, std::string>{
            { TechDocType::Klaverjas, "tech_doc_kj.html" },
            { TechDocType::Shob, "tech_doc_shob.html" },
            { TechDocType::Adressen, "tech_doc_adressen.html" }
        } [type] ;

        const auto page = getTechDoc(type_str, type, dd);
        html::updateIfDifferent::update("../pages/" + type_str, page);
    }

    general::MultipleStrings FormatRest::getTechDoc(const std::string& type_str, const TechDocType type, const int dd) const
    {
        const auto title = std::map<TechDocType, std::string>{
            { TechDocType::Klaverjas, "Klaverjassen" },
            { TechDocType::Shob, "Shob" },
            { TechDocType::Adressen, "Adressen" }
        } [type] ;

        auto content = general::FileIO::readFile("doc/" + type_str);

        auto hb = HeadBottomInput(dd);
        hb.title = "Technische documentatie " + title;
        hb.css = StyleSheetType::SeparateFile;
        std::swap(hb.body, content);

        auto page = HeadBottom::getPage(hb);
        return page;
    }
}
