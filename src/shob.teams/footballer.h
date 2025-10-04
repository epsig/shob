
#pragma once

#include <string>
#include <map>

namespace shob::teams
{
    class footballer
    {
    public:
        std::string firstName;
        std::string lastName;
        std::string insertion;
        std::string fullName() const;
    };

    class footballers
    {
    public:
        void initFromFile(const std::string& filename);
        std::string expand(const std::string& name) const;
    private:
        std::map<std::string, footballer> all;
    };
}
