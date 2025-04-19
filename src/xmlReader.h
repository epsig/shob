#pragma once

#include <string>
#include <set>
#include <vector>

struct Catowner
{
    std::string           owner;
    std::set<std::string> cats;
};

Catowner load(const std::string& file);

std::vector<std::pair<std::string, std::string>> loadPairs(const std::string& file, const std::string& path, const std::string& attr);
