#include "FormatHomePage.h"
#include "HeadBottom.h"
#include "../shob.bookmarks/CurrentEvents.h"
#include "../shob.bookmarks/OwnSportPages.h"
#include "../shob.html/updateIfNewer.h"

namespace shob::pages
{
    using namespace shob::bookmarks;
    using namespace shob::general;

    void FormatHomePage::RebuildHomePage(const int dd)
    {
        auto content = OwnSportLinks();

        auto hb = HeadBottomInput(dd);
        hb.title = "Welkom op epsig.nl!";
        hb.css = StyleSheetType::SeparateFile;
        std::swap(hb.body, content);

        auto page = HeadBottom::getPage(hb);
        html::updateIfDifferent::update("../pages_new/index.html", page);
    }

    MultipleStrings shob::pages::FormatHomePage::OwnSportLinks()
    {
        const auto os = OwnSportPages::getOlympicIceSkating();
        const auto ekwk = OwnSportPages::getEkWkSoccer();
        const auto ekwk_D = OwnSportPages::getEkWkSoccerWoman();
        const auto eredivisie = OwnSportPages::getDutchSoccer();
        const auto europacup = OwnSportPages::getEuropacupSoccer();
        auto os_links = os.printFirstAndLast();
        auto ekwk_links = ekwk.printFirstAndLast();
        auto ekwk_D_links = ekwk_D.printAll();
        auto eredivisie_links = eredivisie.printFirstAndLast();
        auto europacup_links = europacup.printFirstAndLast();

        auto content = MultipleStrings();
        content.addContent(os_links);
        content.addContent(ekwk_links);
        content.addContent(ekwk_D_links);
        content.addContent(eredivisie_links);
        content.addContent(europacup_links);

        return content;
    }
}
