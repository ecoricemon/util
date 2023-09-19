#include <iostream>
#include <algorithm>
#include <queue>
#include <unordered_set>
using namespace std;

// ##### LIST #####

struct ListNode {
    int val;
    ListNode *next;
    ListNode() : val(0), next(nullptr) {}
    ListNode(int x) : val(x), next(nullptr) {}
    ListNode(int x, ListNode *next) : val(x), next(next) {}
};

void addNode(ListNode* head, int val = 0, ListNode* next = nullptr) {
    ListNode* n = head;
    while (n->next)
        n = n->next;
    n->next = new ListNode(val, next);
}

void freeList(ListNode* head) {
    unordered_set<ListNode*> nodes;
    while (head) {
        // Cycle?
        if (nodes.find(head) != nodes.end())
            break;
        nodes.insert(head);
        head = head->next;
    }
    for (auto node : nodes)
        delete node;
}

bool isSame(ListNode* a, ListNode* b) {
    if (!(a || b))
        return true;
    bool res = true;
    while (a && b) {
        if (a->val != b->val) {
            res = false;
            break;
        }
        a = a->next;
        b = b->next;
    }
    if (a || b)
        res = false;
    return res;
}

ListNode* makeList(string s) {
    s.erase(remove(s.begin(), s.end(), '['), s.end());
    s.erase(remove(s.begin(), s.end(), ']'), s.end());
    s.erase(remove(s.begin(), s.end(), ' '), s.end());
    if (s.length() == 0)
        return nullptr;
    s += ",";

    ListNode dummy, *node = &dummy;
    auto pos = s.find_first_of(',');
    while (pos != string::npos) {
        auto ss = s.substr(0, pos);
        s.erase(0, pos + 1);
        pos = s.find_first_of(',');

        node->next = new ListNode(stoi(ss));
        node = node->next;
    }

    return dummy.next;
}

// ##### TREE #####

struct TreeNode {
    int val;
    TreeNode *left;
    TreeNode *right;
    TreeNode() : val(0), left(nullptr), right(nullptr) {}
    TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
    TreeNode(int x, TreeNode *left, TreeNode *right) : val(x), left(left), right(right) {}
};

TreeNode* addLeft(TreeNode* node, int left) {
    node->left = new TreeNode(left);
    return node->left;
}

TreeNode* addRight(TreeNode* node, int right) {
    node->right = new TreeNode(right);
    return node->right;
}

void freeTree(TreeNode* root) {
    if (!root)
        return;
    freeTree(root->left);
    freeTree(root->right);
    free(root);
}

TreeNode* makeTree(string s) {
    s.erase(remove(s.begin(), s.end(), '['), s.end());
    s.erase(remove(s.begin(), s.end(), ']'), s.end());
    s.erase(remove(s.begin(), s.end(), ' '), s.end());
    if (s.length() == 0)
        return nullptr;
    s += ",";

    TreeNode* root = nullptr;
    queue<TreeNode*> q;
    auto pos = s.find_first_of(',');
    while (pos != string::npos) {
        auto ss = s.substr(0, pos);
        s.erase(0, pos + 1);
        pos = s.find_first_of(',');

        if (ss == "null") {
            if (!q.empty()) 
                q.pop();
            continue;
        }
        
        auto node = new TreeNode(stoi(ss));
        if (q.empty()) {
            q.push(node);
            q.push(node);
            root = node;
        } else {
            if (q.size() % 2 == 0)
                q.front()->left = node;
            else
                q.front()->right = node;
            q.pop();
            q.push(node);
            q.push(node);
        }
    }
    return root;
}

bool isSame(TreeNode* a, TreeNode* b) {
    if (!(a || b))
        return true;
    if ((a && !b) || (!a && b))
        return false;
    if (a->val != b->val)
        return false;
    if (!isSame(a->left, b->left))
        return false;
    if (!isSame(a->right, b->right))
        return false;
    return true;
}


// ##### 2D vector #####

vector<vector<int>> make2DVector(string s) {
    vector<vector<int>> mat;
    
    auto makeRow = [](string& s)->vector<int> {
        vector<int> row;
        s += ',';
        auto pos = s.find_first_of(',');
        while (pos != string::npos) {
            auto ss = s.substr(0, pos);
            if (ss.length() == 0)
                break;
            s.erase(0, pos + 1);
            pos = s.find_first_of(',');
            row.push_back(stoi(ss));
        }
        s = "";
        return row;
    };

    int open = 0;
    string ss;
    for (char c : s) {
        switch (c) {
        case '[':
            open++;
            break;
        case ']':
            open--;
            if (open == 1)
                mat.push_back(makeRow(ss));
            break;
        default:
            if (open == 2)
                ss += c;
            break;
        }
    }
    return mat;
}
