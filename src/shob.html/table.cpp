
#include "table.h"

namespace shob::html
{
    std::vector<std::string> table::buildTable(const tableContent& content)
    {
        std::vector<std::string> table;
        table.emplace_back("<table>");
        if ( ! content.header.data.empty())
        {
            table.push_back(buildHeader(content.header));
        }
        for (const auto& row : content.body)
        {
            table.push_back(buildRow(row));
        }
        table.emplace_back("</table>");
        return table;
    }

    std::string table::buildRow(const rowContent& content)
    {
        return buildRow(content, "<td>", "</td>");
    }

    std::string table::buildHeader(const rowContent& content)
    {
        return buildRow(content, "<th>", "</th>");
    }

    std::string table::buildRow(const rowContent& content, const std::string& tag1, const std::string& tag2)
    {
        std::string row = "<tr>";
        for (const auto& col : content.data)
        {
            row += tag1 + col + tag2;
        }
        row += "</tr>";
        return row;
    }

}
