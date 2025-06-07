
#pragma once
#include <string>
#include <vector>

namespace shob::html
{
    class rowContent
    {
    public:
        std::vector<std::string> data;
        void addContent(const rowContent& extra);
    };

    class tableContent
    {
    public:
        rowContent header;
        std::vector<rowContent> body;
        bool empty() const { return body.empty() && header.data.empty(); }
    };

    class table
    {
    public:
        static rowContent buildTable(const tableContent& content);
    private:
        static std::string buildRow(const rowContent& content);
        static std::string buildHeader(const rowContent& content);
        static std::string buildRow(const rowContent& content, const std::string& tag1, const std::string& tag2);
    };
}
