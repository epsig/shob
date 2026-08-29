#include "FormatBookmarks.h"
#include "HeadBottom.h"
#include "../shob.bookmarks/ConfigurableBookmarks.h"
#include "../shob.bookmarks/CurrentEvents.h"
#include "../shob.html/updateIfNewer.h"
#include "../shob.general/shobException.h"

namespace shob::pages
{
    using namespace shob::bookmarks;
    using namespace shob::general;

    FormatBookmarks::FormatBookmarks(const std::string& folder, const int dd)
        : bookmarks(folder), dd(dd)
    {
    }

    MultipleStrings FormatBookmarks::inList(const MultipleStrings& data)
    {
        MultipleStrings return_value;
        return_value.addContent("<ul>");
        for (const auto& line : data.data)
        {
            return_value.addContent("<li>" + line + "</li>");
        }
        return_value.addContent("</ul>");
        return return_value;
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
                left = inList(bookmarks.getEventsForBlock(content[i].name).printAll());
            }
            if (i + 1 >= (int)content.size())
            {
                right = MultipleStrings();
                row = html::table::yellowRed(left, right, content[i].title, "");
            }
            else
            {
                right = inList(bookmarks.getEventsForBlock(content[i + 1].name).printAll());
                row = html::table::yellowRed(left, right, content[i].title, content[i + 1].title);
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
        std::swap(hb.body, blocks[0]);
        for (int i = 1; i < blocks.size(); i++)
        {
            hb.body.addContent(blocks[i]);
        }
        auto pageContent = HeadBottom::getPage(hb);

        if (is_tmp)
        {
            html::updateIfDifferent::update("../pages/tmp_bookmarks_" + page + ".html", pageContent);
        }
        else
        {
            html::updateIfDifferent::update("../pages/bookmarks_" + page + ".html", pageContent);
        }
    }

    MultipleStrings FormatBookmarks::currentEventsLinks() const
    {
        auto currentEvents = CurrentEvents::getCurrentBookmarks("bookmarks", dd);

        auto events = currentEvents.printAll();
        if (events.length() == 0)
        {
            events.addContent("geen grote evenementen deze maand.");
        }

        return inList(events);
    }

}
