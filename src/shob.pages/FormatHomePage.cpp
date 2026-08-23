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
        auto currentEvents = CurrentEventsLinks(dd);
        auto blockTopLeft = BlockTopLeft();
        auto blockBottomRight = BlockBottomRight();

        auto top = html::table::yellowRed(blockTopLeft, currentEvents, "Deze site", "Actueel");
        auto bottom = html::table::yellowRed(content, blockBottomRight, "Sport en spel", "Links");

        auto hb = HeadBottomInput(dd);
        hb.title = "Welkom op epsig.nl!";
        hb.css = StyleSheetType::SeparateFile;
        hb.copyTitleToH1 = false;
        hb.withFooter = false;
        std::swap(hb.body, top);
        hb.body.addContent(bottom);

        auto page = HeadBottom::getPage(hb);
        html::updateIfDifferent::update("../pages/index.html", page);
    }

    MultipleStrings FormatHomePage::OwnSportLinks()
    {
        const auto os = OwnSportPages::getOlympicIceSkating();
        const auto ekwk = OwnSportPages::getEkWkSoccer();
        const auto ekwk_D = OwnSportPages::getEkWkSoccerWoman();
        const auto eredivisie = OwnSportPages::getDutchSoccer();
        const auto europacup = OwnSportPages::getEuropacupSoccer();

        auto os_links = os.printFirstAndLast();
        auto ekwk_links = ekwk.printFirstAndLast();
        auto ekwk_D_links = ekwk_D.printFirstAndLast();
        auto eredivisie_links = eredivisie.printFirstAndLast();
        auto europacup_links = europacup.printFirstAndLast();

        auto content = MultipleStrings();
        content.addContent("<ul> <li> Een <a href=\"klaverjas_faq.html\">klaverjasspel</a>. </li>");
        content.addContent("<li> Een <a href=\"sport.html\">sport-archief</a> met onder andere: </li>");
        content.addContent("<ul> <li> Schaatsen op de Olympische Spelen van: ");
        content.addContent(os_links);
        content.addContent(". </li> <li> EK en WK voetbal: <br> mannen van: ");
        content.addContent(ekwk_links);
        content.addContent(". <br> vrouwen van: ");
        content.addContent(ekwk_D_links);
        content.addContent(". </li> <li> Nederlandse clubs in het Europacup voetbal van: ");
        content.addContent(europacup_links);
        content.addContent(". </li> <li> Betaald voetbal in Nederland van: ");
        content.addContent(eredivisie_links);
        content.addContent(". </li> </ul> </ul>");

        return content;
    }

    MultipleStrings FormatHomePage::CurrentEventsLinks(const int dd)
    {
        auto currentEvents = CurrentEvents::getCurrentBookmarks("bookmarks", dd);

        auto events = currentEvents.printAll();
        auto return_value = MultipleStrings();
        return_value.addContent("<ul>");
        if (events.length() == 0)
        {
            return_value.addContent("<li>geen grote evenementen deze maand.</li>");
        }
        else
        {
            for (const auto& line : events.data)
            {
                return_value.addContent("<li>");
                return_value.addContent(line);
                return_value.addContent("</li>");
            }
        }
        return_value.addContent("</ul>");

        return return_value;
    }

    MultipleStrings FormatHomePage::BlockTopLeft()
    {
        auto return_value = MultipleStrings();
        return_value.addContent("<ul><li> <a href=\"reactie.html\">reageer</a> </li>");
        return_value.addContent("<li> hoe zo, <a href=\"epsig.html\">epsig?</a> </li>");
        return_value.addContent("<li> en, veel <a href=\"stats.html\">hits?</a> </li>");
        return_value.addContent("<li>");
        return_value.addContent("<form action=\"https://www.google.com/search\" class=\"searchform\" method=\"get\" name=\"searchform\" target=\"_blank\">");
        return_value.addContent("<input name=\"sitesearch\" type=\"hidden\" value=\"epsig.nl\">");
        return_value.addContent("<input autocomplete=\"on\" class=\"form-control search\" name=\"q\" placeholder=\"Search in epsig.nl\" required=\"required\" type=\"text\">");
        return_value.addContent("<button class=\"button\" type=\"submit\">Search</button>");
        return_value.addContent("</form>");
        return_value.addContent("</li>");
        return_value.addContent("</ul>");
        return return_value;
    }

    MultipleStrings FormatHomePage::BlockBottomRight()
    {
        auto return_value = MultipleStrings();
        return_value.addContent("<ul> <li> <a href=\"bookmarks_sport.html\">Sport</a> </li>");
        return_value.addContent("<li> <a href=\"bookmarks_treinen.html\">Treinen</a> </li>");
        return_value.addContent("<li> <a href=\"bookmarks_computers.html\">Computers</a> </li>");
        return_value.addContent("</ul>");
        return return_value;
    }

}
