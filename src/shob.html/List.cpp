#include "List.h"

namespace shob::html
{
    using namespace shob::general;

    MultipleStrings List::inUnorderedList(const MultipleStrings& s)
    {
        MultipleStrings return_value;
        return_value.addContent("<ul>");
        for (const auto& line : s.data)
        {
            return_value.addContent("<li>" + line + "</li>");
        }
        return_value.addContent("</ul>");
        return return_value;
    }
}
