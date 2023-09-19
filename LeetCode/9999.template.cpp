

#include "../9999.helper.hpp"
#include <iostream>

using namespace std;

class Solution {
public:
    int foo(int a) {
        return 0;
    }
};

int main() {
    int input = 0; int ans = 0;

    Solution sol;
    auto ret = sol.foo(input);

    if (ret == ans)
        cout << "Pass" << endl;
    else
        cout << "Fail" << endl;

    return 0;
}