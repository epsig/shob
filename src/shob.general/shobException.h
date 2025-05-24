
#pragma once
#include <exception>
#include <string>
#include <cstddef>

namespace shob::general {
    class shobException : public std::exception
    {
    public:
        shobException(std::string msg) : message(std::move(msg)) {}
        //shobException(const std::string& msg, const double r) : message(msg + tos(r)) {}
        shobException(const std::string& msg, const int i) : message(msg + std::to_string(i)) {}
        shobException(const std::string& msg, const size_t i) : message(msg + std::to_string(i)) {}
        virtual const char* what() const throw() { return message.c_str(); }
    private:
        const std::string message;
        //std::string tos(const double r) { auto pls = probLibString(); return pls.double2str(r); }
    };
}
