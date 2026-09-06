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
            MultipleStrings left, right, row;
            if (content[i].title == "reserved")
            {
                left = currentEventsLinks();
                content[i].title = "Actueel";
            }
            else
            {
                left = List::inUnorderedList(bookmarks.getEventsForBlock(content[i].name).printAll());
            }
            if (i + 1 >= (int)content.size())
            {
                right = MultipleStrings();
                row = table::yellowRed(left, right, content[i].title, "");
            }
            else
            {
                right = List::inUnorderedList(bookmarks.getEventsForBlock(content[i + 1].name).printAll());
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
            for (int i = 1; i < blocks.size(); i++)
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

    void FormatBookmarks::rebuildOwnSportLinks() const
    {
        const auto os = OwnSportPages::getOlympicIceSkating();
        const auto ekwk = OwnSportPages::getEkWkSoccer();
        const auto ekwk_D = OwnSportPages::getEkWkSoccerWoman();
        const auto eredivisie = OwnSportPages::getDutchSoccer();
        const auto europacup = OwnSportPages::getEuropacupSoccer();

        auto os_links = os.printAll();
        auto ekwk_links = ekwk.printAll();
        auto ekwk_D_links = ekwk_D.printAll();
        auto eredivisie_links = eredivisie.printAll();
        auto europacup_links = europacup.printAll();

        MultipleStrings content;
        content.addContent("<ul> <li> Wedstrijden Nederlands mannenelftal: <br> ");
        content.addContentReversed(ekwk_links);
        content.addContent(". </li> <li> Wedstrijden Nederlands vrouwenelftal: <br> ");
        content.addContentReversed(ekwk_D_links);
        content.addContent(". </li> <li> Eindstand eredivisie, KNVB-beker en nacompetitie; <br> seizoen:");
        content.addContentReversed(eredivisie_links);
        content.addContent(". </li> <li> Nederlandse clubteams in de Europacup voetbal; <br> seizoen:");
        content.addContentReversed(europacup_links);
        content.addContent(". </li> <li> <a href=\"sport_voetbal_nl_stats.html\">Statistieken Eredivisie vanaf 1993</a>");
        content.addContent("en <a href=\"sport_voetbal_nl_stats_more.html\">nog meer stats</a>.");
        content.addContent("</li> <li> <a href=\"sport_voetbal_nl_jaarstanden.html\">Winterkampioen en jaarstanden vanaf 1993</a> |");
        content.addContent("<a href=\"sport_voetbal_nl_uit_thuis.html\">uit- en thuis standen vanaf 1993</a>.");
        content.addContent("</li> <li> Uitslagen Schaatsen:");
        content.addContentReversed(os_links);
        content.addContent(". </li> <li>Zie verder: <a href=\"bookmarks_sport.html\">sport links</a> </li> </ul>");

        auto hb = HeadBottomInput(20260905); // TODO: use current dd
        hb.title = "Sportpagina's op www.epsig.nl";
        hb.css = StyleSheetType::SeparateFile;
        hb.copyTitleToH1 = false;
        hb.body = table::yellowRed(content, hb.title);
        auto pageContent = HeadBottom::getPage(hb);

        updateIfDifferent::update("../pages/sport_new.html", pageContent);
    }
}
