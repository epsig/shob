
#include "head_bottum.h"

namespace shob::pages
{
    html::rowContent headBottum::getPage(headBottumInput& input)
    {
        html::rowContent out;
        out.addContent("<html> <title>" + input.title + "</title> <body>");

        out.addContent("<h1>" + input.title + "</h1>");

        out.addContent(input.body);
        out.addContent("</body> </html>");

        return out;
    }
}

