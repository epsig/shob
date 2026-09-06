
#include "table.h"
#include "funcs.h"
#include <boost/regex.hpp>

namespace shob::html
{
    using namespace shob::general;

    MultipleStrings table::buildTable(const tableContent& content) const
    {
        MultipleStrings table;

        std::string zeroWidth = settings_.isCompatible ? "0" : "\"0\"";

        std::string idTag;
        if (!id.empty()) idTag = " id=\"" + id + "\"";

        if (content.empty()) { return table; }

        if (content.title.empty())
        {
            if (withBorder)
            {
                table.data.emplace_back("<table border cellspacing=" + zeroWidth + idTag + ">");
            }
            else
            {
                table.data.emplace_back("<table" + idTag + ">");
            }
        }
        else
        {
            size_t cols = 1;
            if (!content.header.data.empty()) cols = content.header.data.size();
            table.data.emplace_back("<table border cellspacing=" + zeroWidth+idTag+">" + buildHeader(content.title, cols));
        }

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

    MultipleStrings table::buildTable(const std::vector<tableContent>& content) const
    {
        MultipleStrings table;
        if (content.empty()) { return table; }

        std::string idTag;
        if (!id.empty()) idTag = " id=\"" + id + "\"";

        if (withBorder)
        {
            const std::string zeroWidth = settings_.isCompatible ? "0" : "\"0\"";
            table.data.emplace_back("<table border cellspacing=" + zeroWidth + idTag + ">");
        }
        else
        {
            table.data.emplace_back("<table frame=\"box\"" + idTag + ">");
        }

        for (const auto& subTable : content)
        {
            if ( ! subTable.title.empty())
            {
                size_t cols;
                if (!subTable.colWidths.empty())
                {
                    cols = 0;
                    for (const auto col : subTable.colWidths) cols += col;
                }
                else if (!subTable.header.data.empty())
                {
                    cols = subTable.header.data.size();
                }
                else
                {
                    cols = subTable.body[0].data.size();
                }
                table.data.emplace_back(buildHeader(subTable.title, cols));
            }
            if (!subTable.header.data.empty())
            {
                if (subTable.colWidths.empty())
                {
                    table.data.push_back(buildHeader(subTable.header));
                }
                else
                {
                    table.data.push_back(buildHeader(subTable.header, subTable.colWidths));
                }
            }
            for (const auto& row : subTable.body)
            {
                if (subTable.colWidths.empty())
                {
                    table.data.push_back(buildRow(row));
                }
                else
                {
                    table.data.push_back(buildRow(row, subTable.colWidths));
                }
            }
        }

        table.data.emplace_back("</table>");
        return table;
    }

    MultipleStrings table::tableOfTwoTables(MultipleStrings& left, MultipleStrings& right)
    {
        auto retVal = MultipleStrings();
        retVal.addContent(R"(<div class="row"><div class="column">)");
        retVal.addContent(left);
        retVal.addContent("</div><div class=\"column\">");
        retVal.addContent(right);
        retVal.addContent("</div> </div>");

        return retVal;
    }

    /// <summary>
    /// The style sheet makes the titles red on yellow background and the main text in the column black on a light yellow background.
    /// The titles are in a separate row above the content.
    /// </summary>
    /// <param name="left"> The content for the left column. </param>
    /// <param name="right"> The content for the right column. </param>
    /// <param name="title_left"> The title for the left column. </param>
    /// <param name="title_right"> The title for the right column. </param>
    /// <returns> A MultipleStrings object containing the formatted HTML for the two columns. </returns>
    MultipleStrings table::yellowRed(const MultipleStrings& left, const MultipleStrings& right, const std::string& title_left, const std::string& title_right)
    {
        auto retVal = MultipleStrings();
        retVal.addContent(R"(<div class="row"><div class="column">)");
        retVal.addContent(R"(<div class="colh">)");
        retVal.addContent(title_left);
        retVal.addContent("</div>");
        retVal.addContent(R"(<div class="colb">)");
        for (const auto& row : left.data)
        {
            retVal.addContent(row);
        }
        retVal.addContent("</div>");
        retVal.addContent("</div><div class=\"column\">");
        retVal.addContent(R"(<div class="colh">)");
        retVal.addContent(title_right);
        retVal.addContent("</div>");
        retVal.addContent(R"(<div class="colb">)");
        for (const auto& row : right.data)
        {
            retVal.addContent(row);
        }
        retVal.addContent("</div>");
        retVal.addContent("</div> </div>");
        return retVal;
    }

    /// <summary>
    /// The style sheet makes the title red on yellow background and the main text in the column black on a light yellow background.
    /// The title is in a separate row above the content.
    /// </summary>
    /// <param name="left"> The content for the left column. </param>
    /// <param name="title"> The title for the column. </param>
    /// <returns> A MultipleStrings object containing the formatted HTML for the column. </returns>
    MultipleStrings table::yellowRed(const MultipleStrings& left, const std::string& title)
    {
        auto retVal = MultipleStrings();
        retVal.addContent(R"(<div class="row"><div class="column1000">)");
        retVal.addContent(R"(<div class="colh">)");
        retVal.addContent(title);
        retVal.addContent("</div>");
        retVal.addContent(R"(<div class="colb">)");
        for (const auto& row : left.data)
        {
            retVal.addContent(row);
        }
        retVal.addContent("</div>");
        retVal.addContent("</div> </div>");
        return retVal;
    }

    MultipleStrings table::tableOfThreeTables(MultipleStrings& left, MultipleStrings& middle, MultipleStrings& right)
    {
        auto retVal = MultipleStrings();
        retVal.addContent(R"(<div class="row"><div class="column3">)");
        retVal.addContent(left);
        retVal.addContent("</div><div class=\"column3\">");
        retVal.addContent(middle);
        retVal.addContent("</div><div class=\"column3\">");
        retVal.addContent(right);
        retVal.addContent("</div> </div>");

        return retVal;
    }

    std::string table::buildRow(const MultipleStrings& content, const std::vector<int>& colWidths)
    {
        std::vector<std::string> tag1;
        std::vector<std::string> tag2;
        for (int colWidth : colWidths)
        {
            tag2.emplace_back("</td>");
            if (colWidth == 1)
            {
                tag1.emplace_back("<td>");
            }
            else
            {
                tag1.emplace_back("<td colspan=\"" + std::to_string(colWidth) + "\">");
            }
        }
        return buildRow(content, tag1, tag2);
    }

    std::string table::buildRow(const MultipleStrings& content)
    {
        return buildRow(content, "<td>", "</td>");
    }

    std::string table::buildHeader(const MultipleStrings& content)
    {
        return buildRow(content, "<th>", "</th>");
    }

    std::string table::buildHeader(const MultipleStrings& content, const std::vector<int>& colWidths)
    {
        std::vector<std::string> tag1;
        std::vector<std::string> tag2;
        for (int colWidth : colWidths)
        {
            tag2.emplace_back("</th>");
            if (colWidth == 1)
            {
                tag1.emplace_back("<th>");
            }
            else
            {
                tag1.emplace_back("<th colspan=\"" + std::to_string(colWidth) + "\">");
            }
        }
        return buildRow(content, tag1, tag2);
    }

    std::string table::buildHeader(const std::string& s, const size_t cols)
    {
        MultipleStrings content;
        content.data.push_back(s);
        return buildRow(content, "<th colspan=\"" + std::to_string(cols) + "\" class=h>", "</th>");
    }

    std::string table::buildRow(const MultipleStrings& content, const std::string& tag1, const std::string& tag2)
    {
        std::string row = "<tr>";
        boost::regex expression("\\d+-\\d+");
        bool extraLine = true;
        boost::cmatch what;
        for (int i = 0; i < static_cast<int>(content.data.size()); i++)
        {
            auto& col = content.data[i];
            if (funcs::isAcronymOnly(col) && col.find(" =") != std::string::npos)
            {
                if (extraLine) row += "\n";
                row += "<td class=r>" + col + tag2;
                if (i < static_cast<int>(content.data.size()) - 1) row += "\n";
                extraLine = false;
            }
            else if (regex_search(col.c_str(), expression) && tag1.find("class") == std::string::npos)
            {
                row += "<td class=c>" + col + tag2;
            }
            else
            {
                row += tag1 + col + tag2;
                extraLine = true;
            }
        }
        row += "</tr>";
        return row;
    }

    std::string table::buildRow(const MultipleStrings& content, const std::vector<std::string>& tag1, const std::vector<std::string>& tag2)
    {
        std::string row = "<tr>";
        boost::regex expression("\\d+-\\d+");
        boost::cmatch what;
        for (int i = 0; i < static_cast<int>(content.data.size()); i++)
        {
            auto& col = content.data[i];
            if (regex_search(col.c_str(), expression))
            {
                row += "<td class=c>" + col + tag2[i];
            }
            else
            {
                row += tag1[i] + content.data[i] + tag2[i];
            }
        }
        row += "</tr>";
        return row;
    }

}
