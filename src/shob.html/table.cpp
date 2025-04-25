
#include "table.h"

namespace shob::html
{
    std::vector<std::string> table::buildTable(const std::vector<std::vector<std::string>>& content)
    {
        std::vector<std::string> table;
        table.emplace_back("<table>");
        table.push_back(buildHeader(content[0]));
        for (size_t i = 1; i < content.size(); i++)
        {
            table.push_back(buildRow(content[i]));
        }
        table.emplace_back("</table>");
        return table;
    }

    std::string table::buildRow(const std::vector<std::string>& content)
    {
        std::string row = "<tr>";
        for (const auto& col : content)
        {
            row += "<td>" + col + "</td>";
        }
        row += "</tr>";
        return row;
    }

    std::string table::buildHeader(const std::vector<std::string>& content)
    {
        std::string row = "<tr>";
        for (const auto& col : content)
        {
            row += "<th>" + col + "</th>";
        }
        row += "</tr>";
        return row;
    }
}
