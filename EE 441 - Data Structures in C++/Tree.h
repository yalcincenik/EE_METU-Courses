#ifndef TREE_H_INCLUDED
#define TREE_H_INCLUDED

#pragma once

#include <stdio.h>
#include <iostream>

#include "Node.h"

class Tree
{
private:
    // Create a root Note for tree by using the class Node
  Node* root;
  int visitedNodesInsert;
  int visitedNodesDelete;
  int visitedNodesSearch;

public:
  // Constructor
  Tree();

  // Getters
  int getvisitedNodesInsert();
  int getvisitedNodesSearch();
  int getvisitedNodesDelete();
  Node* getNode(); // Returns the desired Node
  // Node insertion to tree
  void insertNode(Node* node);
  // Node Deletion from tree
  void deleteNode(Node* node);
  // Check the state of the tree
  bool treeEmpty();
};

#endif // TREE_H_INCLUDED
