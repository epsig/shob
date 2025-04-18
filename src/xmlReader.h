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

struct Goal
{
    std::string min;
    std::string score;
};

struct Game
{
    std::vector<Goal> data;
};

Game loadChronological(const std::string& file);
