
#pragma once
#include "../shob.general/multipleStrings.h"
#include <string>
#include <vector>

namespace shob::html
{
    class tableContent
    {
    public:
        general::multipleStrings header;
        std::vector<general::multipleStrings> body;
        bool empty() const { return body.empty() && header.data.empty(); }
    };

    class table
    {
    public:
        static general::multipleStrings buildTable(const tableContent& content, std::string title = "");
    private:
        static std::string buildRow(const general::multipleStrings& content);
        static std::string buildHeader(const general::multipleStrings& content);
        static std::string buildHeader(const std::string& s, const size_t cols);
        static std::string buildRow(const general::multipleStrings& content, const std::string& tag1, const std::string& tag2);
    };
}
