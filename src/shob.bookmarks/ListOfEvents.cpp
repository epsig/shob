#include "ListOfEvents.h"
#include <format>

namespace shob::bookmarks
{
    using namespace shob::general;

    void ListOfEvents::add(const Event& event)
    {
        events.push_back(event);
    }

    MultipleStrings ListOfEvents::printAll() const
    {
        MultipleStrings return_value;
        for (const auto& e : events)
        {
            return_value.addContent(e.link());
        }
        return return_value;
    }

    MultipleStrings ListOfEvents::printFirstAndLast() const
    {
        MultipleStrings return_value;
        if (events.empty())
        {
            return return_value;
        }
        return_value.addContent(events.front().link());
        if (events.size() == 1)
        {
            return return_value;
        }
        return_value.addContent(" t/m ");
        return_value.addContent(events.back().link());
        return return_value;
    }

    MultipleStrings ListOfEvents::printAsFooterNewStyle() const
    {
        MultipleStrings return_value;
        return_value.addContent(R"(<div class="footer">)");
        for (size_t i = 0; i < events.size(); ++i)
        {
            const auto& e = events[i];
            std::string extra_last;
            std::string extra_space;
            if (i > 0 && i < 4)
            {
                extra_space = " ";
            }
            if (i == events.size() - 1)
            {
                extra_last = "|";
            }
            if (e.url.empty())
            {
                return_value.addContent(std::format("| {}{}{}", e.name, extra_space, extra_last));
            }
            else
            {
                return_value.addContent(std::format("| {}{}{}", e.link(), extra_space, extra_last));
            }
        }
        return_value.addContent(R"(</div>)");
        return return_value;
    }

    MultipleStrings ListOfEvents::printAsFooterOldStyle() const
    {
        MultipleStrings return_value;
        return_value.addContent(R"(<table width="100%"> <tr> <td width="10%">&nbsp;</td>)");
        return_value.addContent(R"(<td width="80%" align=center><table border cellspacing="0">)");
        for (size_t i = 0; i < events.size(); ++i)
        {
            const auto& e = events[i];
            std::string extra_first;
            std::string extra_last;
            if (i == 0)
            {
                extra_first = "<tr>";
            }
            if (i == events.size() - 1)
            {
                extra_last = "</tr> ";
            }
            if (e.url.empty())
            {
                return_value.addContent(std::format("{}<td>{}</td> {}", extra_first, e.name, extra_last));
            }
            else
            {
                return_value.addContent(std::format("{}<td>{}</td> {}", extra_first, e.link(), extra_last));
            }
        }
        return_value.addContent("</table> ");
        return_value.addContent("</td> <td width=\"10%\">&nbsp;</td> </tr> </table>");

        return return_value;
    }
}
