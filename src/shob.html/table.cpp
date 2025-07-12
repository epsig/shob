
#include "table.h"

namespace shob::html
{
    void multipleStrings::addContent(multipleStrings& extra)
    {
        for (auto& r : extra.data)
        {
            data.emplace_back(std::move(r));
        }
    }

    void multipleStrings::addContent(std::string extra)
    {
        data.emplace_back(std::move(extra));
    }

    multipleStrings table::buildTable(const tableContent& content)
    {
        multipleStrings table;
        if (content.empty()) { return table; }

        table.data.emplace_back("<table>");
        if ( ! content.header.data.empty())
        {
            table.data.push_back(buildHeader(content.header));
        }
        for (const auto& row : content.body)
        {
            table.data.push_back(buildRow(row));
        }
        table.data.emplace_back("</table>");
        return table;
    }

    std::string table::buildRow(const multipleStrings& content)
    {
        return buildRow(content, "<td>", "</td>");
    }

    std::string table::buildHeader(const multipleStrings& content)
    {
        return buildRow(content, "<th>", "</th>");
    }

    std::string table::buildRow(const multipleStrings& content, const std::string& tag1, const std::string& tag2)
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
