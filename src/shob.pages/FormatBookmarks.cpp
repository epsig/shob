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

    MultipleStrings FormatBookmarks::InList(const MultipleStrings& data)
    {
        MultipleStrings return_value;
        return_value.addContent("<ul>");
        for (const auto& line : data.data)
        {
            return_value.addContent("<li>");
            return_value.addContent(line);
            return_value.addContent("</li>");
        }
        return_value.addContent("</ul>");
        return return_value;
    }

    void FormatBookmarks::RebuildBookmarks(const std::string& page)
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
            MultipleStrings left, right;
            if (content[i].title == "reserved")
            {
                left = CurrentEventsLinks();
                content[i].title = "Actueel";
            }
            else
            {
                left = InList(bookmarks.getEventsForBlock(content[i].name).printAll());
            }
            right = InList(bookmarks.getEventsForBlock(content[i+1].name).printAll());
            auto row = html::table::yellowRed(left, right, content[i].title, content[i+1].title);
            blocks.push_back(row);
        }

        auto hb = HeadBottomInput(dd);
        hb.title = props.title;
        hb.css = StyleSheetType::SeparateFile;
        hb.copyTitleToH1 = false;
        std::swap(hb.body, blocks[0]);
        for (int i = 1; i < blocks.size(); i++)
        {
            hb.body.addContent(blocks[i]);
        }
        auto pageContent = HeadBottom::getPage(hb);
        html::updateIfDifferent::update("../pages/bookmarks_" + page + "_new.html", pageContent);
    }

    MultipleStrings FormatBookmarks::CurrentEventsLinks()
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

}
