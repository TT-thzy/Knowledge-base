## AVL树
在“二叉搜索树”章节中我们提到，在多次插入和删除操作后，二叉搜索树可能退化为链表。在这种情况下，所有操作的时间复杂度将从O(logn)劣化为O(n) 。

经过两次删除节点操作，这棵二叉搜索树便会退化为链表：
<img src = "..\..\..\..\picture service\dataStructures\70.png">

再例如，完美二叉树中插入两个节点后，树将严重向左倾斜，查找操作的时间复杂度也随之劣化:
<img src = "..\..\..\..\picture service\dataStructures\71.png">

1962 年 G. M. Adelson-Velsky 和 E. M. Landis 在论文“An algorithm for the organization of information”中提出了 AVL 树。论文中详细描述了一系列操作，确保在持续添加和删除节点后，AVL 树不会退化，从而使得各种操作的时间复杂度保持在O(logn)级别。换句话说，在需要频繁进行增删查改操作的场景中，AVL 树能始终保持高效的数据操作性能，具有很好的应用价值。

### 常见术语
AVL 树既是二叉搜索树，也是平衡二叉树，同时满足这两类二叉树的所有性质，因此是一种平衡二叉搜索树（balanced binary search tree）。

#### 结点高度
由于 AVL 树的相关操作需要获取节点高度，因此我们需要为节点类添加 height 变量：
```c
/* AVL 树节点结构体 */
TreeNode struct TreeNode {
    int val;
    int height;
    struct TreeNode *left;
    struct TreeNode *right;
} TreeNode;

/* 构造函数 */
TreeNode *newTreeNode(int val) {
    TreeNode *node;

    node = (TreeNode *)malloc(sizeof(TreeNode));
    node->val = val;
    node->height = 0;
    node->left = NULL;
    node->right = NULL;
    return node;
}
```
“节点高度”是指从该节点到它的最远叶节点的距离，即所经过的“边”的数量。需要特别注意的是，叶节点的高度为0，而空节点的高度为-1。我们将创建两个工具函数，分别用于获取和更新节点的高度：
```c
/* 获取节点高度 */
int height(TreeNode *node) {
    // 空节点高度为 -1 ，叶节点高度为 0
    if (node != NULL) {
        return node->height;
    }
    return -1;
}

/* 更新节点高度 */
void updateHeight(TreeNode *node) {
    int lh = height(node->left);
    int rh = height(node->right);
    // 节点高度等于最高子树高度 + 1
    if (lh > rh) {
        node->height = lh + 1;
    } else {
        node->height = rh + 1;
    }
}
```
#### 结点平衡因子
节点的平衡因子（balance factor）定义为节点左子树的高度减去右子树的高度，同时规定空节点的平衡因子为 0。我们同样将获取节点平衡因子的功能封装成函数，方便后续使用：
```c
/* 获取平衡因子 */
int balanceFactor(TreeNode *node) {
    // 空节点平衡因子为 0
    if (node == NULL) {
        return 0;
    }
    // 节点平衡因子 = 左子树高度 - 右子树高度
    return height(node->left) - height(node->right);
}
```
>
设平衡因子为 f，则一颗AVL树任何结点的平衡因子皆满足-1 <= f <= 1
>

### AVL树旋转
AVL 树的特点在于“旋转”操作，它能够在不影响二叉树的中序遍历序列的前提下，使失衡节点重新恢复平衡。换句话说，<b>旋转操作既能保持“二叉搜索树”的性质，也能使树重新变为“平衡二叉树”</b>。

我们将平衡因子绝对值>1的节点称为“失衡节点”。根据节点失衡情况的不同，旋转操作分为四种：右旋、左旋、先右旋后左旋、先左旋后右旋。下面详细介绍这些旋转操作。

#### 右旋
节点下方为平衡因子。从底至顶看，二叉树中首个失衡节点是“节点 3”。我们关注以该失衡节点为根节点的子树，将该节点记为 node ，其左子节点记为 child ，执行“右旋”操作。完成右旋后，子树恢复平衡，并且仍然保持二叉搜索树的性质。

<b>Step 1: </b>
<img src = "..\..\..\..\picture service\dataStructures\72.png">

<b>Step 2: </b>
<img src = "..\..\..\..\picture service\dataStructures\73.png">

<b>Step 3: </b>
<img src = "..\..\..\..\picture service\dataStructures\74.png">

<b>Step 4: </b>
<img src = "..\..\..\..\picture service\dataStructures\75.png">

当节点 child 有右子节点（记为 grand_child ）时，需要在右旋中添加一步：将 grand_child 作为 node 的左子节点。
<img src = "..\..\..\..\picture service\dataStructures\76.png">

“向右旋转”是一种形象化的说法，实际上需要通过修改节点指针来实现，代码如下所示：
```c
/* 右旋操作 */
TreeNode *rightRotate(TreeNode *node) {
    TreeNode *child, *grandChild;
    child = node->left;
    grandChild = child->right;
    // 以 child 为原点，将 node 向右旋转
    child->right = node;
    node->left = grandChild;
    // 更新节点高度
    updateHeight(node);
    updateHeight(child);
    // 返回旋转后子树的根节点
    return child;
}
```

#### 左旋

#### 先左旋后右旋

#### 先右旋后左旋

#### 旋转的选择

### 常用操作

### 应用场景