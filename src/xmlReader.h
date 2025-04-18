#pragma once

#include <string>
#include <set>

struct Catowner
{
    std::string           owner;
    std::set<std::string> cats;
};

Catowner load(const std::string& file);
