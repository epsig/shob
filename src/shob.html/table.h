
#pragma once
#include <string>
#include <vector>

namespace shob::html
{
    class multipleStrings
    {
    public:
        std::vector<std::string> data;
        void addContent(multipleStrings& extra);
        void addContent(std::string extra);
    };

    class tableContent
    {
    public:
        multipleStrings header;
        std::vector<multipleStrings> body;
        bool empty() const { return body.empty() && header.data.empty(); }
    };

    class table
    {
    public:
        static multipleStrings buildTable(const tableContent& content);
    private:
        static std::string buildRow(const multipleStrings& content);
        static std::string buildHeader(const multipleStrings& content);
        static std::string buildRow(const multipleStrings& content, const std::string& tag1, const std::string& tag2);
    };
}
