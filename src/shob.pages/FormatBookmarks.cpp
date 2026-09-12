#include "FormatBookmarks.h"
#include "HeadBottom.h"
#include "../shob.bookmarks/ConfigurableBookmarks.h"
#include "../shob.bookmarks/CurrentEvents.h"
#include "../shob.bookmarks/OwnSportPages.h"
#include "../shob.html/updateIfNewer.h"
#include "../shob.html/List.h"
#include "../shob.general/shobException.h"

namespace shob::pages
{
    using namespace shob::bookmarks;
    using namespace shob::general;
    using namespace shob::html;

    FormatBookmarks::FormatBookmarks(const std::string& folder, const int dd) : bookmarks(folder), dd(dd)
    {
    }

    void FormatBookmarks::rebuildBookmarks(const std::string& page, const bool is_tmp) const
    {
        auto props = PageProperties();
        if (!bookmarks.getProperties(props, page))
        {
            throw shobException("Error: page " + page + " not found in config.csv");
        }
        auto content = bookmarks.getAllParts(page);

        auto blocks = std::vector<MultipleStrings>();

        for (int i = 0; i < content.size(); i+= 2)
        {
            MultipleStrings left, row;
            if (content[i].title == "reserved")
            {
                left = currentEventsLinks();
                content[i].title = "Actueel";
            }
            else
            {
                left = List::inUnorderedList(bookmarks.getEventsForBlock(content[i].name).printAll());
            }
            if (i + 1 >= static_cast<int>(content.size()))
            {
                row = table::yellowRed(left, content[i].title);
            }
            else
            {
                auto right = List::inUnorderedList(bookmarks.getEventsForBlock(content[i + 1].name).printAll());
                row = table::yellowRed(left, right, content[i].title, content[i + 1].title);
            }
            blocks.push_back(row);
        }

        int dd_page = props.dd;
        if (dd_page == 0)
        {
            dd_page = dd;
        }
        auto hb = HeadBottomInput(dd_page);
        hb.title = props.title;
        hb.css = StyleSheetType::SeparateFile;
        hb.copyTitleToH1 = false;
        if (!blocks.empty())
        {
            std::swap(hb.body, blocks[0]);
            for (size_t i = 1; i < blocks.size(); i++)
            {
                hb.body.addContent(blocks[i]);
            }
        }
        auto pageContent = HeadBottom::getPage(hb);

        if (is_tmp)
        {
            updateIfDifferent::update("../pages/tmp_bookmarks_" + page + ".html", pageContent);
        }
        else
        {
            updateIfDifferent::update("../pages/bookmarks_" + page + ".html", pageContent);
        }
    }

    MultipleStrings FormatBookmarks::currentEventsLinks() const
    {
        auto currentEvents = CurrentEvents::getCurrentBookmarks("bookmarks", dd);

        auto events = currentEvents.printAll();
        if (events.length() == 0)
        {
            events.addContent(CurrentEvents::getMessageEmpty());
        }

        return List::inUnorderedList(events);
    }

    void FormatBookmarks::AddPunctuation(MultipleStrings& extra)
    {
        if (extra.data.empty()) return;

        for (int i = static_cast<int>(extra.data.size()) - 1; i >= 2; i--)
        {
            extra.data[i] += ",";
        }
        if (extra.data.size() > 1)
        {
            extra.data[1] += " en ";
        }
        extra.data[0] += ".";
    }

    void FormatBookmarks::rebuildOwnSportLinks()
    {
        const auto os = OwnSportPages::getOlympicIceSkating();
        const auto ekwk = OwnSportPages::getEkWkSoccer();
        const auto ekwk_D = OwnSportPages::getEkWkSoccerWoman();
        const auto eredivisie = OwnSportPages::getDutchSoccer(true);
        const auto europacup = OwnSportPages::getEuropacupSoccer(true);

        auto os_links = os.printAll();
        auto ekwk_links = ekwk.printAll();
        auto ekwk_D_links = ekwk_D.printAll();
        auto eredivisie_links = eredivisie.printAll();
        auto europacup_links = europacup.printAll();

        AddPunctuation(os_links);
        AddPunctuation(ekwk_links);
        AddPunctuation(ekwk_D_links);
        AddPunctuation(eredivisie_links);
        AddPunctuation(europacup_links);

        MultipleStrings content;
        content.addContent("<ul> <li> Wedstrijden Nederlands mannenelftal: <br> ");
        content.addContentReversed(ekwk_links);
        content.addContent("</li> <li> Wedstrijden Nederlands vrouwenelftal: <br> ");
        content.addContentReversed(ekwk_D_links);
        content.addContent("</li> <li> Eindstand eredivisie, KNVB-beker en nacompetitie; <br> seizoenen:");
        content.addContentReversed(eredivisie_links);
        content.addContent("</li> <li> Nederlandse clubteams in de Europacup voetbal; <br> seizoenen:");
        content.addContentReversed(europacup_links);
        content.addContent("</li> <li> <a href=\"sport_voetbal_nl_stats.html\">Statistieken Eredivisie vanaf 1993</a>");
        content.addContent("en <a href=\"sport_voetbal_nl_stats_more.html\">nog meer stats</a>.");
        content.addContent("</li> <li> <a href=\"sport_voetbal_nl_jaarstanden.html\">Winterkampioen en jaarstanden vanaf 1993</a> |");
        content.addContent("<a href=\"sport_voetbal_nl_uit_thuis.html\">uit- en thuis standen vanaf 1993</a>.");
        content.addContent("</li> <li> Uitslagen schaatsen OS:");
        content.addContentReversed(os_links);
        content.addContent("</li> <li>Zie verder: <a href=\"bookmarks_sport.html\">sport links</a> </li> </ul>");

        auto hb = HeadBottomInput(last_dd);
        hb.title = "Sportpagina's op www.epsig.nl";
        hb.css = StyleSheetType::SeparateFile;
        hb.copyTitleToH1 = false;
        hb.body = table::yellowRed(content, hb.title);
        auto pageContent = HeadBottom::getPage(hb);

        updateIfDifferent::update("../pages/sport.html", pageContent);
    }

    void FormatBookmarks::rebuildOverzicht()
    {
        const auto os = OwnSportPages::getOlympicIceSkating();
        const auto ekwk = OwnSportPages::getEkWkSoccer();
        const auto ekwk_D = OwnSportPages::getEkWkSoccerWoman();
        const auto eredivisie = OwnSportPages::getDutchSoccer(true);
        const auto europacup = OwnSportPages::getEuropacupSoccer(true);

        auto os_links = os.printAll();
        auto ekwk_links = ekwk.printAll();
        auto ekwk_D_links = ekwk_D.printAll();
        auto eredivisie_links = eredivisie.printAll();
        auto europacup_links = europacup.printAll();

        AddPunctuation(os_links);
        AddPunctuation(ekwk_links);
        AddPunctuation(ekwk_D_links);
        AddPunctuation(eredivisie_links);
        AddPunctuation(europacup_links);

        MultipleStrings content;
        content.addContent("<ol> <li>Algemeen: <a href=\"../pages//index.html\">Home page</a> </li>");
        content.addContent("<ol> <li><a href=\"klaverjas_faq.html\">een JavaScript-spel: klaverjassen</a></li>");
        content.addContent("<li><a href=\"anybrowser.html\">speciale characters in html</a> en <a href=\"tmp_ascii_codes.html\">ascii codes</a></li>");
        content.addContent("<li><a href=\"cv.html\">mijn CV</a></li>");
        content.addContent("<li><a href=\"samenvatting_proefschrift.html\">samenvatting van mijn proefschrift</a></li>");
        content.addContent("<li><a href=\"reactie.html\">verzoek om reacties, opmerkingen op deze site</a></li>");
        content.addContent("<li>Technische documentatie: <a href=\"tech_doc_kj.html\">klaverjassen</a> en <a href=\"tech_doc_shob.html\">shob</a>.</li> </ol>");

        content.addContent("<li>Sport: <a href=\"sport.html\">sportpagina's</a></li> ");
        content.addContent("<ol> <li>Voetbal: <a href=\"sport_voetbal_nl_stats.html\">statistieken eredivisie</a> en <a href=\"sport_voetbal_nl_stats_more.html\">nog meer stats</a> </li>");
        content.addContent("<li>Nederlands betaald voetbal, seizoenen:<br> ");
        content.addContentReversed(eredivisie_links);
        content.addContent("</li>");
        content.addContent(" <li>Europacup voetbal, seizoenen:<br>");
        content.addContentReversed(europacup_links);
        content.addContent("</li>");
        content.addContent(" <li>schaatsuitslagen Olympische Winterspelen:<br>");
        content.addContentReversed(os_links);
        content.addContent("</li>");
        content.addContent(" <li>Wedstrijden Nederlands mannenelftal:<br>");
        content.addContentReversed(ekwk_links);
        content.addContent("</li>");
        content.addContent(" <li>Wedstrijden Nederlands vrouwenelftal:<br>");
        content.addContentReversed(ekwk_D_links);
        content.addContent("</li> </ol>");

        content.addContent("<li>Bookmarks: <ol> <li> <a href=\"bookmarks_sport.html\">sport</a>, ");
        content.addContent("<a href=\"bookmarks_treinen.html\">treinen</a>, ");
        content.addContent("<a href=\"bookmarks_media.html\">media</a> en ");
        content.addContent("<a href=\"bookmarks_computers.html\">computers en internet</a>.</li> </ol> </ol>");

        auto hb = HeadBottomInput(last_dd);
        hb.title = "Overzicht van de website van Edwin Spee";
        hb.css = StyleSheetType::SeparateFile;
        hb.copyTitleToH1 = false;
        hb.body = table::yellowRed(content, hb.title);
        auto pageContent = HeadBottom::getPage(hb);

        updateIfDifferent::update("../pages/overzicht.html", pageContent);
    }
}
